//
//  TestDoApp.swift
//  TestDo
//
//  Created by Keshu Rai on 22/09/23.
//

import SwiftUI

@main
struct TestDoApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            TaskListView(viewModel: TaskViewModel(taskManager: TaskManager()))
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
