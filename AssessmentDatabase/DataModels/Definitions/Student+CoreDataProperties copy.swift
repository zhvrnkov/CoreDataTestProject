//
//  Student+CoreDataProperties.swift
//  
//
//  Created by Vlad Zhavoronkov  on 8/21/19.
//
//

import Foundation
import CoreData


extension Student {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Student> {
        return NSFetchRequest<Student>(entityName: "Student")
    }

    @NSManaged public var email: String?
    @NSManaged public var logbookPass: String?
    @NSManaged public var name: String?
    @NSManaged public var sid: Int64
    @NSManaged public var assessments: NSSet?
    @NSManaged public var instructors: NSSet?
    @NSManaged public var microTaskGrades: NSSet?

}

// MARK: Generated accessors for assessments
extension Student {

    @objc(addAssessmentsObject:)
    @NSManaged public func addToAssessments(_ value: Assessment)

    @objc(removeAssessmentsObject:)
    @NSManaged public func removeFromAssessments(_ value: Assessment)

    @objc(addAssessments:)
    @NSManaged public func addToAssessments(_ values: NSSet)

    @objc(removeAssessments:)
    @NSManaged public func removeFromAssessments(_ values: NSSet)

}

// MARK: Generated accessors for instructors
extension Student {

    @objc(addInstructorsObject:)
    @NSManaged public func addToInstructors(_ value: Instructor)

    @objc(removeInstructorsObject:)
    @NSManaged public func removeFromInstructors(_ value: Instructor)

    @objc(addInstructors:)
    @NSManaged public func addToInstructors(_ values: NSSet)

    @objc(removeInstructors:)
    @NSManaged public func removeFromInstructors(_ values: NSSet)

}

// MARK: Generated accessors for microTaskGrades
extension Student {

    @objc(addMicroTaskGradesObject:)
    @NSManaged public func addToMicroTaskGrades(_ value: StudentMicrotaskGrade)

    @objc(removeMicroTaskGradesObject:)
    @NSManaged public func removeFromMicroTaskGrades(_ value: StudentMicrotaskGrade)

    @objc(addMicroTaskGrades:)
    @NSManaged public func addToMicroTaskGrades(_ values: NSSet)

    @objc(removeMicroTaskGrades:)
    @NSManaged public func removeFromMicroTaskGrades(_ values: NSSet)

}
