//
//  School+CoreDataProperties.swift
//  
//
//  Created by Vlad Zhavoronkov  on 8/30/19.
//
//

import Foundation
import CoreData


extension School: DBSidable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<School> {
        return NSFetchRequest<School>(entityName: "School")
    }

    @NSManaged public var name: String?
    @NSManaged public var sid: Int64
    @NSManaged public var instructors: NSSet?

}

// MARK: Generated accessors for instructors
extension School {

    @objc(addInstructorsObject:)
    @NSManaged public func addToInstructors(_ value: Instructor)

    @objc(removeInstructorsObject:)
    @NSManaged public func removeFromInstructors(_ value: Instructor)

    @objc(addInstructors:)
    @NSManaged public func addToInstructors(_ values: NSSet)

    @objc(removeInstructors:)
    @NSManaged public func removeFromInstructors(_ values: NSSet)

}
