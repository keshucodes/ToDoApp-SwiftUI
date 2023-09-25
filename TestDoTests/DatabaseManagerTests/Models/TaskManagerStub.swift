//
//  TaskManagerStub.swift
//  TestDoTests
//
//  Created by Keshu Rai on 24/09/23.
//

import XCTest
@testable import TestDo

class TaskManagerStub : DatabaseRepositoryProtocol {
    
    var createTaskCalled = false
    var getAllTaskCalled = false
    var getTaskByIdCalled = false
    var updatedTaskCalled = false
    var deleteTaskCalled = false
    
    func getAllTasks() throws -> [TestDo.TaskItem]? {
        getAllTaskCalled = true
        return nil
    }
    
    func getTaskById(_ id: UUID) -> TestDo.TaskItem? {
        getTaskByIdCalled = true
        return nil
    }
    
    func createTask(_ task: TestDo.TaskItem) throws {
        createTaskCalled = true
    }
    
    func updateTask(_ task: TestDo.TaskItem) throws {
        updatedTaskCalled = true
    }
    
    func delete(_ id: UUID) throws {
        deleteTaskCalled = true
    }
    
    
    
}
