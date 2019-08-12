//
//  SkillSet+CoreDataProperties.swift
//  
//
//  Created by Vlad Zhavoronkov  on 8/12/19.
//
//

import Foundation
import CoreData


extension SkillSet: Sidable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SkillSet> {
        return NSFetchRequest<SkillSet>(entityName: "SkillSet")
    }

    @NSManaged public var sid: Int64
    @NSManaged public var microTasks: NSSet
    @NSManaged public var rubric: Rubric

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
