//
//  Grade+CoreDataProperties.swift
//  
//
//  Created by Vlad Zhavoronkov  on 8/21/19.
//
//

import Foundation
import CoreData


extension Grade: DBSidable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Grade> {
        return NSFetchRequest<Grade>(entityName: "Grade")
    }

    @NSManaged public var passed: Bool
    @NSManaged public var score: Int64
    @NSManaged public var sid: Int64
    @NSManaged public var title: String?
    @NSManaged public var rubric: Rubric?
    @NSManaged public var studentMicrotaskGrades: NSSet?

}

// MARK: Generated accessors for studentMicrotaskGrades
extension Grade {

    @objc(addStudentMicrotaskGradesObject:)
    @NSManaged public func addToStudentMicrotaskGrades(_ value: StudentMicrotaskGrade)

    @objc(removeStudentMicrotaskGradesObject:)
    @NSManaged public func removeFromStudentMicrotaskGrades(_ value: StudentMicrotaskGrade)

    @objc(addStudentMicrotaskGrades:)
    @NSManaged public func addToStudentMicrotaskGrades(_ values: NSSet)

    @objc(removeStudentMicrotaskGrades:)
    @NSManaged public func removeFromStudentMicrotaskGrades(_ values: NSSet)

}
