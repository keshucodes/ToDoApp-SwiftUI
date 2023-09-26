//
//  TaskListViewTests.swift
//  TestDoTests
//
//  Created by Keshu Rai on 26/09/23.
//

import XCTest
import ViewInspector
@testable import TestDo


final class TaskListViewTests: XCTestCase {

    var viewModel : MockTaskListViewModel!
    var view : TaskListView<MockTaskListViewModel>!

    override func setUpWithError() throws {
        viewModel = MockTaskListViewModel()
        view = TaskListView(viewModel: viewModel)
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        viewModel = nil
        view = nil
    }

    func testTaskListView_WhenTasksIsEmpty_ShowsEmptyTaskView() {
        viewModel.tasks = []
        do {
            let result = try view.inspect().find(EmptyTaskView.self)
            XCTAssertTrue(!result.isEmpty, "Empty task view should be shown")
        } catch {
            XCTFail("cant find empty task view")
        }
    }
    
    func testTaskListView_WhenTasksIsAvailable_HidesEmptyTaskViewAndShowsScrollView() {
        
        viewModel.tasks = [TaskItem(id: UUID(), title: "asdasd", createdAt: Date(), isCompleted: false)]
        
        XCTAssertThrowsError(try view.inspect().find(EmptyTaskView.self), "Empty task should be hidden")
        
        do {
            let result = try view.inspect().find(TaskItemView.self)
            XCTAssertTrue(result.isEmpty == false, "Task Item View should be visible")
        } catch {
            XCTFail("cant find task view")
        }
    }
    
    func testTaskListView_WhenTasksAreAvailable_ShowsTaskItems() {
        
        XCTAssertNoThrow(try viewModel.getAllTasks(), "Task should have been returned")

        do {
            let taskItemViews = try view.inspect().findAll(TaskItemView.self)
            XCTAssertTrue(taskItemViews.count == viewModel.tasks.count, "Task Item Views should match the number of tasks")
        } catch {
            XCTFail("Failed to find Task Item Views")
        }
    }
    
    func testTaskListView_WhenTappingTaskItem_ShouldSelectTask() {
        // Set up mock tasks
        viewModel.tasks = [TaskItem(id: UUID(), title: "Task 1", createdAt: Date(), isCompleted: false)]
        do {
            // Tap on the TaskItemView
            try view.inspect().find(TaskItemView.self).callOnTapGesture()

            // Verify that the selected task has been set in the view model
            XCTAssertNotNil(viewModel.selectedTask, "Selected task should not be nil")
        } catch {
            XCTFail("Failed to tap on Task Item View")
        }
    }
    
    func testTaskListView_WhenTappingTaskItem_ShouldMarkTaskComplete() {
        // Set up mock tasks
        viewModel.tasks = [TaskItem(id: UUID(), title: "Task 1", createdAt: Date(), isCompleted: false)]
        do {
            // Tap on the TaskItemView
            let taskItemView = try view.inspect().find(TaskItemView.self)

            try taskItemView.actualView().completeAction()

            XCTAssertTrue(viewModel.tasks.first?.isCompleted == true, "Task should be marked as complete")

        } catch {
            XCTFail("Failed to tap on Task Item View")
        }
    }
    
    func testTaskListView_WhenNavigatingToCreateTaskView_ShouldSetNavigateFlag() {
        // Set up mock tasks
        viewModel.tasks = [TaskItem(id: UUID(), title: "Task 1", createdAt: Date(), isCompleted: false)]
        do {
            // Tap on the TaskItemView
            try view.inspect().find(TaskItemView.self).callOnTapGesture()

            // Verify that the selected task has been set in the view model
            XCTAssertTrue(viewModel.navigateToCreateTaskView, "navigateToCreateTaskView should be true")
        } catch {
            XCTFail("Failed to tap on Task Item View")
        }
    }
}
