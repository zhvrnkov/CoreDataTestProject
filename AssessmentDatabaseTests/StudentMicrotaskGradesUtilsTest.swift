//
//  StudentMicrotaskGradesUtilsTest.swift
//  AssessmentDatabaseTests
//
//  Created by Vlad Zhavoronkov  on 8/2/19.
//  Copyright © 2019 Bytepace. All rights reserved.
//

import XCTest

final class StudentMicrotaskGradesUtilsTest: XCTestCase {
    typealias This = StudentMicrotaskGradesUtilsTest
    static let container = getMockPersistentContainer()
    
    static let instructorsUtils = InstructorsUtils(with: container)
    static let studentsUtils: StudentsUtils = {
        let util = StudentsUtils(with: container)
        util.instructorsUtils = This.instructorsUtils
        return util
    }()
    static let gradesUtils: GradesUtils = {
        let t = GradesUtils(with: container)
        t.rubricUtils = This.rubricsUtils
        return t
    }()
    
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
    
    static let assessmentsUtils: AssessmentsUtils = {
        let utils = AssessmentsUtils(container: container)
        utils.studentsUtils = StudentsUtils(with: container)
        utils.rubricsUtils = rubricsUtils
        utils.instructorsUtils = instructorsUtils
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
    
    private var mocks = StudentMicrotaskGradesUtilsTestMocks()
    
    override func setUp() {
        super.setUp()
        
        saveMicrotasks()
        XCTAssertNoThrow(try This.gradesUtils.save(items: mocks.grades))
        XCTAssertNoThrow(try This.instructorsUtils.save(items: mocks.instructors))
        XCTAssertNoThrow(try This.studentsUtils.save(items: mocks.students))
        XCTAssertNoThrow(try This.assessmentsUtils.save(items: mocks.assessments))
    }

    override func tearDown() {
        super.tearDown()
        deleteAll()
    }
    
    func testSaveItem() {
        let item = mocks.microtaskGrades.randomElement()!
        XCTAssertNoThrow(try This.util.save(item: item))
        compareItems([item], This.util.getAll())
    }

    func testSaveItems() {
        let items = mocks.microtaskGrades
        XCTAssertNoThrow(try This.util.save(items: items))
        compareItems(items, This.util.getAll())
    }
    
    func testUpdateGrade() {
        var item = mocks.microtaskGrades.randomElement()!
        let newGrade = mocks.grades.first(where: { $0.sid != item.gradeSid })!
        XCTAssertNoThrow(try This.util.save(item: item))
        item.gradeSid = newGrade.sid
        XCTAssertNoThrow(try This.util.update(whereSid: item.sid, like: item))
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
        checkRelations(of: entity, source: item)
        checkFields(of: entity, source: item)
    }
    
    private func checkRelations(of entity: StudentMicrotaskGrade, source item: StudentMicrotaskGradeFields) {
        XCTAssertNotNil(entity.assessment)
        XCTAssertNotNil(entity.grade)
        XCTAssertNotNil(entity.student)
        
        XCTAssertEqual(entity.assessment.sid, Int(item.assessmentSid))
        XCTAssertEqual(entity.grade.sid, Int(item.gradeSid))
        XCTAssertEqual(entity.student.sid, Int(item.studentSid))
    }
    
    private func checkFields(of entity: StudentMicrotaskGrade, source item: StudentMicrotaskGradeFields) {
        XCTAssertEqual(entity.sid, Int(item.sid))
        XCTAssertEqual(entity.isSynced, item.isSynced)
        XCTAssertEqual(entity.lastUpdated, item.lastUpdated)
        XCTAssertEqual(entity.passed, item.passed)
    }
    
    private func saveMicrotasks() {
        XCTAssertNoThrow(try This.rubricsUtils.save(items: mocks.rubrics))
        XCTAssertNoThrow(try This.skillSetsUtils.save(items: mocks.skillSets))
        XCTAssertNoThrow(try This.microtasksUtils.save(items: mocks.microTasks))
    }
    
    private func deleteAll() {
        XCTAssertNoThrow(try This.instructorsUtils.delete(whereSids: mocks.instructors.sids))
        XCTAssertTrue(This.instructorsUtils.getAll().isEmpty)
        XCTAssertNoThrow(try This.rubricsUtils.delete(whereSids: mocks.rubrics.sids))
        XCTAssertTrue(This.rubricsUtils.getAll().isEmpty)
        XCTAssertNoThrow(try This.assessmentsUtils.delete(whereSids: mocks.assessments.sids))
        XCTAssertTrue(This.assessmentsUtils.getAll().isEmpty)
        XCTAssertNoThrow(try This.gradesUtils.delete(whereSids: mocks.grades.sids))
        XCTAssertTrue(This.gradesUtils.getAll().isEmpty)
        XCTAssertNoThrow(try This.studentsUtils.delete(whereSids: mocks.students.sids))
        XCTAssertTrue(This.studentsUtils.getAll().isEmpty)
        XCTAssertNoThrow(try This.microtasksUtils.delete(whereSids: mocks.microTasks.sids))
        XCTAssertTrue(This.microtasksUtils.getAll().isEmpty)
        XCTAssertNoThrow(try This.skillSetsUtils.delete(whereSids: mocks.skillSets.sids))
        XCTAssertTrue(This.skillSetsUtils.getAll().isEmpty)
        XCTAssertNoThrow(try This.util.delete(whereSids: mocks.microtaskGrades.sids))
        XCTAssertTrue(This.util.getAll().isEmpty)
    }
}
