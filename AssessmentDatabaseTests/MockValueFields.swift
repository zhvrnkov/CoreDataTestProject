//
//  MockValueFields.swift
//  AssessmentDatabaseTests
//
//  Created by Vlad Zhavoronkov  on 7/31/19.
//  Copyright © 2019 Bytepace. All rights reserved.
//

import Foundation

let count = (0..<7)
let mediumCount = (0..<5)
let smallCount = (0..<2)

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
    
    var assessments: [AssessmentFields]
    var students: [StudentFields]
}

struct MockRubricFields: RubricFields {
    var sid: Int
    
    var skillSets: [SkillSetFields]
}

struct MockStudentMicrotaskGrade: StudentMicrotaskGradeFields {
    var sid: Int
    
    var assessment: AssessmentFields
    var grade: GradeFields
    var microTask: MicrotaskFields
    var student: StudentFields
}

struct MockStudentFields: StudentFields {
    var sid: Int
    
    var assessments: [AssessmentFields]
    var instructors: [InstructorFields]
    var microTaskGrades: [StudentMicrotaskGradeFields]
}

struct MockGradeFields: GradeFields {
    var sid: Int
    var title: String
}

struct MockMicrotaskFields: MicrotaskFields, Hashable {
    static func == (lhs: MockMicrotaskFields, rhs: MockMicrotaskFields) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(sid)
    }
    
    var sid: Int
    
    var skillSet: SkillSetFields
    var studentMicroTaskGrades: [StudentMicrotaskGrade]
}

struct MockSkillSets: SkillSetFields {
    var sid: Int
    
    var rubric: RubricFields
    var microTasks: [Microtask]
}

struct AssessmentUtilsTestMocks {
    let instructors: [MockInstructorFields] = count.map {
        MockInstructorFields(sid: $0, assessments: [], students: [])
    }
    lazy var students: [MockStudentFields] = instructors.map { instructor in
        return smallCount.map {
            let sid = (smallCount.max()! + 1) * instructor.sid + $0
            return MockStudentFields(sid: sid, assessments: [], instructors: [instructor], microTaskGrades: [])
        }
        }.reduce([], { $0 + $1 })
    let rubrics: [MockRubricFields] = count.map {
        MockRubricFields(sid: $0, skillSets: [])
    }
    lazy var skillSets: [MockSkillSets] = rubrics.map { rubric in
        return smallCount.map {
            let sid = (smallCount.max()! + 1) * rubric.sid + $0
            return MockSkillSets(sid: sid, rubric: rubric, microTasks: [])
        }
        }.reduce([], { $0 + $1 })
    lazy var microtasks: [MockMicrotaskFields] = skillSets.map { skillSet in
            return smallCount.map {
                let sid = (smallCount.max()! + 1) * skillSet.sid + $0
                return MockMicrotaskFields(sid: sid, skillSet: skillSet, studentMicroTaskGrades: [])
            }
        }.reduce([], { $0 + $1 })
    let grades: [MockGradeFields] = {
        let gradesTitles: [String] = [
            "Excellent",
            "Good",
            "Common",
            "Bad",
            "Fuck you"
        ]
        return mediumCount.map {
            MockGradeFields(sid: $0, title: gradesTitles[$0])
        }
    }()
    lazy var assessments: [MockAssessmentFields] = instructors.map { instructor in
        let instructorStudents = students.filter({ student in
            return student.instructors.contains(where: { $0.sid == instructor.sid })
        })
        let rubric = rubrics.randomElement()!
        return MockAssessmentFields(sid: instructor.sid, date: Date(), schoolId: count.randomElement()!, instructor: instructor, rubric: rubric, studentMicrotaskGrades: [], students: instructorStudents)
    }
    lazy var microtaskGrades: [MockStudentMicrotaskGrade] = students.map { student in
        let microtask = microtasks.randomElement()!
        let studentAssessment = assessments.filter { assessment in
            return assessment.students.contains(where: { $0.sid == student.sid })
        }.randomElement()!
        return MockStudentMicrotaskGrade(sid: student.sid, assessment: studentAssessment, grade: grades.randomElement()!, microTask: microtask, student: student)
    }
}

struct GradesUtilsTestMocks {
    let grades: [MockGradeFields] = {
        let gradesTitles: [String] = [
            "Excellent",
            "Good",
            "Common",
            "Bad",
            "Fuck you"
        ]
        return mediumCount.map {
            MockGradeFields(sid: $0, title: gradesTitles[$0])
        }
    }()
}

