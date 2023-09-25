//
//  TaskManagerTests.swift
//  TestDoTests
//
//  Created by Keshu Rai on 23/09/23.
//

import XCTest
@testable import TestDo

final class TaskManagerTests: XCTestCase {
    
    var taskManager : TaskManagerStub!
    var task : TaskItem!
    
    override func setUpWithError() throws {
        taskManager = TaskManagerStub()
        task = TaskItem(id : UUID(), title : "My first task", createdAt : Date() , isCompleted : false)
    }

    override func tearDownWithError() throws {
        taskManager = nil
        task = nil
    }
    
    func testTaskManger_whenAddTaskIsCalled_addTaskCalledChangesTrue() {
        _ = try? taskManager.createTask(task)
        XCTAssertTrue(taskManager.createTaskCalled)
        
    }
    func testTaskManger_whenUpdateTaskIsCalled_updateTaskCalledChangesTrue() {
        _ = try? taskManager.updateTask(task)
        XCTAssertTrue(taskManager.updatedTaskCalled)
        
    }
    func testTaskManger_whenDeleteTaskIsCalled_deleteTaskCalledChangesTrue() {
        _ = try? taskManager.delete(task.id)
        XCTAssertTrue(taskManager.deleteTaskCalled)
    }
    func testTaskManger_whenGetAllTaskIsCalled_getAllTaskCalledChangesTrue() {
        _ = try? taskManager.getAllTasks()
        XCTAssertTrue(taskManager.getAllTaskCalled)
        
    }
    
}
