//
//  StudentMicrotaskGrade+CoreDataProperties.swift
//  
//
//  Created by Vlad Zhavoronkov  on 8/21/19.
//
//

import Foundation
import CoreData


extension StudentMicrotaskGrade {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StudentMicrotaskGrade> {
        return NSFetchRequest<StudentMicrotaskGrade>(entityName: "StudentMicrotaskGrade")
    }

    @NSManaged public var isSynced: Bool
    @NSManaged public var lastUpdated: Int64
    @NSManaged public var passed: Bool
    @NSManaged public var sid: Int64
    @NSManaged public var assessment: Assessment?
    @NSManaged public var grade: Grade?
    @NSManaged public var microTask: Microtask?
    @NSManaged public var student: Student?

}
