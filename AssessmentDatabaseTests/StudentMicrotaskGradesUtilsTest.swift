//
//  StudentMicrotaskGradesUtilsTest.swift
//  AssessmentDatabaseTests
//
//  Created by Vlad Zhavoronkov  on 8/2/19.
//  Copyright © 2019 Bytepace. All rights reserved.
//

import XCTest

class StudentMicrotaskGradesUtilsTest: XCTestCase {
    typealias This = StudentMicrotaskGradesUtilsTest
    static let container = getMockPersistentContainer()
    static let instructorsUtils = InstructorsUtils(with: container)
    static let gradesUtils = GradesUtils(with: container)
    static let rubricsUtils = RubricsUtils(with: container)
    static let studentsUtils = StudentsUtils(with: container)
    static let assessmentsUtils: AssessmentsUtils = {
        let utils = AssessmentsUtils(container: container)
        utils.studentsUtils = StudentsUtils(with: container)
        utils.rubricsUtils = rubricsUtils
        utils.instructorsUtils = instructorsUtils
        utils.studentMicrotaskGradesUtils = StudentMicrotaskGradesUtils(with: container)
        return utils
    }()
    static let util: StudentMicrotaskGradesUtils = {
        let utils = StudentMicrotaskGradesUtils(with: container)
        utils.assessmentsUtils = This.assessmentsUtils
        utils.gradesUtils = This.gradesUtils
        utils.studentsUtils = This.studentsUtils
        return utils
    }()
    
    private let instructor = MockInstructorFields(sid: 1)
    private let rubric = MockRubricFields(sid: 1)
    private var assessment: MockAssessmentFields!
    private var mockStudentMicrtaskGrades: [MockStudentMicrotaskGrade]!
    
    private let mockGrades = Mocks.mockGrades
    private let mockStudents = Mocks.mockStudents
    
    override func setUp() {
        super.setUp()
        assessment = MockAssessmentFields(sid: 1, date: Date(), schoolId: 2, instructor: instructor, rubric: rubric, studentMicrotaskGrades: [], students: [])
        mockStudentMicrtaskGrades = (0..<10).map {
            MockStudentMicrotaskGrade(sid: $0, assessment: assessment, grade: mockGrades.randomElement()!, student: mockStudents.randomElement()!)
        }
        
        XCTAssertNoThrow(try This.instructorsUtils.save(item: instructor))
        XCTAssertNoThrow(try This.rubricsUtils.save(item: rubric))
        XCTAssertNoThrow(try This.assessmentsUtils.save(item: assessment))
        XCTAssertNoThrow(try This.gradesUtils.save(items: mockGrades))
        XCTAssertNoThrow(try This.studentsUtils.save(items: mockStudents))
    }

    override func tearDown() {
        super.tearDown()
        This.util.deleteAll()
        This.instructorsUtils.deleteAll()
        This.rubricsUtils.deleteAll()
        This.assessmentsUtils.deleteAll()
        This.gradesUtils.deleteAll()
        This.studentsUtils.deleteAll()
    }
    
    func testSaveItem() {
        let item = mockStudentMicrtaskGrades[0]
        XCTAssertNoThrow(try This.util.save(item: item))
        compareItems([item], This.util.getAll())
    }
    
    private func compareItems(_ items: [StudentMicrotaskGradeFields], _ entities: [StudentMicrotaskGrade]) {
        XCTAssertEqual(items.count, entities.count)
        items.forEach { item in
            guard let entity = entities.first(where: { Int($0.sid) == item.sid })
            else {
                XCTFail("can't find entity")
                return
            }
            compareItem(item, entity)
        }
    }
    
    private func compareItem(_ item: StudentMicrotaskGradeFields, _ entity: StudentMicrotaskGrade) {
        checkRelations(of: entity)
        checkFields(of: entity)
        
        XCTAssertEqual(entity.assessment?.sid, Int64(item.assessment.sid))
        XCTAssertEqual(entity.grade?.sid, Int64(item.grade.sid))
        XCTAssertEqual(entity.student?.sid, Int64(item.student.sid))
    }
    
    private func checkRelations(of entity: StudentMicrotaskGrade) {
        XCTAssertNotNil(entity.assessment)
        XCTAssertNotNil(entity.grade)
        XCTAssertNotNil(entity.student)
    }
    
    private func checkFields(of entity: StudentMicrotaskGrade) {
        
    }
}
