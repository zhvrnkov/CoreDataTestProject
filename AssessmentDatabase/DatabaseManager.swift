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
    private init() {}
    
    private(set) public static var persistentContainer: PersistentContainer = {
        do {
            return try DatabaseManager.getInitializedPersistentContainer()
        } catch {
            fatalError(error.localizedDescription)
        }
    }()
    
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
    
    public func clear() {
        assessments._deleteAll()
        grades._deleteAll()
        instructors._deleteAll()
        microtasks._deleteAll()
        rubrics._deleteAll()
        skillSets._deleteAll()
        students._deleteAll()
        studentMicrotaskGrades._deleteAll()
    }
    
    private func configureAssessmentsUtils() {
        assessments.studentsUtils = students
        assessments.rubricsUtils = rubrics
        assessments.instructorsUtils = instructors
    }
    
    private func configureSkillSetsUtils() {
        skillSets.rubricUtils = rubrics
    }

    private func configureMicrotaskUtils() {
        microtasks.skillSetsUtils = skillSets
    }
    
    private func congifureStudentMicrotaskGradeUtils() {
        studentMicrotaskGrades.assessmentsUtils = assessments
        studentMicrotaskGrades.gradesUtils = grades
        studentMicrotaskGrades.studentsUtils = students
        studentMicrotaskGrades.microtasksUtils = microtasks
    }
    
    private func configureInstructorUtils() {
        students.instructorsUtils = instructors
    }
    
    private func configureGradeUtils() {
        grades.rubricUtils = rubrics
    }
}
