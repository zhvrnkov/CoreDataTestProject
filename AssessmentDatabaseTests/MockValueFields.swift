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
    
    var instructorSid: Int
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
    
    var assessmentSid: Int
    var grade: GradeFields
    var microTaskSid: Int
    var studentSid: Int
}

struct MockStudentFields: StudentFields {
    var sid: Int
    
    var assessmentSids: [Int]
    var instructorSids: [Int]
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
    
    var skillSetSid: Int
}

struct MockSkillSets: SkillSetFields {
    var sid: Int
    
    var rubricSid: Int
    var microTasks: [MicrotaskFields]
}

struct AssessmentUtilsTestMocks {
    lazy var emptyAssessments: [MockAssessmentFields] = count.map {
        MockAssessmentFields(sid: $0, date: Date(), schoolId: $0 + 10, instructorSid: instructors[$0].sid, rubric: rubrics[$0], studentMicrotaskGrades: [], students: [])
    }
    let instructors: [MockInstructorFields] = count.map {
        MockInstructorFields(sid: $0, assessments: [], students: [])
    }
    lazy var students: [MockStudentFields] = instructors.map { instructor in
        return smallCount.map {
            let sid = (smallCount.max()! + 1) * instructor.sid + $0
            return MockStudentFields(sid: sid, assessmentSids: [], instructorSids: [instructor.sid], microTaskGrades: [])
        }
        }.reduce([], { $0 + $1 })
    let rubrics: [MockRubricFields] = count.map {
        MockRubricFields(sid: $0, skillSets: [])
    }
    lazy var skillSets: [MockSkillSets] = rubrics.map { rubric in
        return smallCount.map {
            let sid = (smallCount.max()! + 1) * rubric.sid + $0
            return MockSkillSets(sid: sid, rubricSid: rubric.sid, microTasks: [])
        }
        }.reduce([], { $0 + $1 })
    lazy var microtasks: [MockMicrotaskFields] = skillSets.map { skillSet in
            return smallCount.map {
                let sid = (smallCount.max()! + 1) * skillSet.sid + $0
                return MockMicrotaskFields(sid: sid, skillSetSid: skillSet.sid)
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
            return student.instructorSids.contains(where: { $0 == instructor.sid })
        })
        let rubric = rubrics.randomElement()!
        return MockAssessmentFields(sid: instructor.sid, date: Date(), schoolId: count.randomElement()!, instructorSid: instructor.sid, rubric: rubric, studentMicrotaskGrades: [], students: instructorStudents)
    }
    lazy var microtaskGrades: [MockStudentMicrotaskGrade] = students.map { student in
        let microtask = microtasks.randomElement()!
        let studentAssessment = assessments.filter { assessment in
            return assessment.students.contains(where: { $0.sid == student.sid })
        }.randomElement()!
        return MockStudentMicrotaskGrade(sid: student.sid, assessmentSid: studentAssessment.sid, grade: grades.randomElement()!, microTaskSid: microtask.sid, studentSid: student.sid)
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
        MockStudentFields(sid: $0, assessmentSids: [], instructorSids: [], microTaskGrades: [])
    }
    lazy var instructorsWithAssessments: [MockInstructorFields] = mediumCount.map {
        let partOfStudents = Array(students[(0..<(0..<students.count).randomElement()!)])
        return MockInstructorFields(sid: $0, assessments: [], students: partOfStudents)
    }
    lazy var instructorsWithStudents: [MockInstructorFields] = mediumCount.map {
        let partOfStudents = Array(students[(0..<(0..<students.count).randomElement()!)])
        return MockInstructorFields(sid: $0, assessments: [], students: partOfStudents)
    }
    let emptyInstructors: [MockInstructorFields] = count.map {
        return MockInstructorFields(sid: $0, assessments: [], students: [])
    }
    lazy var assessments: [MockAssessmentFields] = instructorsWithAssessments.map { instructor in
        let assessment = MockAssessmentFields(sid: instructor.sid, date: Date(), schoolId: instructor.sid + 1, instructorSid: instructor.sid, rubric: rubrics.randomElement()!, studentMicrotaskGrades: [], students: instructor.students)
        return assessment
    }
    mutating func getInstructorsWithRelations() -> [MockInstructorFields] {
        let a = instructorsWithStudents
        let b = instructorsWithAssessments
        return a + b
    }
}

