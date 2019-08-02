//
//  AssessmentValueFields.swift
//  AssessmentDatabase
//
//  Created by Vlad Zhavoronkov  on 7/31/19.
//  Copyright © 2019 Bytepace. All rights reserved.
//

import Foundation

public protocol AssessmentFields {
    var sid: Int { get set }
    var date: Date { get set }
    var schoolId: Int { get set }
    
    var instructor: InstructorFields { get set }
    var rubric: RubricFields { get set }
    var studentMicrotaskGrades: [StudentMicrotaskGradeFields] { get set }
    var students: [StudentFields] { get set }
}
