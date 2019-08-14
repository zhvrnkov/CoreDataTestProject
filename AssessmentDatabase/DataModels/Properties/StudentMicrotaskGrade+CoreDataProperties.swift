//
//  StudentMicrotaskGrade+CoreDataProperties.swift
//  
//
//  Created by Vlad Zhavoronkov  on 8/12/19.
//
//

import Foundation
import CoreData


extension StudentMicrotaskGrade: Sidable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StudentMicrotaskGrade> {
        return NSFetchRequest<StudentMicrotaskGrade>(entityName: "StudentMicrotaskGrade")
    }

    @NSManaged public var sid: Int
    @NSManaged public var isSynced: Bool
    @NSManaged public var lastUpdated: Int
    @NSManaged public var passed: Bool
    @NSManaged public var assessment: Assessment
    @NSManaged public var grade: Grade
    @NSManaged public var microTask: Microtask
    @NSManaged public var student: Student

}
