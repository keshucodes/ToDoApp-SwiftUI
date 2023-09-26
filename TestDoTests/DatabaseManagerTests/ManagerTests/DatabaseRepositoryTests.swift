//
//  DatabaseRepositoryTests.swift
//  TestDoTests
//
//  Created by Keshu Rai on 23/09/23.
//

import XCTest
import CoreData
@testable import TestDo

final class DatabaseRepositoryTests: XCTestCase {
    
    var testContainer : NSPersistentContainer!

    var repo : DatabaseRepository!
    var task1 : TaskItem!
    var task2 : TaskItem!

    override func setUpWithError() throws {
        task1 = TaskItem(id : UUID(), title : "My first task", createdAt : Date() , isCompleted : false)
        task2 = TaskItem(id : UUID(), title : "My second task", createdAt : Date() , isCompleted : false)
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
        
        repo = DatabaseRepository(container: testContainer)
        
    }

    override func tearDownWithError() throws {
        testContainer = nil
        repo = nil
        task1 = nil
        task2 = nil 
    }
    
    func createSut() {

        _ = try? repo.createTask(task1)
        _ = try? repo.createTask(task2)

    }
    
    func testDatabaseRepo_validTaskDetailsArePassed_taskShouldGetAdded() {
  
        
        XCTAssertNoThrow(try repo.createTask(task1), "Valid task should not throw an error")
        
    }

    func testDatabaseRepo_validTaskDetailsArePassed_taskShouldBeEqualToTwo() {
        createSut()
        do {
            let allTasks = try repo.getAllTasks()
            XCTAssertEqual(allTasks?.count, 2, "2 Tasks should have been returned.")
        } catch {
            XCTFail("All tasks should have fetched")
        }
                
    }
    
    func testDatabaseRepo_whenNoItemsAreAddedInTasks_taskListShouldBeNil() {
        
        do {
            let allTasks = try repo.getAllTasks()
            XCTAssertEqual(allTasks?.count, 0, "No tasks should be returned")
        } catch {
            XCTFail("All tasks should have fetched")
        }
        
      
    }
    
    
    func testDatabaseRepo_whenValidIdIsPassed_UserGetsValidTask() {
        
        //Act
        XCTAssertNoThrow(try repo.createTask(task1), "Valid task should not throw an error")

        let getTask = repo.getTaskById(task1.id)

        //Assert
        XCTAssertNotNil(getTask, "Task should have been returned")
        XCTAssertEqual(getTask?.id, task1.id, "Same task should have been returned")

    }
    
    func testDatabaseRepo_whenInvalidIdIsPassed_NoTaskIsReturned() {
        //Act
        XCTAssertNoThrow(try repo.createTask(task1), "Valid task should not throw an error")
        let getTask = repo.getTaskById(UUID())

        //Assert
        XCTAssertNil(getTask, "Task is not nil")

    }

    func testDatabaseRepo_whenValidIdIsPassed_taskIsSuccsessfullyEdited() {
        //Act
        XCTAssertNoThrow(try repo.createTask(task1), "Valid task should not throw an error")
        let editedTask = TaskItem(id: task1.id, title: "My first task is edited", createdAt: task1.createdAt, isCompleted: task1.isCompleted)
        XCTAssertNoThrow(try repo.updateTask(editedTask), "Valid update task should not throw an error")

        //Assert
        XCTAssertEqual(repo.getTaskById(task1.id)?.title,editedTask.title, "Task didnt get edited")

    }
    
    func testDatabaseRepo_whenValidIdIsPassed_taskIsSuccsessfullyEditedAndReturnsValidTask() {
        //Act
        XCTAssertNoThrow(try repo.createTask(task1), "Valid task should not throw an error")

        
        let editedTask = TaskItem(id: task1.id, title: "My first task is edited", createdAt: task1.createdAt, isCompleted: task1.isCompleted)
        XCTAssertNoThrow(try repo.updateTask(editedTask), "Valid update task should not throw an error")

        let getTask = repo.getTaskById(editedTask.id)
        //Assert
        XCTAssertEqual(getTask?.id ?? UUID(),task1.id,"Task didnt get edited")
        XCTAssertEqual(getTask?.title ?? "",editedTask.title, "Task didnt get edited")

    }
    
    func testDatabaseRepo_whenInvalidIdIsPassed_taskEditingFails() {
        //Act
        XCTAssertNoThrow(try repo.createTask(task1), "Valid task should not throw an error")
        
        let editedTask = TaskItem(id: UUID(), title: "My first task is edited", createdAt: task1.createdAt, isCompleted: task1.isCompleted)
        XCTAssertThrowsError(try repo.updateTask(editedTask), "Task should not get edited if invalid id is passed")
        
    
    }
    
    func testDatabaseRepo_whenValidIdIsPassed_taskIsSuccsessfullyDeleted() {
        //Act
        XCTAssertNoThrow(try repo.createTask(task1), "Valid task should not throw an error")
        
        XCTAssertNoThrow(try repo.delete(task1.id), "Task is not deleted")
     
    }
    
    func testDatabaseRepo_whenInvalidIdIsPassed_taskIsNotDeleted() {
        //Act
        XCTAssertNoThrow(try repo.createTask(task1), "Valid task should not throw an error")
        
        XCTAssertThrowsError(try repo.delete(UUID()), "Task is deleted")
       
    }

}
