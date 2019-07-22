//
//  DatabaseManager.swift
//  AssessmentDatabase
//
//  Created by Vlad Zhavoronkov  on 7/22/19.
//  Copyright © 2019 Bytepace. All rights reserved.
//

import Foundation
import CoreData

final public class DatabaseManager {
    public static let shared = DatabaseManager()
    
    private(set) public lazy var persistentContainer: NSPersistentContainer = {
        do {
            return try getInitializedPersistentContainer()
        } catch {
            fatalError(error.localizedDescription)
        }
    }()
    
    public func getInitializedPersistentContainer(named: String = "DataModel") throws -> NSPersistentContainer {
        let container = NSPersistentContainer(name: "DataModel")
        var errorToThrow: Error?
        container.loadPersistentStores { _, error in
            if let error = error {
                errorToThrow = error
            }
        }
        if let error = errorToThrow {
            throw error
        } else {
            return container
        }
    }
    
    public let assessments = AssessmentsUtils()
    public let grades = GradesUtils()
    public let instructors = InstructorsUtils()
    public let microtasks = MicrotasksUtils()
    public let rubrics = RubricsUtils()
    public let skillSets = SkillSetsUtils()
    public let students = StudentsUtils()
    public let studentMicrotaskGrades = StudentMicrotaskGradesUtils()
}
