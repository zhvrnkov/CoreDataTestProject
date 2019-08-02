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
    
    var assessment: AssessmentFields
    var grade: GradeFields
    //    var microTask: MicrotaskFields
    var student: StudentFields
}

struct MockStudentFields: StudentFields {
    var sid: Int
}

struct MockGradeFields: GradeFields {
    var sid: Int
    var title: String
}

struct Mocks {
    static var mockAssessments: [MockAssessmentFields] {
        let rubrics = mockRubrics
        let students = mockStudents
        let instructors = mockInstructors
        let microtaskGrades = mockMicrotaskGrades
        return count.map {
            let rubric = rubrics[$0]
            let students = students
            let instructor = instructors[$0]
            let microtaskGrades = microtaskGrades
            return MockAssessmentFields(sid: $0, date: Date(), schoolId: $0 + 1, instructor: instructor, rubric: rubric, studentMicrotaskGrades: microtaskGrades, students: students)
        }
    }
    
    static var mockEmptyAssessments: [MockAssessmentFields] {
        let rubrics = mockRubrics
        let instructors = mockInstructors
        return count.map {
            let rubric = rubrics[$0]
            let instructor = instructors[$0]
            return MockAssessmentFields(sid: $0, date: Date(), schoolId: $0+1, instructor: instructor, rubric: rubric, studentMicrotaskGrades: [], students: [])
        }
    }
    
    static var mockStudents: [MockStudentFields] {
        return count.map {
            MockStudentFields(sid: $0)
        }
    }
    
    static var mockRubrics: [MockRubricFields] {
        return count.map {
            MockRubricFields(sid: $0)
        }
    }
    
    static var mockGrades: [MockGradeFields] {
        return count.map {
            MockGradeFields(sid: $0, title: "Lorem Ipsum")
        }
    }
    
    static var mockInstructors: [MockInstructorFields] {
        return count.map {
            MockInstructorFields(sid: $0)
        }
    }
    
    static var mockMicrotaskGrades: [MockStudentMicrotaskGrade] {
        let assessments = mockEmptyAssessments
        let grades = mockGrades
        let students = mockStudents
        return count.map {
            let assessment = assessments[$0]
            let grade = grades[$0]
            let student = students[$0]
            return MockStudentMicrotaskGrade(sid: $0, assessment: assessment, grade: grade, student: student)
        }
    }
    
}
