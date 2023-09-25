//
//  TaskManager.swift
//  TestDo
//
//  Created by Keshu Rai on 23/09/23.
//

import Foundation

class TaskManager : DatabaseRepositoryProtocol {
    
    private let _repo : DatabaseRepository!
    
    init(_ repo : DatabaseRepository = DatabaseRepository()) {
        self._repo = repo
    }
    
    func createTask(_ task: TaskItem) throws {
        try _repo.createTask(task)
    }
    
    func getAllTasks() throws -> [TaskItem]? {
        try _repo.getAllTasks()
    }
    
    func getTaskById(_ id: UUID) -> TaskItem? {
        _repo.getTaskById(id)
    }
    
    func updateTask(_ task: TaskItem) throws {
        try _repo.updateTask(task)
    }
    
    func delete(_ id: UUID) throws {
        try _repo.delete(id)
    }
    
}
