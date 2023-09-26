//
//  CreateTaskView.swift
//  TestDo
//
//  Created by Keshu Rai on 25/09/23.
//

import SwiftUI

struct CreateTaskView<ViewModel: TaskListViewModelProtocol>: View {
    @State private var inputText = ""
    @State private var errorMessage = ""

    @ObservedObject var viewModel: ViewModel
    @Environment(\.presentationMode) private var presentationMode

    var isEditing: Bool {
        viewModel.selectedTask != nil
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                AppTextFieldView(text: $inputText)
                    .frame(height: 200) // Set a specific height if needed
                    .padding()
                    .onAppear {
                        inputText = viewModel.selectedTask?.title ?? ""
                    }
                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.subheadline)
                }

                AppButton(title: isEditing ? "Save Changes" : "Add New Task") {
                    performTaskAction()
                }

                if isEditing {
                    AppButton(title: "Delete Task", bgColor: .red) {
                        deleteTask()
                    }
                }
                Spacer()
            }
            .navigationTitle(isEditing ? "Edit Task" : "Add Task")
            .navigationBarTitleDisplayMode(.automatic)
        }
    }

    private func performTaskAction() {
        do {
            if isEditing {
                try updateTask()
            } else {
                try createTask()
            }
            presentationMode.wrappedValue.dismiss()
        } catch {
            handleTaskError(error)
        }
    }

    private func createTask() throws {
        let taskItem = TaskItem(id: UUID(), title: inputText, createdAt: Date(), isCompleted: false)
        try viewModel.createTask(taskItem)
    }

    private func updateTask() throws {
        guard var selectedTask = viewModel.selectedTask else {
            return
        }
        selectedTask.title = inputText
        try viewModel.updateTask(selectedTask)
    }

    private func deleteTask() {
        if let id = viewModel.selectedTask?.id {
            do {
                try viewModel.delete(id)
                presentationMode.wrappedValue.dismiss()
            } catch {
                handleTaskError(error)
            }
        }
    }

    private func handleTaskError(_ error: Error) {
        errorMessage = error.localizedDescription
    }
}

struct CreateTaskView_Previews: PreviewProvider {
    static var previews: some View {
        CreateTaskView(viewModel : TaskViewModel(taskManager: TaskManager()))
    }
}
