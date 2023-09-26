//
//  TaskViewModel.swift
//  TestDo
//
//  Created by Keshu Rai on 24/09/23.
//

import Foundation
import SwiftUI
import Combine

struct TaskConstants {
    static let titleLength = 2
}
enum TaskErrors : LocalizedError {
    
    case invalidTextLength
    case unknown
    case taskNotAvailable
    case failed(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidTextLength:
            return "Task title should have atleast \(TaskConstants.titleLength) characters"
        case .unknown:
            return "Some unknown error occured"
        case .taskNotAvailable:
            return "Unable to find the task"
        case .failed(let message):
            return message
        }
    }
    
}

protocol TaskListViewModelProtocol: ObservableObject {
    
    var tasks: [TaskItem] { get set }
    
    var navigateToCreateTaskView: Bool { get set }
    var selectedTask: TaskItem? { get set }
    
    func getAllTasks() throws -> [TaskItem]?
    func markTaskComplete(task: TaskItem)
    func updateTask(_ task : TaskItem) throws
    func createTask(_ task: TaskItem) throws
    func delete(_ id: UUID) throws
}


class TaskViewModel : TaskListViewModelProtocol {
    
    @Published var tasks : [TaskItem] = []
    @Published var navigateToCreateTaskView = false
    
    var selectedTask : TaskItem?
    let taskManager : TaskManager!
    
    init(taskManager : TaskManager) {
        self.taskManager = taskManager
        _ = try? self.getAllTasks()
    }
    
    func createTask(_ task : TaskItem) throws {
        
        guard task.title.isEmpty == false && task.title.count > TaskConstants.titleLength else {
            throw TaskErrors.invalidTextLength
        }
        
        try taskManager.createTask(task)
        tasks.append(task)

    }
    
    func getAllTasks() throws -> [TaskItem]? {
        let allTask = try taskManager.getAllTasks()
        if let allTask = allTask {
            tasks = allTask
        }
        return allTask
    }
    
    func getTaskById(_ id: UUID) -> TaskItem? {
        return taskManager.getTaskById(id)
    }
    
    func updateTask(_ task: TaskItem) throws {
        guard task.title.isEmpty == false && task.title.count > TaskConstants.titleLength else {
            throw TaskErrors.invalidTextLength
        }
        try taskManager.updateTask(task)
        // Update the tasks property with the updated task.
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index] = task
        }
       
    }
    
    func markTaskComplete(task : TaskItem) {
        //handle selected task
        var completedTask = task
        completedTask.isCompleted.toggle()
        try? updateTask(completedTask)
    }
    
    func delete(_ id: UUID) throws {
        try taskManager.delete(id)
        tasks.removeAll { $0.id == id }
    }
}
