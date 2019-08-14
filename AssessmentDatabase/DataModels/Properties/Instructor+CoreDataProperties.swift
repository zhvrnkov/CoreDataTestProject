//
//  Instructor+CoreDataProperties.swift
//  
//
//  Created by Vlad Zhavoronkov on 8/12/19.
//
//

import Foundation
import CoreData


extension Instructor: Sidable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Instructor> {
        return NSFetchRequest<Instructor>(entityName: "Instructor")
    }

    @NSManaged public var sid: Int
    @NSManaged public var loginUsername: String
    @NSManaged public var firstName: String
    @NSManaged public var lastName: String
    @NSManaged public var avatar: String
    @NSManaged public var email: String
    @NSManaged public var phone: String
    @NSManaged public var phoneStudent: String
    @NSManaged public var address: String
    @NSManaged public var address2: String
    @NSManaged public var city: String
    @NSManaged public var state: String
    @NSManaged public var zip: String
    @NSManaged public var country: String
    @NSManaged public var credentials: String
    @NSManaged public var depiction: String
    @NSManaged public var fbid: [String]
    @NSManaged public var lang: String
    @NSManaged public var flags: [String]
    @NSManaged public var schools: [NSObject]
    @NSManaged public var assessments: NSSet
    @NSManaged public var students: NSSet

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
