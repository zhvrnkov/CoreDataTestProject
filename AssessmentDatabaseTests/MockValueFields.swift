//
//  MockValueFields.swift
//  AssessmentDatabaseTests
//
//  Created by Vlad Zhavoronkov  on 7/31/19.
//  Copyright © 2019 Bytepace. All rights reserved.
//

import Foundation

fileprivate let count: Range<Int> = (0..<7)
fileprivate let mediumCount: Range<Int> = (0..<5)
fileprivate let smallCount: Range<Int> = (0..<2)

fileprivate func getInstructor(_ sid: Int) -> MockInstructorFields {
    return MockInstructorFields(sid: sid, loginUsername: "zhvrnkv", firstName: "Vlad", lastName: "Zhavoronkov", avatar: "anime", email: "@dada.ya", phone: "8921380123", phoneStudent: "12839128", address: "hsdahfsd", address2: "fsdklfhs", city: "slkdhflksf", state: "fklhdahsl", zip: "skjdfhksj", country: "lksdhfaslk", credentials: "flsdhfaslkj", depiction: "sldfhsk", fbid: ["fdjsafglfas"], lang: "RU", flags: ["dsajdhla"], assessments: [], students: [], schools: [])
}

struct MockAssessmentFields: AssessmentFields {
    typealias StudentFieldsType = MockStudentFields
    typealias RubricFieldsType = MockRubricFields
    
    var sid: Int
    var date: Date
    var schoolId: Int
    var isSynced: Bool
    var isAddedToServer: Bool
    var instructorSid: Int
    var rubric: RubricFieldsType
    var microTaskGradeSids: [Int]
    var students: [StudentFieldsType]
    
    init(sid: Int,
         isSynced: Bool,
         date: Date,
         schoolId: Int,
         isAddedToServer: Bool,
         instructorSid: Int,
         rubric: RubricFieldsType,
         microTaskGradeSids: [Int],
         students: [StudentFieldsType])
    {
        self.sid = sid
        self.isSynced = isSynced
        self.date = date
        self.schoolId = schoolId
        self.isAddedToServer = isAddedToServer
        self.instructorSid = instructorSid
        self.rubric = rubric
        self.microTaskGradeSids = microTaskGradeSids
        self.students = students
    }
}

struct MockSchoolFields: SchoolFields {
    init(sid: Int, name: String) {
        self.sid = sid
        self.name = name
    }
    
    typealias InstructorFieldsType = MockInstructorFields
    
    var sid: Int
    var name: String
    var instructorSids: [Int] = []
}

struct MockInstructorFields: InstructorFields {
    typealias AssessmentFieldsType = MockAssessmentFields
    typealias StudentFieldsType = MockStudentFields
    typealias SchoolFieldsType = MockSchoolFields
    
    var sid: Int
    var loginUsername: String
    var firstName: String
    var lastName: String
    var avatar: String
    var email: String
    var phone: String
    var phoneStudent: String
    var address: String
    var address2: String
    var city: String
    var state: String
    var zip: String
    var country: String
    var credentials: String
    var depiction: String
    var fbid: [String]
    var lang: String
    var flags: [String]
    
    var assessments: [AssessmentFieldsType]
    var students: [StudentFieldsType]
    var schools: [SchoolFieldsType]
}

struct MockRubricFields: RubricFields {
    typealias SkillSetFieldsType = MockSkillSets
    typealias GradeFieldsType = MockGradeFields
    
    static func mock(sid: Int) -> MockRubricFields {
        return .init(sid: sid, title: "Lorem Ipsum", lastUpdate: 123, weight: 0, isActive: true, skillSets: [], grades: [])
    }
    var sid: Int
    var title: String
    var lastUpdate: Int
    var weight: Int
    var isActive: Bool

    var skillSets: [SkillSetFieldsType]
    var grades: [GradeFieldsType]
}

struct MockSkillSets: SkillSetFields {
    init(sid: Int, rubricSid: Int, isActive: Bool, title: String, weight: Int, microTasks: [MockMicrotaskFields]) {
        self.sid = sid
        self.rubricSid = rubricSid
        self.isActive = isActive
        self.title = title
        self.weight = weight
        self.microTasks = microTasks
    }
    
    typealias MicrotaskFieldsType = MockMicrotaskFields
    
    static func mock(sid: Int, rubricSid: Int) -> MockSkillSets {
        return .init(sid: sid, rubricSid: rubricSid, isActive: true, title: "Lorem Pupsum", weight: 0, microTasks: [])
    }
    
    var sid: Int
    var title: String
    var weight: Int
    var isActive: Bool
    var rubricSid: Int
    
