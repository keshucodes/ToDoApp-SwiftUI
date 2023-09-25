//
//  ContentView.swift
//  TestDo
//
//  Created by Keshu Rai on 22/09/23.
//

import SwiftUI


struct TaskListView: View {
    
    @ObservedObject var viewModel : TaskViewModel
        
    init(viewModel: TaskViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationStack {
            
            ZStack(alignment : .bottomTrailing) {
                if viewModel.tasks.isEmpty {
                    EmptyTaskView {
                        navigateToCreateTaskView()
                    }
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 100, trailing: 0))
                } else {
                    ScrollView(showsIndicators:false) {
                        ForEach($viewModel.tasks, id : \.self) { task in
                            TaskItemView(taskItem: TaskItem(id: UUID(), title: task.title.wrappedValue, createdAt: task.createdAt.wrappedValue, isCompleted: task.isCompleted.wrappedValue )) {
                                
                                viewModel.markTaskComplete(task: task.wrappedValue)
                            }
                                .onTapGesture {
                                    viewModel.selectedTask = task.wrappedValue
                                    navigateToCreateTaskView()
                                }
                        }
                    }
                    ZStack {
                        NavigationLink(destination: CreateTaskView(viewModel: viewModel)) {
                            Image(systemName: "plus")
                                .resizable()
                                .frame(width: 20,height: 20)
                                .foregroundColor(.white)
                        }
                    }
                    .onAppear {
                        viewModel.selectedTask = nil
                    }
                    .frame(width: 60,height: 60)
                    .background(Color.green.opacity(0.9))
                    .clipShape(Circle())
                    .padding()
                }

            }
            .navigationDestination(isPresented: $viewModel.navigateToCreateTaskView, destination: {
                CreateTaskView(viewModel: viewModel)
            })
            .background(Color.white)
            .navigationTitle("ToDo")
            .navigationBarTitleDisplayMode(.large)
            
           
        }
        
    }
    
    // Function to trigger navigation to CreateTaskView
     private func navigateToCreateTaskView() {
         viewModel.navigateToCreateTaskView = true
     }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        TaskListView(viewModel: TaskViewModel(taskManager: TaskManager()))
    }
}