struct MicrotaskUtilsTestMocks {
    let rubrics: [MockRubricFields] = count.map {
        MockRubricFields(sid: $0, skillSets: [])
    }
    lazy var skillSets: [MockSkillSets] = count.map {
        MockSkillSets(sid: $0, rubricSid: rubrics[$0].sid, microTasks: [])
    }
    lazy var microtasks: [MockMicrotaskFields] = count.map {
        MockMicrotaskFields(sid: $0, skillSetSid: skillSets[$0].sid)
    }
}

struct RubricUtilsTestMocks {
    let emptyRubrics: [MockRubricFields] = count.map {
        MockRubricFields(sid: $0, skillSets: [])
    }
    let rubricsWithRelations = count.map {
        MockRubricFields(sid: $0, skillSets: [])
    }
    lazy var skillSets: [MockSkillSets] = rubricsWithRelations.map { rubric in
        return smallCount.map {
            let sid = rubric.sid * (smallCount.max()! + 1) + $0
            return MockSkillSets(sid: sid, rubricSid: rubric.sid, microTasks: [])
        }
        }.reduce([]) { $0 + $1 }
}

struct SkillSetsUtilsTestMocks {
    let rubrics: [MockRubricFields] = count.map {
        MockRubricFields(sid: $0, skillSets: [])
    }
    lazy var skillSets: [MockSkillSets] = count.map {
        MockSkillSets(sid: $0, rubricSid: rubrics[$0].sid, microTasks: [])
    }
    lazy var microtasks: [MockMicrotaskFields] = skillSets.map { skillSet in
        return smallCount.map {
            let sid = skillSet.sid * (smallCount.max()! + 1) + $0
            return MockMicrotaskFields(sid: sid, skillSetSid: skillSet.sid)
        }
        }.reduce([]) { $0 + $1 }
}

struct StudentMicrotaskGradesUtilsTestMocks {
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
    let students: [MockStudentFields] = count.map {
        MockStudentFields(sid: $0, assessmentSids: [], instructorSids: [], microTaskGrades: [])
    }
    lazy var instructors: [MockInstructorFields] = count.map {
        MockInstructorFields(sid: $0, assessments: [], students: [students[$0]])
    }
    let rubrics: [MockRubricFields] = count.map {
        MockRubricFields(sid: $0, skillSets: [])
    }
    lazy var skillSets: [MockSkillSets] = rubrics.map { rubric in
        MockSkillSets(sid: rubric.sid, rubricSid: rubric.sid, microTasks: [])
    }
    lazy var microTasks: [MockMicrotaskFields] = skillSets.map { skillSet in
        MockMicrotaskFields(sid: skillSet.sid, skillSetSid: skillSet.sid)
    }
    lazy var assessments: [MockAssessmentFields] = rubrics.map { rubric in
        MockAssessmentFields(sid: rubric.sid, date: Date(), schoolId: rubric.sid + 1, instructorSid: instructors[rubric.sid].sid, rubric: rubric, studentMicrotaskGrades: [], students: instructors[rubric.sid].students)
    }
    lazy var microtaskGrades: [MockStudentMicrotaskGrade] = count.map {
        MockStudentMicrotaskGrade(sid: $0, assessmentSid: assessments[$0].sid, grade: grades.randomElement()!, microTaskSid: microTasks[$0].sid, studentSid: assessments[$0].students.first!.sid)
    }
}

struct StudentsUtilsTestMocks {
    let emptyStudents: [MockStudentFields] = count.map {
        MockStudentFields(sid: $0, assessmentSids: [], instructorSids: [], microTaskGrades: [])
    }
    
    let rubrics: [MockRubricFields] = count.map {
        MockRubricFields(sid: $0, skillSets: [])
    }
    
    let instructors: [MockInstructorFields] = count.map {
        MockInstructorFields(sid: $0, assessments: [], students: [])
    }
    
    lazy var assessments: [MockAssessmentFields] = count.map {
        MockAssessmentFields(sid: $0, date: Date(), schoolId: $0 + 10, instructorSid: instructors[$0].sid, rubric: rubrics[$0], studentMicrotaskGrades: [], students: [])
    }
    
    lazy var studentsWithRelations: [MockStudentFields] = count.map {
        MockStudentFields(sid: $0, assessmentSids: [assessments[$0].sid], instructorSids: [assessments[$0].instructorSid], microTaskGrades: [])
    }
}

struct EntityUtilsMethodsTestMocks {
    var mockGrades: [MockGradeFields] = count.map {
        MockGradeFields(sid: $0, title: "Lorem Ipsum")
    }
}