    var microTasks: [MicrotaskFieldsType]
}

struct MockMicrotaskFields: MicrotaskFields {
    init(sid: Int, critical: Int, depiction: String, isActive: Bool, title: String, weight: Int, skillSetSid: Int) {
        self.sid = sid
        self.critical = critical
        self.depiction = depiction
        self.isActive = isActive
        self.title = title
        self.weight = weight
        self.skillSetSid = skillSetSid
    }
    
    static func mock(sid: Int, skillSetSid: Int) -> MockMicrotaskFields {
        return .init(sid: sid, critical: 1, depiction: "Lorem Dipsum", isActive: true, title: "Pip", weight: 0, skillSetSid: skillSetSid)
    }
    
    var sid: Int
    var isActive: Bool
    var critical: Int
    var depiction: String
    var title: String
    var weight: Int
    
    var skillSetSid: Int
}

struct MockStudentMicrotaskGrade: StudentMicrotaskGradeFields {
    init(sid: Int, lastUpdated: Int, passed: Bool, isSynced: Bool, assessmentSid: Int, microTaskSid: Int, studentSid: Int, gradeSid: Int) {
        self.sid = sid
        self.lastUpdated = lastUpdated
        self.passed = passed
        self.isSynced = isSynced
        self.assessmentSid = assessmentSid
        self.microTaskSid = microTaskSid
        self.studentSid = studentSid
        self.gradeSid = gradeSid
    }
    
    var sid: Int
    var isSynced: Bool
    var passed: Bool
    var lastUpdated: Int
    
    var assessmentSid: Int
    var gradeSid: Int
    var microTaskSid: Int
    var studentSid: Int
}

struct MockStudentFields: StudentFields {
    typealias StudentMicrotaskGradeFieldsType = MockStudentMicrotaskGrade
    
    init(sid: Int,
         email: String,
         logbookPass: String,
         name: String,
         rank: String,
         qualifiedDays: Int,
         level: String,
         assessmentSids: [Int],
         instructorSids: [Int],
         microTaskGrades: [StudentMicrotaskGradeFieldsType])
    {
        self.sid = sid
        self.email = email
        self.logbookPass = logbookPass
        self.name = name
        self.assessmentSids = assessmentSids
        self.instructorSids = instructorSids
        self.microTaskGrades = microTaskGrades
        self.level = level
        self.qualifiedDays = qualifiedDays
        self.rank = rank
    }
    
    static func mock(sid: Int) -> MockStudentFields {
        return .init(sid: sid, email: "lorem", logbookPass: "ipsum", name: "foo", rank: "Chester", qualifiedDays: 4, level: "Master", assessmentSids: [], instructorSids: [], microTaskGrades: [])
    }
    var sid: Int
    var name: String
    var email: String
    var logbookPass: String
    var level: String
    var qualifiedDays: Int
    var rank: String
    
    var assessmentSids: [Int]
    var instructorSids: [Int]
    var microTaskGrades: [StudentMicrotaskGradeFieldsType]
}

struct MockGradeFields: GradeFields {
    init(sid: Int, title: String, passed: Bool, score: Int, rubricSid: Int) {
        self.sid = sid
        self.title = title
        self.passed = passed
        self.score = score
        self.rubricSid = rubricSid
    }
    
    static func mock(sid: Int) -> MockGradeFields {
        return .init(sid: sid, title: "Lorem Ipsum", passed: true, score: 0, rubricSid: 1)
    }
    var sid: Int
    var title: String
    var score: Int
    var passed: Bool
    var rubricSid: Int
}



struct AssessmentUtilsTestMocks {
    let rubrics: [MockRubricFields] = count.map {
        MockRubricFields.mock(sid: $0)
    }
    
    let instructors: [MockInstructorFields] = count.map {
        return getInstructor($0)
    }
    
    lazy var students: [MockStudentFields] = instructors.map { instructor in
        return smallCount.map {
            let sid = (smallCount.max()! + 1) * instructor.sid + $0
            var temp = MockStudentFields.mock(sid: sid)
            temp.instructorSids.append(instructor.sid)
            return temp
        }
    }.reduce([], { $0 + $1 })
    
    lazy var assessments: [MockAssessmentFields] = instructors.map { instructor in
        let instructorStudents = students.filter({ student in
            return student.instructorSids.contains(where: { $0 == instructor.sid })
        })
        let rubric = rubrics.randomElement()!
        return MockAssessmentFields(sid: instructor.sid, isSynced: false, date: Date(), schoolId: count.randomElement()!, isAddedToServer: Bool.random(), instructorSid: instructor.sid, rubric: rubric, microTaskGradeSids: [], students: instructorStudents)
    }
}

