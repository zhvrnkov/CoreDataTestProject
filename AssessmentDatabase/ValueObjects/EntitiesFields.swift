//
//  EntityFields.swift
//  AssessmentDatabase
//
//  Created by Vlad Zhavoronkov  on 8/1/19.
//  Copyright © 2019 Bytepace. All rights reserved.
//

import Foundation

public protocol Sidable {
    var sid: Int { get set }
}

public protocol InstructorFields: Sidable {
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
    var schools: [Any] { get set }
    
    var assessments: [AssessmentFields] { get set }
    var students: [StudentFields] { get set }
}

public protocol StudentFields: Sidable {
    var name: String { get set }
    var email: String { get set }
    var logbookPass: String { get set }
    
    var assessmentSids: [Int] { get set }
    var instructorSids: [Int] { get set }
    var microTaskGradesSids: [Int] { get set }
}

public protocol AssessmentFields: Sidable {
    var date: Date { get set }
    var schoolId: Int { get set }
    var isSynced: Bool { get set }
    
    var instructorSid: Int { get set }
    var rubric: RubricFields { get set }
    var studentMicrotaskGrades: [StudentMicrotaskGradeFields] { get set }
    var students: [StudentFields] { get set }
}

public protocol RubricFields: Sidable {
    var title: String { get set }
    var lastUpdate: Int { get set }
    var weight: Int { get set }
    var isActive: Bool { get set }
    
    var skillSets: [SkillSetFields] { get set }
}

public protocol SkillSetFields: Sidable {
    var rubricSid: Int { get set }
    var title: String { get set }
    var weight: Int { get set }
    var isActive: Bool { get set }
    
    var microTasks: [MicrotaskFields] { get set }
}

public protocol MicrotaskFields: Sidable {
    var isActive: Bool { get set }
    var critical: Int { get set }
    var depiction: String { get set }
    var title: String { get set }
    var weight: Int { get set }
    
    var skillSetSid: Int { get set }
}

public protocol StudentMicrotaskGradeFields: Sidable {
    var isSynced: Bool { get set }
    var lastUpdated: Int { get set }
    var passed: Bool { get set }

    var assessmentSid: Int { get set }
    var gradeSid: Int { get set }
    var microTaskSid: Int { get set }
    var studentSid: Int { get set }
}

public protocol GradeFields: Sidable {
    var score: Int { get set }
    var passed: Int { get set }
    var title: String { get set }
}
