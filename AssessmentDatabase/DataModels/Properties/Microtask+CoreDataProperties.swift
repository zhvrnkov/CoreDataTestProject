//
//  Microtask+CoreDataProperties.swift
//  
//
//  Created by Vlad Zhavoronkov  on 8/12/19.
//
//

import Foundation
import CoreData


extension Microtask: Sidable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Microtask> {
        return NSFetchRequest<Microtask>(entityName: "Microtask")
    }

    @NSManaged public var sid: Int64
    @NSManaged public var skillSet: SkillSet?
    @NSManaged public var studentMicroTaskGrades: NSSet?

}

// MARK: Generated accessors for studentMicroTaskGrades
extension Microtask {

    @objc(addStudentMicroTaskGradesObject:)
    @NSManaged public func addToStudentMicroTaskGrades(_ value: StudentMicrotaskGrade)

    @objc(removeStudentMicroTaskGradesObject:)
    @NSManaged public func removeFromStudentMicroTaskGrades(_ value: StudentMicrotaskGrade)

    @objc(addStudentMicroTaskGrades:)
    @NSManaged public func addToStudentMicroTaskGrades(_ values: NSSet)

    @objc(removeStudentMicroTaskGrades:)
    @NSManaged public func removeFromStudentMicroTaskGrades(_ values: NSSet)

}