struct GradesUtilsTestMocks {
    let rubric = MockRubricFields(sid: 1, title: "", lastUpdate: 12, weight: 1, isActive: true, skillSets: [], grades: [])
    let grades: [MockGradeFields] = {
        let gradesTitles: [String] = [
            "Excellent",
            "Good",
            "Common",
            "Bad",
            "Fuck you"
        ]
        return mediumCount.map {
            MockGradeFields.mock(sid: $0)
        }
    }()
}

struct InstructorUtilsTestMocks {
    let schools: [MockSchoolFields] = [
        MockSchoolFields(sid: 1, name: "School №56"),
        MockSchoolFields(sid: 2, name: "School of life")
    ]
    
    let emptyInstructors: [MockInstructorFields] = count.map {
        return getInstructor($0)
    }
    
    lazy private(set) var itemsWithScools: [MockInstructorFields] = count.map {
        var instructor = getInstructor($0)
        instructor.schools = schools
        return instructor
    }
}

struct MicrotaskUtilsTestMocks {
    let rubrics: [MockRubricFields] = count.map {
        MockRubricFields.mock(sid: $0)
    }
    lazy var skillSets: [MockSkillSets] = count.map {
        MockSkillSets.mock(sid: $0, rubricSid: rubrics[Int($0)].sid)
    }
    lazy var microtasks: [MockMicrotaskFields] = count.map {
        MockMicrotaskFields.mock(sid: $0, skillSetSid: skillSets[Int($0)].sid)
    }
}

struct RubricUtilsTestMocks {
    let emptyRubrics: [MockRubricFields] = count.map {
        MockRubricFields.mock(sid: $0)
    }
}

struct SkillSetsUtilsTestMocks {
    let rubrics: [MockRubricFields] = count.map {
        MockRubricFields.mock(sid: $0)
    }
    lazy var skillSets: [MockSkillSets] = count.map {
        MockSkillSets.mock(sid: $0, rubricSid: rubrics[Int($0)].sid)
    }
}

struct StudentMicrotaskGradesUtilsTestMocks {
    let grades: [MockGradeFields] = {
        return mediumCount.map {
            MockGradeFields.mock(sid: $0)
        }
    }()
    let instructors: [MockInstructorFields] = count.map {
        return getInstructor($0)
    }
    lazy var students: [MockStudentFields] = count.map {
        var temp = MockStudentFields.mock(sid: $0)
        temp.instructorSids.append(instructors[Int($0)].sid)
        return temp
    }
    let rubrics: [MockRubricFields] = count.map {
        MockRubricFields.mock(sid: $0)
    }
    lazy var skillSets: [MockSkillSets] = rubrics.map { rubric in
        MockSkillSets.mock(sid: rubric.sid, rubricSid: rubric.sid)
    }
    lazy var microTasks: [MockMicrotaskFields] = skillSets.map { skillSet in
        MockMicrotaskFields.mock(sid: skillSet.sid, skillSetSid: skillSet.sid)
    }
    lazy var assessments: [MockAssessmentFields] = rubrics.map { rubric in
        let instructorSid = instructors[Int(rubric.sid)].sid
        let assessmentStudents = students.filter { $0.instructorSids.contains(instructorSid) }
        return MockAssessmentFields(sid: rubric.sid, isSynced: false, date: Date(), schoolId: rubric.sid + 1, isAddedToServer: Bool.random(), instructorSid: instructors[Int(rubric.sid)].sid, rubric: rubric, microTaskGradeSids: [], students: assessmentStudents)
    }
    lazy var microtaskGrades: [MockStudentMicrotaskGrade] = count.map {
        MockStudentMicrotaskGrade(sid: $0, lastUpdated: 123, passed: true, isSynced: true, assessmentSid: assessments[Int($0)].sid, microTaskSid: microTasks[Int($0)].sid, studentSid: assessments[Int($0)].studentSids.first!, gradeSid: (grades.randomElement()!).sid)
    }
}

struct StudentsUtilsTestMocks {
    let instructors: [MockInstructorFields] = count.map {
        return getInstructor($0)
    }
    
    lazy var students: [MockStudentFields] = count.map {
        var temp = MockStudentFields.mock(sid: $0)
        temp.instructorSids.append(instructors[Int($0)].sid)
        return temp
    }
}

struct EntityUtilsMethodsTestMocks {
    let rubrics: [MockRubricFields] = count.map {
        MockRubricFields.mock(sid: $0)
    }
    let skillSets: [MockSkillSets] = count.map {
        MockSkillSets.mock(sid: $0, rubricSid: $0)
    }
}
