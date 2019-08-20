//
//  Rubric+CoreDataProperties.swift
//  
//
//  Created by Vlad Zhavoronkov  on 8/12/19.
//
//

import Foundation
import CoreData


extension Rubric: DBSidable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Rubric> {
        return NSFetchRequest<Rubric>(entityName: "Rubric")
    }

    @NSManaged public var sid: Int
    @NSManaged public var title: String
    @NSManaged public var lastUpdate: Int
    @NSManaged public var weight: Int
    @NSManaged public var isActive: Bool
    @NSManaged public var assessments: NSSet
    @NSManaged public var grades: NSSet
    @NSManaged public var skillSets: NSSet

}

// MARK: Generated accessors for assessments
extension Rubric {

    @objc(addAssessmentsObject:)
    @NSManaged public func addToAssessments(_ value: Assessment)

    @objc(removeAssessmentsObject:)
    @NSManaged public func removeFromAssessments(_ value: Assessment)

    @objc(addAssessments:)
    @NSManaged public func addToAssessments(_ values: NSSet)

    @objc(removeAssessments:)
    @NSManaged public func removeFromAssessments(_ values: NSSet)

}

// MARK: Generated accessors for skillSets
extension Rubric {

    @objc(addSkillSetsObject:)
    @NSManaged public func addToSkillSets(_ value: SkillSet)

    @objc(removeSkillSetsObject:)
    @NSManaged public func removeFromSkillSets(_ value: SkillSet)

    @objc(addSkillSets:)
    @NSManaged public func addToSkillSets(_ values: NSSet)

    @objc(removeSkillSets:)
    @NSManaged public func removeFromSkillSets(_ values: NSSet)

}

extension Rubric {
    
    @objc(addGradesObject:)
    @NSManaged public func addToGrades(_ value: Grade)
    
    @objc(removeGradesObject:)
    @NSManaged public func removeFromGrades(_ value: Grade)
    
    @objc(addGrades:)
    @NSManaged public func addToGrades(_ values: NSSet)
    
    @objc(removeGrades:)
    @NSManaged public func removeFromGrades(_ values: NSSet)
    
}
