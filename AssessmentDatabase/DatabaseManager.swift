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
    
    private(set) public static var persistentContainer: PersistentContainer = {
        do {
            return try DatabaseManager.getInitializedPersistentContainer()
        } catch {
            fatalError(error.localizedDescription)
        }
    }()
    
    public let assessments = AssessmentsUtils(container: DatabaseManager.persistentContainer)
    public let grades = GradesUtils(with: DatabaseManager.persistentContainer)
    public let instructors = InstructorsUtils(with: DatabaseManager.persistentContainer)
    public let microtasks = MicrotasksUtils(with: DatabaseManager.persistentContainer)
    public let rubrics = RubricsUtils(with: DatabaseManager.persistentContainer)
    public let skillSets = SkillSetsUtils(with: DatabaseManager.persistentContainer)
    public let students = StudentsUtils(with: DatabaseManager.persistentContainer)
    public let studentMicrotaskGrades = StudentMicrotaskGradesUtils(with: DatabaseManager.persistentContainer)
    
    private init() {
        setAssessmentsUtils()
    }
    
    public static func getInitializedPersistentContainer(named name: String = "DataModel") throws -> PersistentContainer {
        let container = PersistentContainer(name: name)
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
    
    private func setAssessmentsUtils() {
        assessments.studentsUtils = students
        assessments.rubricsUtils = rubrics
        assessments.instructorsUtils = instructors
    }
}
