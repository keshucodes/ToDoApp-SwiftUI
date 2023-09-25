//
//  TaskItem.swift
//  TestDo
//
//  Created by Keshu Rai on 23/09/23.
//

import Foundation

struct TaskItem : Hashable {
    var id : UUID
    var title : String
    var createdAt : Date
    var isCompleted : Bool
}
