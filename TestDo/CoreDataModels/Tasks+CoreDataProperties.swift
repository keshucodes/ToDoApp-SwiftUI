//
//  Tasks+CoreDataProperties.swift
//  TestDo
//
//  Created by Keshu Rai on 23/09/23.
//
//

import Foundation
import CoreData

extension Tasks {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tasks> {
        return NSFetchRequest<Tasks>(entityName: "Tasks")
    }

    @NSManaged public var dateCreated: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var isCompleted: Bool
    @NSManaged public var title: String?

}

extension Tasks : Identifiable {

}
