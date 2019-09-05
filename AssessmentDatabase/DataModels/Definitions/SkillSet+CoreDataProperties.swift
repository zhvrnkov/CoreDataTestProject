//
//  SkillSet+CoreDataProperties.swift
//  
//
//  Created by Vlad Zhavoronkov  on 8/21/19.
//
//

import Foundation
import CoreData


extension SkillSet: DBSidable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SkillSet> {
        return NSFetchRequest<SkillSet>(entityName: "SkillSet")
    }

    @NSManaged public var isActive: Bool
    @NSManaged public var sid: Int64
    @NSManaged public var title: String?
    @NSManaged public var weight: Int64
    @NSManaged public var microTasks: NSOrderedSet?
    @NSManaged public var rubric: Rubric?

}

// MARK: Generated accessors for microTasks
extension SkillSet {

    @objc(addMicroTasksObject:)
    @NSManaged public func addToMicroTasks(_ value: Microtask)

    @objc(removeMicroTasksObject:)
    @NSManaged public func removeFromMicroTasks(_ value: Microtask)

    @objc(addMicroTasks:)
    @NSManaged public func addToMicroTasks(_ values: NSSet)

    @objc(removeMicroTasks:)
    @NSManaged public func removeFromMicroTasks(_ values: NSSet)

}
