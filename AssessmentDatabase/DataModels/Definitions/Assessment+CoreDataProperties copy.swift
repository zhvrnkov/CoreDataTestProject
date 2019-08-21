//
//  Assessment+CoreDataProperties.swift
//  
//
//  Created by Vlad Zhavoronkov  on 8/21/19.
//
//

import Foundation
import CoreData


extension Assessment {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Assessment> {
        return NSFetchRequest<Assessment>(entityName: "Assessment")
    }

    @NSManaged public var date: NSDate?
    @NSManaged public var isSynced: Bool
    @NSManaged public var schoolId: Int64
    @NSManaged public var sid: Int64
    @NSManaged public var instructor: Instructor?
    @NSManaged public var rubric: Rubric?
    @NSManaged public var studentMicrotaskGrades: NSSet?
    @NSManaged public var students: NSSet?

}

// MARK: Generated accessors for studentMicrotaskGrades
extension Assessment {

    @objc(addStudentMicrotaskGradesObject:)
    @NSManaged public func addToStudentMicrotaskGrades(_ value: StudentMicrotaskGrade)

    @objc(removeStudentMicrotaskGradesObject:)
    @NSManaged public func removeFromStudentMicrotaskGrades(_ value: StudentMicrotaskGrade)

    @objc(addStudentMicrotaskGrades:)
    @NSManaged public func addToStudentMicrotaskGrades(_ values: NSSet)

    @objc(removeStudentMicrotaskGrades:)
    @NSManaged public func removeFromStudentMicrotaskGrades(_ values: NSSet)

}

// MARK: Generated accessors for students
extension Assessment {

    @objc(addStudentsObject:)
    @NSManaged public func addToStudents(_ value: Student)

    @objc(removeStudentsObject:)
    @NSManaged public func removeFromStudents(_ value: Student)

    @objc(addStudents:)
    @NSManaged public func addToStudents(_ values: NSSet)

    @objc(removeStudents:)
    @NSManaged public func removeFromStudents(_ values: NSSet)

}
