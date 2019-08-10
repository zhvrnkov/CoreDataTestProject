//
//  EntityFields.swift
//  AssessmentDatabase
//
//  Created by Vlad Zhavoronkov  on 8/1/19.
//  Copyright © 2019 Bytepace. All rights reserved.
//

import Foundation

public protocol InstructorFields {
    var sid: Int { get set }
    
    var assessments: [AssessmentFields] { get set }
    var students: [StudentFields] { get set }
}

public protocol StudentFields {
    var sid: Int { get set }
    
    var assessmentSids: [Int] { get set }
    var instructorSids: [Int] { get set }
    var microTaskGrades: [StudentMicrotaskGradeFields] { get set }
}

public protocol AssessmentFields {
    var sid: Int { get set }
    var date: Date { get set }
    var schoolId: Int { get set }
    
    var instructorSid: Int { get set }
    var rubric: RubricFields { get set }
    var studentMicrotaskGrades: [StudentMicrotaskGradeFields] { get set }
    var students: [StudentFields] { get set }
}

public protocol RubricFields {
    var sid: Int { get set }
    var skillSets: [SkillSetFields] { get set }
}

public protocol SkillSetFields {
    var sid: Int { get set }
    
    var rubricSid: Int { get set }
    var microTasks: [MicrotaskFields] { get set }
}

public protocol MicrotaskFields {
    var sid: Int { get set }
    
    var skillSetSid: Int { get set }
    var studentMicroTaskGrades: [StudentMicrotaskGradeFields] { get set }
}

public protocol StudentMicrotaskGradeFields {
    var sid: Int { get set }
    
    var assessmentSid: Int { get set }
    var gradeSid: GradeFields { get set }
    var microTaskSid: Int { get set }
    var studentSid: Int { get set }
}

public protocol GradeFields {
    var sid: Int { get set }
    var title: String { get set }
}
