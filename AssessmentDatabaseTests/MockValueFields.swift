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
    return MockInstructorFields(sid: sid, loginUsername: "zhvrnkv", firstName: "Vlad", lastName: "Zhavoronkov", avatar: "anime", email: "@dada.ya", phone: "8921380123", phoneStudent: "12839128", address: "hsdahfsd", address2: "fsdklfhs", city: "slkdhflksf", state: "fklhdahsl", zip: "skjdfhksj", country: "lksdhfaslk", credentials: "flsdhfaslkj", depiction: "sldfhsk", fbid: ["fdjsafglfas"], lang: "RU", flags: ["dsajdhla"], schools: [], assessments: [], students: [])
}

struct MockAssessmentFields: AssessmentFields {
    var sid: Int
    var date: Date
    var schoolId: Int
    var isSynced: Bool = false
    
    var instructorSid: Int
    var rubric: RubricFields
    var studentMicrotaskGrades: [StudentMicrotaskGradeFields]
    var students: [StudentFields]
}

struct MockInstructorFields: InstructorFields {
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
    var schools: [Any]
    
    var assessments: [AssessmentFields]
    var students: [StudentFields]
}

struct MockRubricFields: RubricFields {
    static func mock(sid: Int) -> MockRubricFields {
        return .init(sid: sid, title: "Lorem Ipsum", lastUpdate: 123, weight: 0, isActive: true, skillSets: [])
    }
    var sid: Int
    var title: String
    var lastUpdate: Int
    var weight: Int
    var isActive: Bool
    
    var skillSets: [SkillSetFields]
}

struct MockStudentMicrotaskGrade: StudentMicrotaskGradeFields {
    var sid: Int
    var isSynced: Bool = false
    
    var assessmentSid: Int
    var gradeSid: Int
    var microTaskSid: Int
    var studentSid: Int
}

struct MockStudentFields: StudentFields {
    static func mock(sid: Int) -> MockStudentFields {
        return .init(sid: sid, name: "Vlad Zhavoronkov", email: "lorem@ipsum.com", logbookPass: "sakha", assessmentSids: [], instructorSids: [], microTaskGradesSids: [])
    }
    var sid: Int
    var name: String
    var email: String
    var logbookPass: String
    
    var assessmentSids: [Int]
    var instructorSids: [Int]
    var microTaskGradesSids: [Int]
}

struct MockGradeFields: GradeFields {
    static func mock(sid: Int) -> MockGradeFields {
        return .init(sid: sid, title: "Lorem Ipsum", score: 0, passed: 1)
    }
    var sid: Int
    var title: String
    var score: Int
    var passed: Int
}

struct MockMicrotaskFields: MicrotaskFields, Hashable {
    static func == (lhs: MockMicrotaskFields, rhs: MockMicrotaskFields) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    static func mock(sid: Int, skillSetSid: Int) -> MockMicrotaskFields {
        return .init(sid: sid, isActive: true, critical: 1, depiction: "Can identify key safety equipment necessary and the use thereof for a manifestly safe voyage; including fire extinguishers, flares, first aid kit, sound device, flashlight, fire blanket, tool kit, life jackets - inspection and donning. Discuss accessibility.", title: "Lorem Ipsum", weight: 0, skillSetSid: skillSetSid)
    }
    
    func hash(Int64o hasher: inout Hasher) {
        hasher.combine(sid)
    }
    
    var sid: Int
    var isActive: Bool
    var critical: Int
    var depiction: String
    var title: String
    var weight: Int
    
    var skillSetSid: Int
}

struct MockSkillSets: SkillSetFields {
    static func mock(sid: Int, rubricSid: Int) -> MockSkillSets {
        return .init(sid: sid, title: "Lorem Pupsum", weight: 0, isActive: true, rubricSid: rubricSid, microTasks: [])
    }
    
    var sid: Int
    var title: String
    var weight: Int
    var isActive: Bool
    
    var rubricSid: Int
    var microTasks: [MicrotaskFields]
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
        return MockAssessmentFields(sid: instructor.sid, date: Date(), schoolId: count.randomElement()!, isSynced: false, instructorSid: instructor.sid, rubric: rubric, studentMicrotaskGrades: [], students: instructorStudents)
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
            MockGradeFields.mock(sid: $0)
        }
    }()
}

struct InstructorUtilsTestMocks {
    let emptyInstructors: [MockInstructorFields] = count.map {
        return getInstructor($0)
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
        return MockAssessmentFields(sid: rubric.sid, date: Date(), schoolId: rubric.sid + 1, isSynced: false, instructorSid: instructors[Int(rubric.sid)].sid, rubric: rubric, studentMicrotaskGrades: [], students: assessmentStudents)
    }
    lazy var microtaskGrades: [MockStudentMicrotaskGrade] = count.map {
        MockStudentMicrotaskGrade(sid: $0, isSynced: false, assessmentSid: assessments[Int($0)].sid, gradeSid: (grades.randomElement()!).sid, microTaskSid: microTasks[Int($0)].sid, studentSid: assessments[Int($0)].students.first!.sid)
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
    var mockGrades: [MockGradeFields] = count.map {
        MockGradeFields.mock(sid: $0)
    }
    
    var savedItems: [MockGradeFields] = count.map {
        MockGradeFields.mock(sid: $0)
    }
}
