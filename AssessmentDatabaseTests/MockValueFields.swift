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
    
    var instructor: InstructorFields
    var rubric: RubricFields
    var studentMicrotaskGrades: [StudentMicrotaskGradeFields]
    var students: [StudentFields]
}

struct MockInstructorFields: InstructorFields {
    var sid: Int
}

struct MockRubricFields: RubricFields {
    var sid: Int
}

struct MockStudentMicrotaskGrade: StudentMicrotaskGradeFields {
    var sid: Int
}

struct MockStudentFields: StudentFields {
    var sid: Int
}

struct MockGradeFields: GradeFields {
    var sid: Int
    var title: String
}

let mockAssessments: [MockAssessmentFields] = count.map {
    let rubric = mockRubrics[$0]
    let students = mockStudents
    let instructor = mockInstructors[$0]
    let microtaskGrades = mockMicrotaskGrades
    return MockAssessmentFields(sid: $0, date: Date(), schoolId: $0 + 1, instructor: instructor, rubric: rubric, studentMicrotaskGrades: microtaskGrades, students: students)
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

let mockInstructors: [MockInstructorFields] = count.map {
    MockInstructorFields(sid: $0)
}

let mockMicrotaskGrades: [MockStudentMicrotaskGrade] = count.map {
    MockStudentMicrotaskGrade(sid: $0)
}
