//
//  TaskItemView.swift
//  TestDo
//
//  Created by Keshu Rai on 24/09/23.
//

import SwiftUI

struct TaskItemView: View {
    
    let taskItem : TaskItem!
    
    var completeAction : () -> ()

    
    var body: some View {
        HStack(alignment: .top, spacing:20) {
            Image(systemName: taskItem.isCompleted ? "checkmark.circle.fill" : "circle")
                .foregroundColor(taskItem.isCompleted ? .green : .gray)
                .onTapGesture {
                    completeAction()
                }
            Text(taskItem.title)
                .strikethrough(taskItem?.isCompleted ?? false)
            Spacer()
            Text(taskItem.createdAt.formatToDayAndMonth())
                .font(.footnote)
        }
        .padding()
        .background(taskItem.isCompleted ? Color.green.opacity(0.2) : Color.gray.opacity(0.1))
        .cornerRadius(10)
        .padding(EdgeInsets(top: 10, leading: 20, bottom: 0, trailing: 20))

    }
}

struct TaskItemView_Previews: PreviewProvider {
    static var previews: some View {
        TaskItemView(taskItem: TaskItem(id: UUID(), title: "My First task", createdAt: Date(), isCompleted: true), completeAction: {})
    }
}
