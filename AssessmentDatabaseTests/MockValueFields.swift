//
//  MockValueFields.swift
//  AssessmentDatabaseTests
//
//  Created by Vlad Zhavoronkov  on 7/31/19.
//  Copyright © 2019 Bytepace. All rights reserved.
//

import Foundation

let count: Range<Int64> = (0..<7)
let mediumCount: Range<Int64> = (0..<5)
let smallCount: Range<Int64> = (0..<2)

struct MockAssessmentFields: AssessmentFields {
    var sid: Int64
    var date: Date
    var schoolId: Int64
    
    var instructorSid: Int64
    var rubric: RubricFields
    var studentMicrotaskGrades: [StudentMicrotaskGradeFields]
    var students: [StudentFields]
}

struct MockInstructorFields: InstructorFields {
    var sid: Int64
    
    var assessments: [AssessmentFields]
    var students: [StudentFields]
}

struct MockRubricFields: RubricFields {
    var sid: Int64
    
    var skillSets: [SkillSetFields]
}

struct MockStudentMicrotaskGrade: StudentMicrotaskGradeFields {
    var sid: Int64
    
    var assessmentSid: Int64
    var grade: GradeFields
    var microTaskSid: Int64
    var studentSid: Int64
}

struct MockStudentFields: StudentFields {
    var sid: Int64
    
    var assessmentSids: [Int64]
    var instructorSids: [Int64]
    var microTaskGradesSids: [Int64]
}

struct MockGradeFields: GradeFields {
    var sid: Int64
    var title: String
}

struct MockMicrotaskFields: MicrotaskFields, Hashable {
    static func == (lhs: MockMicrotaskFields, rhs: MockMicrotaskFields) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    func hash(Int64o hasher: inout Hasher) {
        hasher.combine(sid)
    }
    
    var sid: Int64
    
    var skillSetSid: Int64
}

struct MockSkillSets: SkillSetFields {
    var sid: Int64
    
    var rubricSid: Int64
    var microTasks: [MicrotaskFields]
}

struct AssessmentUtilsTestMocks {
    let rubrics: [MockRubricFields] = count.map {
        MockRubricFields(sid: $0, skillSets: [])
    }
    
    let instructors: [MockInstructorFields] = count.map {
        MockInstructorFields(sid: $0, assessments: [], students: [])
    }
    
    lazy var students: [MockStudentFields] = instructors.map { instructor in
        return smallCount.map {
            let sid = (smallCount.max()! + 1) * instructor.sid + $0
            return MockStudentFields(sid: sid, assessmentSids: [], instructorSids: [instructor.sid], microTaskGradesSids: [])
        }
    }.reduce([], { $0 + $1 })
    
    lazy var assessments: [MockAssessmentFields] = instructors.map { instructor in
        let instructorStudents = students.filter({ student in
            return student.instructorSids.contains(where: { $0 == instructor.sid })
        })
        let rubric = rubrics.randomElement()!
        return MockAssessmentFields(sid: instructor.sid, date: Date(), schoolId: count.randomElement()!, instructorSid: instructor.sid, rubric: rubric, studentMicrotaskGrades: [], students: instructorStudents)
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
            MockGradeFields(sid: $0, title: gradesTitles[Int($0)])
        }
    }()
}

struct InstructorUtilsTestMocks {
    let emptyInstructors: [MockInstructorFields] = count.map {
        return MockInstructorFields(sid: $0, assessments: [], students: [])
    }
}

struct MicrotaskUtilsTestMocks {
    let rubrics: [MockRubricFields] = count.map {
        MockRubricFields(sid: $0, skillSets: [])
    }
    lazy var skillSets: [MockSkillSets] = count.map {
        MockSkillSets(sid: $0, rubricSid: rubrics[Int($0)].sid, microTasks: [])
    }
    lazy var microtasks: [MockMicrotaskFields] = count.map {
        MockMicrotaskFields(sid: $0, skillSetSid: skillSets[Int($0)].sid)
    }
}

struct RubricUtilsTestMocks {
    let emptyRubrics: [MockRubricFields] = count.map {
        MockRubricFields(sid: $0, skillSets: [])
    }
}

struct SkillSetsUtilsTestMocks {
    let rubrics: [MockRubricFields] = count.map {
        MockRubricFields(sid: $0, skillSets: [])
    }
    lazy var skillSets: [MockSkillSets] = count.map {
        MockSkillSets(sid: $0, rubricSid: rubrics[Int($0)].sid, microTasks: [])
    }
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
            MockGradeFields(sid: $0, title: gradesTitles[Int($0)])
        }
    }()
    let instructors: [MockInstructorFields] = count.map {
        MockInstructorFields(sid: $0, assessments: [], students: [])
    }
    lazy var students: [MockStudentFields] = count.map {
        MockStudentFields(sid: $0, assessmentSids: [], instructorSids: [instructors[Int($0)].sid], microTaskGradesSids: [])
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
        let instructorSid = instructors[Int(rubric.sid)].sid
        let assessmentStudents = students.filter { $0.instructorSids.contains(instructorSid) }
        return MockAssessmentFields(sid: rubric.sid, date: Date(), schoolId: rubric.sid + 1, instructorSid: instructors[Int(rubric.sid)].sid, rubric: rubric, studentMicrotaskGrades: [], students: assessmentStudents)
    }
    lazy var microtaskGrades: [MockStudentMicrotaskGrade] = count.map {
        MockStudentMicrotaskGrade(sid: $0, assessmentSid: assessments[Int($0)].sid, grade: grades.randomElement()!, microTaskSid: microTasks[Int($0)].sid, studentSid: assessments[Int($0)].students.first!.sid)
    }
}

struct StudentsUtilsTestMocks {
    let instructors: [MockInstructorFields] = count.map {
        MockInstructorFields(sid: $0, assessments: [], students: [])
    }
    
    lazy var students: [MockStudentFields] = count.map {
        MockStudentFields(sid: $0, assessmentSids: [], instructorSids: [instructors[Int($0)].sid], microTaskGradesSids: [])
    }
}

struct EntityUtilsMethodsTestMocks {
    var mockGrades: [MockGradeFields] = count.map {
        MockGradeFields(sid: $0, title: "Lorem Ipsum")
    }
    
    var savedItems: [MockGradeFields] = count.map {
        MockGradeFields(sid: $0, title: "")
    }
}
