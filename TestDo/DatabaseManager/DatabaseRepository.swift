//
//  DatabaseRepository.swift
//  TestDo
//
//  Created by Keshu Rai on 23/09/23.
//

import Foundation
import CoreData

protocol DatabaseRepositoryProtocol {
    func createTask(_ task : TaskItem) throws
    func getAllTasks() throws -> [TaskItem]?
    func getTaskById(_ id : UUID) -> TaskItem?
    func updateTask(_ task : TaskItem) throws
    func delete(_ id : UUID) throws
}

class DatabaseRepository : DatabaseRepositoryProtocol {
    
    var container : NSPersistentContainer?
    
    init(container : NSPersistentContainer? = PersistenceController.shared.container) {
        self.container = container
    }
    
    func createTask(_ task : TaskItem) throws {
        guard container != nil else {
            throw TaskErrors.failed("Cant find persistant store")
        }
        let taskitem = Tasks(context: container!.viewContext)
        taskitem.id = task.id
        taskitem.title = task.title
        taskitem.dateCreated = taskitem.dateCreated
        taskitem.isCompleted = taskitem.isCompleted
        
        do {
            try PersistenceController.shared.container.viewContext.save()
        } catch {
            throw TaskErrors.failed(error.localizedDescription)
        }
    }
    
    func getAllTasks() throws -> [TaskItem]? {
        let fetchRequest = Tasks.fetchRequest()
        var taskItems : [TaskItem]? = []
        do {
            let fetchedTasks = try container?.viewContext.fetch(fetchRequest)
            for item in fetchedTasks! {
                taskItems?.append(TaskItem(id: item.id ?? UUID(), title: item.title ?? "", createdAt: item.dateCreated ?? Date(), isCompleted: item.isCompleted))
            }
            return taskItems
        } catch {
            throw TaskErrors.failed(error.localizedDescription)
        }
    }
    
    func getTaskById(_ id : UUID) -> TaskItem? {
        if let item = getCDTaskById(id) {
            return TaskItem(id: item.id ?? UUID(), title: item.title ?? "", createdAt: item.dateCreated ?? Date(), isCompleted: item.isCompleted)
        }
        return nil
       
    }
    
    private func getCDTaskById(_ id : UUID) -> Tasks? {
        let fetchRequest = Tasks.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        do {
            let result = try container?.viewContext.fetch(fetchRequest)
            if let item = result?.first {
                return item
            }
        } catch {
            debugPrint(error.localizedDescription)
        }
        return nil
    }
    
    func updateTask(_ task : TaskItem) throws {
        guard let oldTask = getCDTaskById(task.id) else {
            throw TaskErrors.taskNotAvailable
        }
        oldTask.title = task.title
        oldTask.isCompleted = task.isCompleted
        do {
            try container?.viewContext.save()
        } catch {
            throw TaskErrors.failed(error.localizedDescription)
        }
    }
    func delete(_ id : UUID) throws {
        guard let task = getCDTaskById(id) else {
            throw TaskErrors.taskNotAvailable
        }
        container?.viewContext.delete(task)
    }
}
