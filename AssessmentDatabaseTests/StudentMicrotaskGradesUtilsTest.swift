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
    
    static let instructorsUtils: InstructorsUtils<MockInstructorFields> = {
        let t = InstructorsUtils<MockInstructorFields>(with: container)
        t.schoolObjectIDsFetch = SchoolUtils<MockSchoolFields>(with: container).getObjectIds(whereSids:)
        return t
    }()
    static let studentsUtils: StudentsUtils<MockStudentFields> = {
        let util = StudentsUtils<MockStudentFields>(with: container)
        util.instructorObjectIDsFetch = This.instructorsUtils.getObjectIds(whereSids:)
        return util
    }()
    static let gradesUtils: GradesUtils<MockGradeFields> = {
        let t = GradesUtils<MockGradeFields>(with: container)
        t.rubricObjectIDFetch = This.rubricsUtils.getObjectId(whereSid:)
        return t
    }()
    
    static let rubricsUtils = RubricsUtils<MockRubricFields>(with: container)
    static let skillSetsUtils: SkillSetsUtils<MockSkillSets> = {
        let util = SkillSetsUtils<MockSkillSets>(with: container)
        util.rubricObjectIDFetch = This.rubricsUtils.getObjectId(whereSid:)
        return util
    }()
    static let microtasksUtils: MicrotasksUtils<MockMicrotaskFields> = {
        let util = MicrotasksUtils<MockMicrotaskFields>(with: container)
        util.skillSetObjectIDFetch = This.skillSetsUtils.getObjectId(whereSid:)
        return util
    }()
    
    static let assessmentsUtils: AssessmentsUtils<MockAssessmentFields> = {
        let utils = AssessmentsUtils<MockAssessmentFields>(with: container)
        utils.studentObjectIDsFetch = studentsUtils.getObjectIds(whereSids:)
        utils.rubricObjectIDFetch = rubricsUtils.getObjectId(whereSid:)
        utils.instructorObjectIDFetch = instructorsUtils.getObjectId(whereSid:)
        return utils
    }()
    
    static let util: StudentMicrotaskGradesUtils<MockStudentMicrotaskGrade> = {
        let utils = StudentMicrotaskGradesUtils<MockStudentMicrotaskGrade>(with: container)
        utils.assessmentObjectIDFetch = This.assessmentsUtils.getObjectId(whereSid:)
        utils.gradeObjectIDFetch = This.gradesUtils.getObjectId(whereSid:)
        utils.studentObjectIDFetch = This.studentsUtils.getObjectId(whereSid:)
        utils.microtaskObjectIDFetch = This.microtasksUtils.getObjectId(whereSid:)
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
    
    private func compareItems(_ items: [StudentMicrotaskGradeFields], _ entities: [StudentMicrotaskGradeFields]) {
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
    
    private func compareItem(_ item: StudentMicrotaskGradeFields, _ entity: StudentMicrotaskGradeFields) {
        checkRelations(of: entity, source: item)
        checkFields(of: entity, source: item)
    }
    
    private func checkRelations(of entity: StudentMicrotaskGradeFields, source item: StudentMicrotaskGradeFields) {
        XCTAssertNotEqual(entity.assessmentSid, Int(badSid))
        XCTAssertNotEqual(entity.gradeSid, Int(badSid))
        XCTAssertNotEqual(entity.studentSid, Int(badSid))
        
        XCTAssertEqual(entity.assessmentSid, item.assessmentSid)
        XCTAssertEqual(entity.gradeSid, item.gradeSid)
        XCTAssertEqual(entity.studentSid, item.studentSid)
    }
    
    private func checkFields(of entity: StudentMicrotaskGradeFields, source item: StudentMicrotaskGradeFields) {
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
        XCTAssertTrue(This.assessmentsUtils.getAll().isEmpty)
        XCTAssertTrue(This.gradesUtils.getAll().isEmpty)
        XCTAssertTrue(This.studentsUtils.getAll().isEmpty)
        XCTAssertTrue(This.microtasksUtils.getAll().isEmpty)
        XCTAssertTrue(This.skillSetsUtils.getAll().isEmpty)
        XCTAssertTrue(This.util.getAll().isEmpty)
    }
}
