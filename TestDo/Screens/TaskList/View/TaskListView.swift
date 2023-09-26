//
//  ContentView.swift
//  TestDo
//
//  Created by Keshu Rai on 22/09/23.
//

import SwiftUI


struct TaskListView<ViewModel: TaskListViewModelProtocol>: View {
    
    @ObservedObject var viewModel : ViewModel
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationStack {
            
            ZStack(alignment : .bottomTrailing) {
                if viewModel.tasks.isEmpty {
                    EmptyTaskView {
                        navigateToCreateTaskView()
                    }
                    .padding(.bottom,100)
                } else {
                    ScrollView(showsIndicators:false) {
                        ForEach($viewModel.tasks) { task in
                            TaskItemView(taskItem: task.wrappedValue) {
                                viewModel.markTaskComplete(task: task.wrappedValue)
                            }
                            .onTapGesture {
                                viewModel.selectedTask = task.wrappedValue
                                navigateToCreateTaskView()
                            }
                        }
                    }
                    NavigationLink(destination: CreateTaskView(viewModel: viewModel)) {
                        Image(systemName: "plus")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.white)
                            .frame(width: 60, height: 60)
                            .background(Color.green.opacity(0.9))
                            .clipShape(Circle())
                            .padding()
                    }
                    .onAppear {
                        viewModel.selectedTask = nil
                    }
                }
                
            }
            .navigationDestination(isPresented: $viewModel.navigateToCreateTaskView, destination: {
                CreateTaskView(viewModel: viewModel)
            })
            .background(Color(uiColor: .systemBackground))
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
