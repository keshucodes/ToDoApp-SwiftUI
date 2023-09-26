//
//  CreateTaskViewTests.swift
//  TestDoTests
//
//  Created by Keshu Rai on 26/09/23.
//

import XCTest
import ViewInspector
@testable import TestDo

final class CreateTaskViewTests: XCTestCase {
    
    var viewModel : MockTaskListViewModel!
    var view : CreateTaskView<MockTaskListViewModel>!


    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        viewModel = MockTaskListViewModel()
        view = CreateTaskView(viewModel: viewModel)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        viewModel = nil
        view = nil
    }
    
    func testCreateTaskView_WhenAddingNewTask_ShouldCreateTask() throws {
          viewModel.selectedTask = nil // Set selected task to nil for adding a new task
          // Set up your desired inputText value here if needed
        
        try view.inspect().find(button: "Add New Task").tap()

          // Verify that the createTask method in the viewModel is called
          XCTAssertTrue(viewModel.createTaskCalled)
      }

      func testCreateTaskView_WhenEditingTask_ShouldUpdateTask() throws {
          // Set up your desired inputText value here if needed
          viewModel.selectedTask = TaskItem(id: UUID(), title: "A sample task", createdAt: Date(), isCompleted: false)
          try view.inspect().find(button: "Save Changes").tap()
          // Verify that the updateTask method in the viewModel is called
          XCTAssertTrue(viewModel.updateTaskCalled)
      }

      func testCreateTaskView_WhenDeletingTask_ShouldDeleteTask() throws {
          
          viewModel.selectedTask = TaskItem(id: UUID(), title: "Task 1", createdAt: Date(), isCompleted: false) // Set selected task for deletion

          try view.inspect().find(button: "Delete Task").tap()

          // Verify that the delete method in the viewModel is called
          XCTAssertTrue(viewModel.deleteCalled)
      }

}