struct InstructorUtilsTestMocks {
    let rubrics: [MockRubricFields] = count.map {
        MockRubricFields(sid: $0, skillSets: [])
    }
    let students: [MockStudentFields] = count.map {
        MockStudentFields(sid: $0, assessments: [], instructors: [], microTaskGrades: [])
    }
    lazy var instructorsWithAssessments: [MockInstructorFields] = (0..<2).map {
        let partOfStudents = Array(students[(0..<(0..<students.count).randomElement()!)])
        return MockInstructorFields(sid: $0, assessments: [], students: partOfStudents)
    }
    lazy var instructorsWithStudents: [MockInstructorFields] = (2..<4).map {
        let partOfStudents = Array(students[(0..<(0..<students.count).randomElement()!)])
        return MockInstructorFields(sid: $0, assessments: [], students: partOfStudents)
    }
    let emptyInstructors: [MockInstructorFields] = (4..<6).map {
        return MockInstructorFields(sid: $0, assessments: [], students: [])
    }
    lazy var assessments: [MockAssessmentFields] = instructorsWithAssessments.map { instructor in
        let assessment = MockAssessmentFields(sid: instructor.sid, date: Date(), schoolId: instructor.sid + 1, instructor: instructor, rubric: rubrics.randomElement()!, studentMicrotaskGrades: [], students: instructor.students)
        return assessment
    }
    mutating func getAllInstructors() -> [MockInstructorFields] {
        let a = instructorsWithStudents
        let b = instructorsWithAssessments
        let c = emptyInstructors
        return a + b + c
    }
}

struct MicrotaskUtilsTestMocks {
    let rubrics: [MockRubricFields] = count.map {
        MockRubricFields(sid: $0, skillSets: [])
    }
    lazy var skillSets: [MockSkillSets] = count.map {
        MockSkillSets(sid: $0, rubric: rubrics[$0], microTasks: [])
    }
    lazy var microtasks: [MockMicrotaskFields] = count.map {
        MockMicrotaskFields(sid: $0, skillSet: skillSets[$0], studentMicroTaskGrades: [])
    }
}

struct Mocks {
    static var mockAssessments: [MockAssessmentFields] {
        let rubrics = mockEmptyRubrics
        let students = mockStudents
        let instructors = mockEmptyInstructors
        let grades = mockGrades
        let microTasks = mockMicrotasks.reduce([]) { $0 + $1 }
        return count.map {
            let rubric = rubrics[$0]
            let students = students
            let instructor = instructors[$0]
            var assessment = MockAssessmentFields(sid: $0, date: Date(), schoolId: $0 + 1, instructor: instructor, rubric: rubric, studentMicrotaskGrades: [], students: students)
            let microtaskGrades = count.map {
                MockStudentMicrotaskGrade(sid: (assessment.sid * (count.max()! + 1)) + $0, assessment: assessment, grade: grades[$0], microTask: microTasks[$0], student: students[$0])
            }
            assessment.studentMicrotaskGrades = microtaskGrades
            return assessment
        }
    }
    
    static var mockEmptyAssessments: [MockAssessmentFields] {
        let rubrics = mockEmptyRubrics
        let instructors = mockEmptyInstructors
        return count.map {
            let rubric = rubrics[$0]
            let instructor = instructors[$0]
            return MockAssessmentFields(sid: $0, date: Date(), schoolId: $0+1, instructor: instructor, rubric: rubric, studentMicrotaskGrades: [], students: [])
        }
    }
    
    static var mockStudents: [MockStudentFields] {
        let assessments = mockEmptyAssessments
        let instructors = mockEmptyInstructors
        let microTaskGrades = mockMicrotaskGrades
        return count.map {
            MockStudentFields(sid: $0, assessments: assessments, instructors: instructors, microTaskGrades: microTaskGrades)
        }
    }
    
    static var mockEmptyStudents: [MockStudentFields] {
        return count.map {
            MockStudentFields(sid: $0, assessments: [], instructors: [], microTaskGrades: [])
        }
    }
    
    static var mockEmptyRubrics: [MockRubricFields] {
        return count.map {
            MockRubricFields(sid: $0, skillSets: [])
        }
    }
    
    static var mockGrades: [MockGradeFields] {
        return count.map {
            MockGradeFields(sid: $0, title: "Lorem Ipsum")
        }
    }
    
    static var mockSkillSets: [[MockSkillSets]] {
        let rubrics = mockEmptyRubrics
        return count.map { index in
            count.map {
                MockSkillSets(sid: (index * (count.max()! + 1)) + $0, rubric: rubrics[index], microTasks: [])
            }
        }
    }
    
    static var mockEmptyInstructors: [MockInstructorFields] {
        return count.map {
            MockInstructorFields(sid: $0, assessments: [], students: [])
        }
    }
    
    static var mockInstructors: [MockInstructorFields] {
        let assessments = mockEmptyAssessments
        let students = mockEmptyStudents
        return count.map {
            MockInstructorFields(sid: $0, assessments: [assessments[$0]], students: [students[$0]])
        }
    }
    
    static var mockMicrotaskGrades: [MockStudentMicrotaskGrade] {
        let assessments = mockEmptyAssessments
        let grades = mockGrades
        let students = mockEmptyStudents
        let microtasks = mockMicrotasks.reduce([]) { $0 + $1 }
        return count.map {
            let assessment = assessments[$0]
            let grade = grades[$0]
            let student = students[$0]
            let microTask = microtasks[$0]
            return MockStudentMicrotaskGrade(sid: $0, assessment: assessment, grade: grade, microTask: microTask, student: student)
        }
    }
    
    static var mockMicrotasks: [[MockMicrotaskFields]] {
        let skillSets = mockSkillSets.reduce([]) { $0 + $1 }
        return skillSets.map { skillSet in
            return count.map {
                MockMicrotaskFields(sid: (skillSet.sid * (count.max()! + 1)) + $0, skillSet: skillSet, studentMicroTaskGrades: [])
            }
        }
    }
}
