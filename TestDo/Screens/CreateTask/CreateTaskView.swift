//
//  CreateTaskView.swift
//  TestDo
//
//  Created by Keshu Rai on 25/09/23.
//

import SwiftUI


struct CreateTaskView: View {
    
    @State var inputText = ""
    @ObservedObject var viewModel : TaskViewModel
    @Environment(\.presentationMode) var presentationMode
    @State var errorMessage = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing:0) {
                VStack {
                    AppTextFieldView(text: $inputText)
                        .frame(height: 200) // Set a specific height if needed
                        .padding()
                        .onAppear {
                            if viewModel.selectedTask != nil {
                                inputText = viewModel.selectedTask?.title ?? ""
                            }
                        }
                    if !errorMessage.isEmpty {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.subheadline)
                    }
                }
               
                AppButton(title: viewModel.selectedTask != nil ? "Save Changes" : "Add New Task") {
                    print("Button pressed!")
                    if viewModel.selectedTask != nil {
                        //update task
                        viewModel.selectedTask?.title = inputText
                        do {
                            try viewModel.updateTask(viewModel.selectedTask!)
                            presentationMode.wrappedValue.dismiss()
                        } catch {
                            errorMessage = error.localizedDescription
                        }
                       
                    } else {
                        // add new task
                        let taskItem = TaskItem(id: UUID(), title: inputText, createdAt: Date(), isCompleted: false)
                        do {
                            try viewModel.createTask(taskItem)
                            presentationMode.wrappedValue.dismiss()
                        } catch {
                            errorMessage = error.localizedDescription
                        }
                    }
                }
                
                if viewModel.selectedTask != nil {
                    AppButton(title: "Delete Task",bgColor : Color.red) {
                        if let id = viewModel.selectedTask?.id {
                            do {
                                try viewModel.delete(id)
                                presentationMode.wrappedValue.dismiss()
                            } catch {
                                errorMessage = error.localizedDescription
                            }
                        }
                       
                    }
                }
                Spacer()
                
            }
            .navigationTitle(viewModel.selectedTask != nil ? "Edit Task" : "Add Task")
            .navigationBarTitleDisplayMode(.automatic)
        }
    }
}

struct CreateTaskView_Previews: PreviewProvider {
    static var previews: some View {
        CreateTaskView(viewModel : TaskViewModel(taskManager: TaskManager()))
    }
}
