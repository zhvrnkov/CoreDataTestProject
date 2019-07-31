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
    
    public lazy var assessments = AssessmentsUtils(with: self.persistentContainer)
    public lazy var grades = GradesUtils(with: self.persistentContainer)
    public lazy var instructors = InstructorsUtils()
    public lazy var microtasks = MicrotasksUtils()
    public lazy var rubrics = RubricsUtils()
    public lazy var skillSets = SkillSetsUtils()
    public lazy var students = StudentsUtils()
    public lazy var studentMicrotaskGrades = StudentMicrotaskGradesUtils()
    
    private init() {}
    
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
}
