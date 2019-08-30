//
//  EntityFields.swift
//  AssessmentDatabase
//
//  Created by Vlad Zhavoronkov  on 8/1/19.
//  Copyright © 2019 Bytepace. All rights reserved.
//

import Foundation

protocol DBSidable {
    var sid: Int64 { get set }
}

public protocol Sidable {
    var sid: Int { get set }
}

extension Array where Element: DBSidable {
    var sids: [Int64] {
        return map { $0.sid }
    }
}

extension Array where Element: Sidable {
    var sids: [Int] {
        return map { $0.sid }
    }
}

public protocol SchoolFields: Sidable {
    var sid: Int { get set }
    var name: String { get set }
    
    var instructorSids: [Int] { get set }
    
    init(sid: Int, name: String)
}

public protocol InstructorFields: Sidable {
    associatedtype AssessmentFieldsType: AssessmentFields
    associatedtype StudentFieldsType: StudentFields
    associatedtype SchoolFieldsType: SchoolFields
    
    var loginUsername: String { get set }
    var firstName: String { get set }
    var lastName: String { get set }
    var avatar: String { get set }
    var email: String { get set }
    var phone: String { get set }
    var phoneStudent: String { get set }
    var address: String { get set }
    var address2: String { get set }
    var city: String { get set }
    var state: String { get set }
    var zip: String { get set }
    var country: String { get set }
    var credentials: String { get set }
    var depiction: String { get set }
    var fbid: [String] { get set }
    var lang: String { get set }
    var flags: [String] { get set }
    
    var schools: [SchoolFieldsType] { get set }
    var assessments: [AssessmentFieldsType] { get set }
    var students: [StudentFieldsType] { get set }
    
    init(sid: Int,
         loginUsername: String,
         firstName: String,
         lastName: String,
         avatar: String,
         email: String,
         phone: String,
         phoneStudent: String,
         address: String,
         address2: String,
         city: String,
         state: String,
         zip: String,
         country: String,
         credentials: String,
         depiction: String,
         fbid: [String],
         lang: String,
         flags: [String],
         assessments: [AssessmentFieldsType],
         students: [StudentFieldsType],
         schools: [SchoolFieldsType])
}

public protocol StudentFields: Sidable {
    associatedtype StudentMicrotaskGradeFieldsType: StudentMicrotaskGradeFields
    
    var name: String { get set }
    var email: String { get set }
    var logbookPass: String { get set }
    
    var assessmentSids: [Int] { get set }
    var instructorSids: [Int] { get set }
    var microTaskGrades: [StudentMicrotaskGradeFieldsType] { get set }
    
    init(sid: Int,
         email: String,
         logbookPass: String,
         name: String,
         assessmentSids: [Int],
         instructorSids: [Int],
         microTaskGrades: [StudentMicrotaskGradeFieldsType])
}

public protocol AssessmentFields: Sidable {
    associatedtype StudentFieldsType: StudentFields
    associatedtype RubricFieldsType: RubricFields
    
    var date: Date { get }
    var schoolId: Int { get }
    var isSynced: Bool { get }
    
    var instructorSid: Int { get }
    
    var rubric: RubricFieldsType { get set }
    var rubricSid: Int { get }
    
    var microTaskGradeSids: [Int] { get }
    
    var students: [StudentFieldsType] { get set }
    var studentSids: [Int] { get }
    
    init(sid: Int,
         isSynced: Bool,
         date: Date,
         schoolId: Int,
         instructorSid: Int,
         rubric: RubricFieldsType,
         microTaskGradeSids: [Int],
         students: [StudentFieldsType])
}

extension AssessmentFields {
    var rubricSid: Int {
        return rubric.sid
    }
    var studentSids: [Int] {
        return students.map { $0.sid }
    }
}

public protocol RubricFields: Sidable {
    associatedtype SkillSetFieldsType: SkillSetFields
    associatedtype GradeFieldsType: GradeFields
    
    var title: String { get set }
    var lastUpdate: Int { get set }
    var weight: Int { get set }
    var isActive: Bool { get set }
    
    var skillSets: [SkillSetFieldsType] { get set }
    var grades: [GradeFieldsType] { get set }
    
    init(sid: Int,
         title: String,
         lastUpdate: Int,
         weight: Int,
         isActive: Bool,
         skillSets: [SkillSetFieldsType],
         grades: [GradeFieldsType])
}

extension RubricFields {
    static var bad: Self {
        return Self.init(sid: -1, title: dbError, lastUpdate: -1, weight: 0, isActive: false, skillSets: [], grades: [])
    }
}

public protocol SkillSetFields: Sidable {
    associatedtype MicrotaskFieldsType: MicrotaskFields
    
    var rubricSid: Int { get set }
    var title: String { get set }
    var weight: Int { get set }
    var isActive: Bool { get set }
    
    var microTasks: [MicrotaskFieldsType] { get set }
    
    init(sid: Int,
         rubricSid: Int,
         isActive: Bool,
         title: String,
         weight: Int,
         microTasks: [MicrotaskFieldsType])
}

public protocol MicrotaskFields: Sidable {
    var isActive: Bool { get set }
    var critical: Int { get set }
    var depiction: String { get set }
    var title: String { get set }
    var weight: Int { get set }
    
    var skillSetSid: Int { get set }
    
    init(sid: Int,
         critical: Int,
         depiction: String,
         isActive: Bool,
         title: String,
         weight: Int,
         skillSetSid: Int)
}

public protocol StudentMicrotaskGradeFields: Sidable {
    var isSynced: Bool { get set }
    var lastUpdated: Int { get set }
    var passed: Bool { get set }
    
    var assessmentSid: Int { get set }
    var gradeSid: Int { get set }
    var microTaskSid: Int { get set }
    var studentSid: Int { get set }
    
    init(sid: Int,
         lastUpdated: Int,
         passed: Bool,
         isSynced: Bool,
         assessmentSid: Int,
         microTaskSid: Int,
         studentSid: Int,
         gradeSid: Int)
}

public protocol GradeFields: Sidable {
    var score: Int { get set }
    var passed: Bool { get set }
    var title: String { get set }
    var rubricSid: Int { get set }
    
    init(sid: Int,
         title: String,
         passed: Bool,
         score: Int,
         rubricSid: Int)
}
