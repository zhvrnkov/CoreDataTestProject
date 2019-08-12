//
//  Instructor+CoreDataProperties.swift
//  
//
//  Created by Vlad Zhavoronkov  on 8/12/19.
//
//

import Foundation
import CoreData


extension Instructor: Sidable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Instructor> {
        return NSFetchRequest<Instructor>(entityName: "Instructor")
    }

    @NSManaged public var sid: Int64
    @NSManaged public var assessments: NSSet?
    @NSManaged public var students: NSSet?

}

// MARK: Generated accessors for assessments
extension Instructor {

    @objc(addAssessmentsObject:)
    @NSManaged public func addToAssessments(_ value: Assessment)

    @objc(removeAssessmentsObject:)
    @NSManaged public func removeFromAssessments(_ value: Assessment)

    @objc(addAssessments:)
    @NSManaged public func addToAssessments(_ values: NSSet)

    @objc(removeAssessments:)
    @NSManaged public func removeFromAssessments(_ values: NSSet)

}

// MARK: Generated accessors for students
extension Instructor {

    @objc(addStudentsObject:)
    @NSManaged public func addToStudents(_ value: Student)

    @objc(removeStudentsObject:)
    @NSManaged public func removeFromStudents(_ value: Student)

    @objc(addStudents:)
    @NSManaged public func addToStudents(_ values: NSSet)

    @objc(removeStudents:)
    @NSManaged public func removeFromStudents(_ values: NSSet)

}
