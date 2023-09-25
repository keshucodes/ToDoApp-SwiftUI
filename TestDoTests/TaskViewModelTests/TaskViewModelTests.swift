//
//  TaskViewModelTests.swift
//  TestDoTests
//
//  Created by Keshu Rai on 24/09/23.
//

import XCTest
import CoreData
@testable import TestDo

final class TaskViewModelTests: XCTestCase {

    var vm : TaskViewModel!
    var testContainer : NSPersistentContainer!

    override func setUpWithError() throws {
        testContainer = {
            let container = NSPersistentContainer(name: "TestDo")
            let description = NSPersistentStoreDescription()
            description.type = NSInMemoryStoreType
            description.shouldAddStoreAsynchronously = false
            container.persistentStoreDescriptions = [description]
            container.loadPersistentStores { _, error in
                if error != nil {
                    fatalError(error?.localizedDescription ?? "Failed to load test store")
                }
            }
            return container
        }()
        vm = TaskViewModel(taskManager: TaskManager(DatabaseRepository(container: testContainer)))
    }

    override func tearDownWithError() throws {
        vm = nil
        testContainer = nil
    }

    func testTaskViewModel_whenInitialized_totalTasksAreZero() {
        let taskCount = vm.tasks.count
        
        XCTAssertEqual(taskCount, 0, "Task count should be zero when model initialized")
    }
    
    func testTaskViewModel_whenPassedValidTaskDetail_taskShouldGetStored() {
        
        let task = TaskItem(id: UUID(), title: "A sample test", createdAt: Date(), isCompleted: true)
        
        XCTAssertNoThrow(try vm.createTask(task), "Valid task should not throw an error")
        
    }
  
    func testTaskViewModel_whenATaskIsAdded_taskWithCorrecDataIsAdded() {
        //Arrange
        let task = TaskItem(id : UUID(), title : "My first task", createdAt : Date() , isCompleted : false)
        //Act
        //Assert
        XCTAssertNoThrow(try vm.createTask(task), "Valid task should not throw an error")

        XCTAssertTrue(vm.tasks.count == 1, "added a task but it didnt get added")
        XCTAssertEqual(task.id, vm.tasks.first?.id, "Id should have been equal but it is not.")
        XCTAssertEqual(task.title, vm.tasks.first?.title, "title should have been equal but it is not.")
        XCTAssertEqual(task.createdAt, vm.tasks.first?.createdAt, "createdAt should have been equal but it is not.")
        XCTAssertEqual(task.isCompleted, vm.tasks.first?.isCompleted, "isCompleted should have been equal but it is not.")

    }
    
    func testTaskViewModel_whenATaskIsAddedwithEmptyTitle_taskIsNotAdded() {
        //Arrange
        let task = TaskItem(id : UUID(), title : "", createdAt : Date() , isCompleted : false)
        //Assert
        XCTAssertThrowsError(try vm.createTask(task),"Invalid task should throw an error")
        XCTAssertTrue(vm.tasks.isEmpty, "empty title should not have been added to the task list")
   
    }
    
    func testTaskViewModel_whenATaskIsAddedwithInvalidTitleLength_taskIsNotAdded() {
        //Arrange
        let task = TaskItem(id : UUID(), title : "a", createdAt : Date() , isCompleted : false)
        //Act
        //Assert
        XCTAssertThrowsError(try vm.createTask(task),"Invalid task should throw an error")
        XCTAssertTrue(vm.tasks.isEmpty, "title length is less than \(TaskConstants.titleLength). invalid title length should not have been added to the task list")
   
    }
    
    func testTaskViewModel_whenFetchingAllTasks_shouldReveiveAllTasks() {
        
        do {
            let allTasks = try vm.getAllTasks()
            XCTAssertEqual(allTasks?.count, vm.tasks.count, "Tasks count should have been equal")
        } catch {
            XCTFail("All tasks should have fetched")
        }
    }
    
    func testTaskViewModel_whenEditingATask_TaskShouldGetEdited() {
        
        //Arrange
        var task = TaskItem(id : UUID(), title : "abc", createdAt : Date() , isCompleted : false)
        
        XCTAssertNoThrow(try vm.createTask(task), "Valid task should not throw an error")
        task.title = "title changed"
        XCTAssertNoThrow(try vm.updateTask(task), "Valid update of task should not throw an error")
        let allTasks = try? vm.getAllTasks()
        XCTAssertEqual(allTasks?.filter { $0.id == task.id }.first?.title, vm.tasks.filter { $0.id == task.id }.first?.title, "Task is not updated in view model")

        
    }
    func testTaskViewModel_whenATaskIsUpdatedwithEmptyTitle_taskIsNotEdited() {
        var task = TaskItem(id : UUID(), title : "abc", createdAt : Date() , isCompleted : false)
        
        XCTAssertNoThrow(try vm.createTask(task), "Valid task should not throw an error")
        task.title = ""
        XCTAssertThrowsError(try vm.updateTask(task), "Invalid title of task should throw an error")
   
    }
    
    func testTaskViewModel_whenATaskIsUpdatedwithInvalidTitleLength_taskIsNotEdited() {
        var task = TaskItem(id : UUID(), title : "abc", createdAt : Date() , isCompleted : false)
        
        XCTAssertNoThrow(try vm.createTask(task), "Valid task should not throw an error")
        task.title = "ab"
        //Assert
        XCTAssertThrowsError(try vm.updateTask(task), "title length is less than \(TaskConstants.titleLength). invalid title length should not have been updated to the task list")

   
    }
    
    func testTaskViewModel_whenIdIsprovied_fetchesValidTask() {
        let task = TaskItem(id : UUID(), title : "abc", createdAt : Date() , isCompleted : false)
        
        XCTAssertNoThrow(try vm.createTask(task), "Valid task should not throw an error")
        let result = vm.getTaskById(task.id)
        
        XCTAssertEqual(task.title, result?.title, "Didnt fetch valid task")
        
    }
    
    func testTaskViewModel_whenInvalidIdIsprovied_fetchesNoTask() {
        let task = TaskItem(id : UUID(), title : "abc", createdAt : Date() , isCompleted : false)
        
        XCTAssertNoThrow(try vm.createTask(task), "Valid task should not throw an error")
        let result = vm.getTaskById(UUID())
        
        XCTAssertNil(result, "Should not have fetch any task as the uuid is invalid")
    }
    
    
    func testTaskViewModel_whenValidIdIsprovied_deletesTask() {
        let task = TaskItem(id : UUID(), title : "abc", createdAt : Date() , isCompleted : false)
        
        XCTAssertNoThrow(try vm.createTask(task), "Valid task should not throw an error")
        XCTAssertNoThrow(try vm.delete(task.id), "Valid task should get deleted")

    }
    
    func testTaskViewModel_whenInvalidIdIsprovied_deletesNoTask() {
        let task = TaskItem(id : UUID(), title : "abc", createdAt : Date() , isCompleted : false)
        
        XCTAssertNoThrow(try vm.createTask(task), "Valid task should not throw an error")
        XCTAssertNoThrow(try vm.delete(task.id), "Task got deleted when invalid id")

    }


}
