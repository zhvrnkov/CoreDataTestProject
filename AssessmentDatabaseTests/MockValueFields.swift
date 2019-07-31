//
//  MockValueFields.swift
//  AssessmentDatabaseTests
//
//  Created by Vlad Zhavoronkov  on 7/31/19.
//  Copyright © 2019 Bytepace. All rights reserved.
//

import Foundation

struct MockAssessmentFields: AssessmentFields {
    var sid: Int
    var date: Date
    var schoolId: Int
    var students: [StudentFields]
    var rubric: RubricFields
}

struct MockStudentFields: StudentFields {
    
}

struct MockRubricFields: RubricFields {
    
}

let assessments: [MockAssessmentFields] = (0..<7).map {
    let students = (0..<$0).map { _ in MockStudentFields() }
    let rubric = MockRubricFields()
    return MockAssessmentFields(sid: $0, date: Date(), schoolId: $0, students: students, rubric: rubric)
}
