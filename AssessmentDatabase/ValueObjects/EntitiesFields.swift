//
//  EntityFields.swift
//  AssessmentDatabase
//
//  Created by Vlad Zhavoronkov  on 8/1/19.
//  Copyright © 2019 Bytepace. All rights reserved.
//

import Foundation

public protocol Sidable {
    var sid: Int64 { get set }
}

public protocol InstructorFields: Sidable {
    var assessments: [AssessmentFields] { get set }
    var students: [StudentFields] { get set }
}

public protocol StudentFields: Sidable {
    var assessmentSids: [Int64] { get set }
    var instructorSids: [Int64] { get set }
    var microTaskGradesSids: [Int64] { get set }
}

public protocol AssessmentFields: Sidable {
    var date: Date { get set }
    var schoolId: Int64 { get set }
    
    var instructorSid: Int64 { get set }
    var rubric: RubricFields { get set }
    var studentMicrotaskGrades: [StudentMicrotaskGradeFields] { get set }
    var students: [StudentFields] { get set }
}

public protocol RubricFields: Sidable {
    var skillSets: [SkillSetFields] { get set }
}

public protocol SkillSetFields: Sidable {
    var rubricSid: Int64 { get set }
    var microTasks: [MicrotaskFields] { get set }
}

public protocol MicrotaskFields: Sidable {
    var skillSetSid: Int64 { get set }
}

public protocol StudentMicrotaskGradeFields: Sidable {
    var assessmentSid: Int64 { get set }
    var grade: GradeFields { get set }
    var microTaskSid: Int64 { get set }
    var studentSid: Int64 { get set }
}

public protocol GradeFields: Sidable {
    var title: String { get set }
}
