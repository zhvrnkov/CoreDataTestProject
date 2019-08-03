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
    static let skillSetsUtils: SkillSetsUtils = {
        let util = SkillSetsUtils(with: container)
        util.rubricUtils = This.rubricsUtils
        return util
    }()
    static let microtasksUtils: MicrotasksUtils = {
        let util = MicrotasksUtils(with: container)
        util.skillSetsUtils = This.skillSetsUtils
        return util
    }()
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
        utils.microtasksUtils = This.microtasksUtils
        return utils
    }()
    
    private let instructors = Mocks.mockEmptyInstructors
    private let rubrics = Mocks.mockEmptyRubrics
    private let assessments = Mocks.mockEmptyAssessments
    private let mockStudentMicrtaskGrades = Mocks.mockMicrotaskGrades
    private let mockMicrotasks = Mocks.mockMicrotasks.reduce([]) { $0 + $1 }
    private let mockSkillsets = Mocks.mockSkillSets.reduce([]) { $0 + $1 }
    private let mockGrades = Mocks.mockGrades
    private let mockStudents = Mocks.mockEmptyStudents
    
    override func setUp() {
        super.setUp()
        XCTAssertNoThrow(try This.instructorsUtils.save(items: instructors))
        XCTAssertNoThrow(try This.rubricsUtils.save(items: rubrics))
        XCTAssertNoThrow(try This.assessmentsUtils.save(items: assessments))
        XCTAssertNoThrow(try This.gradesUtils.save(items: mockGrades))
        XCTAssertNoThrow(try This.studentsUtils.save(items: mockStudents))
        XCTAssertNoThrow(try This.skillSetsUtils.save(items: mockSkillsets))
        XCTAssertNoThrow(try This.microtasksUtils.save(items: mockMicrotasks))
    }

    override func tearDown() {
        super.tearDown()
        This.instructorsUtils.deleteAll()
        This.rubricsUtils.deleteAll()
        This.assessmentsUtils.deleteAll()
        This.gradesUtils.deleteAll()
        This.studentsUtils.deleteAll()
        This.microtasksUtils.deleteAll()
        This.skillSetsUtils.deleteAll()
        
        XCTAssertTrue(This.instructorsUtils.getAll().isEmpty)
        XCTAssertTrue(This.rubricsUtils.getAll().isEmpty)
        XCTAssertTrue(This.assessmentsUtils.getAll().isEmpty)
        XCTAssertTrue(This.gradesUtils.getAll().isEmpty)
        XCTAssertTrue(This.studentsUtils.getAll().isEmpty)
        XCTAssertTrue(This.microtasksUtils.getAll().isEmpty)
        XCTAssertTrue(This.skillSetsUtils.getAll().isEmpty)
    }
    
    func testSaveItem() {
        let item = mockStudentMicrtaskGrades[0]
        XCTAssertNoThrow(try This.util.save(item: item))
        compareItems([item], This.util.getAll())
    }

    func testSaveItems() {
        let items = mockStudentMicrtaskGrades
        XCTAssertNoThrow(try This.util.save(items: items))
        compareItems(items, This.util.getAll())
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
