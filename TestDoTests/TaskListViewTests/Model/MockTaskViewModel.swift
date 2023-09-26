//
//  MockTaskViewModel.swift
//  TestDoTests
//
//  Created by Keshu Rai on 26/09/23.
//

import XCTest
@testable import TestDo

class MockTaskListViewModel: TaskListViewModelProtocol {
    
    @Published var tasks: [TaskItem] = []
    @Published var navigateToCreateTaskView = false
    var selectedTask: TaskItem?
    
    var createTaskCalled = false
    var updateTaskCalled = false
    var deleteCalled = false
    
        
    func getAllTasks() throws -> [TaskItem]? {
        // Simulate returning a list of tasks for testing
        let mockTasks = [TaskItem(id: UUID(), title: "Task 1", createdAt: Date(), isCompleted: false),
                         TaskItem(id: UUID(), title: "Task 2", createdAt: Date(), isCompleted: true)]
        tasks = mockTasks
        return mockTasks
    }
    
    func markTaskComplete(task: TaskItem) {
        // Simulate marking a task as complete
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].isCompleted.toggle()
        }
    }
    
    func updateTask(_ task: TaskItem) throws {
        updateTaskCalled = true

        // Simulate updating a task
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index] = task
        }
    }
    
    func createTask(_ task: TaskItem) throws {
        createTaskCalled = true

        // Simulate creating a task
        guard task.title.isEmpty == false else {
            throw TaskErrors.invalidTextLength
        }
        tasks.append(task)
    }
    
    func delete(_ id: UUID) throws {
        deleteCalled = true

        // Simulate deleting a task
        tasks.removeAll { $0.id == id }
    }
}
