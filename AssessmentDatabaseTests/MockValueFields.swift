//
//  MockValueFields.swift
//  AssessmentDatabaseTests
//
//  Created by Vlad Zhavoronkov  on 7/31/19.
//  Copyright © 2019 Bytepace. All rights reserved.
//

import Foundation

let count = (0..<7)

struct MockAssessmentFields: AssessmentFields {
    var sid: Int
    var date: Date
    var schoolId: Int
    var students: [StudentFields]
    var rubric: RubricFields
}

struct MockStudentFields: StudentFields {
    var sid: Int
}

struct MockRubricFields: RubricFields {
    var sid: Int
}

struct MockGradeFields: GradeFields {
    var sid: Int
    var title: String
}

let mockAssessments: [MockAssessmentFields] = count.map {
    let rubric = mockRubrics[$0]
    let students = mockStudents
    return MockAssessmentFields(sid: $0, date: Date(), schoolId: $0+1, students: students, rubric: rubric)
}

let mockStudents: [MockStudentFields] = count.map {
    MockStudentFields(sid: $0)
}

let mockRubrics: [MockRubricFields] = count.map {
    MockRubricFields(sid: $0)
}

let mockGrades: [MockGradeFields] = count.map {
    MockGradeFields(sid: $0, title: "Lorem Ipsum")
}
