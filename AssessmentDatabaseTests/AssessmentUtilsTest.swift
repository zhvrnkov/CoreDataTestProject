//
//  AssessmentUtilTest.swift
//  AssessmentDatabaseTests
//
//  Created by Vlad Zhavoronkov  on 7/31/19.
//  Copyright © 2019 Bytepace. All rights reserved.
//

import Foundation
import XCTest

final class AssessmentUtilsTest: XCTestCase {
    typealias This = AssessmentUtilsTest
    static let container = getMockPersistentContainer()
    static let rubricsUtil = RubricsUtils(with: container)
    static let skillSetsUtils: SkillSetsUtils = {
        let util = SkillSetsUtils(with: container)
        util.rubricUtils = This.rubricsUtil
        return util
    }()
    static let microtasksUtils: MicrotasksUtils = {
        let util = MicrotasksUtils(with: container)
        util.skillSetsUtils = This.skillSetsUtils
        return util
    }()
    static let studentsUtil = StudentsUtils(with: container)
    static let instructorsUtil = InstructorsUtils(with: container)
    static let studentMicrotaskGradesUtils = StudentMicrotaskGradesUtils(with: container)
    static let gradesUtils = GradesUtils(with: container)
    

    static let util: AssessmentsUtils = {
        let utils = AssessmentsUtils(container: container)
        utils.studentsUtils = studentsUtil
        utils.rubricsUtils = rubricsUtil
        utils.instructorsUtils = instructorsUtil
        utils.studentMicrotaskGradesUtils = studentMicrotaskGradesUtils
        return utils
    }()
    
    private var mocks = AssessmentUtilsTestMocks()
    
    override func setUp() {
        super.setUp()
        This.studentMicrotaskGradesUtils.assessmentsUtils = This.util
        This.studentMicrotaskGradesUtils.studentsUtils = This.studentsUtil
        This.studentMicrotaskGradesUtils.gradesUtils = This.gradesUtils
        This.studentMicrotaskGradesUtils.microtasksUtils = This.microtasksUtils
        
        This.studentsUtil.instructorsUtils = This.instructorsUtil
        
        XCTAssertNoThrow(try This.instructorsUtil.save(items: mocks.instructors))
        XCTAssertNoThrow(try This.studentsUtil.save(items: mocks.students))
        XCTAssertNoThrow(try This.rubricsUtil.save(items: mocks.rubrics))
        XCTAssertNoThrow(try This.skillSetsUtils.save(items: mocks.skillSets))
        XCTAssertNoThrow(try This.microtasksUtils.save(items: mocks.microtasks))
        XCTAssertNoThrow(try This.gradesUtils.save(items: mocks.grades))
    }
   
    override func tearDown() {
        super.tearDown()
        This.instructorsUtil.deleteAll()
        This.studentsUtil.deleteAll()
        This.rubricsUtil.deleteAll()
        This.skillSetsUtils.deleteAll()
        This.microtasksUtils.deleteAll()
        This.gradesUtils.deleteAll()
        This.studentMicrotaskGradesUtils.deleteAll()
        This.util.deleteAll()
        
        XCTAssertTrue(This.instructorsUtil.getAll().isEmpty)
        XCTAssertTrue(This.studentsUtil.getAll().isEmpty)
        XCTAssertTrue(This.rubricsUtil.getAll().isEmpty)
        XCTAssertTrue(This.skillSetsUtils.getAll().isEmpty)
        XCTAssertTrue(This.microtasksUtils.getAll().isEmpty)
        XCTAssertTrue(This.gradesUtils.getAll().isEmpty)
        XCTAssertTrue(This.studentMicrotaskGradesUtils.getAll().isEmpty)
        XCTAssertTrue(This.util.getAll().isEmpty)
    }
    
    func testSaveItem() {
        var item = mocks.assessments.randomElement()!
        XCTAssertNoThrow(try This.util.save(item: item))
        let itemGrades = mocks.microtaskGrades.filter { grade in
            grade.assessment.sid == item.sid
        }
        item.studentMicrotaskGrades = itemGrades
        XCTAssertNoThrow(try This.studentMicrotaskGradesUtils.save(items: itemGrades))
        guard let entity = This.util.get(whereSid: item.sid) else {
            XCTFail("can't find entity")
            return
        }
        compareItems([item], [entity])
    }

    func testSaveItems() {
        var items = mocks.assessments
        let grades = mocks.microtaskGrades
        XCTAssertNoThrow(try This.util.save(items: items))
        grades.forEach { grade in
            let assessment = items.first(where: { $0.sid == grade.assessment.sid })!
            let index = items.firstIndex(where: { $0.sid == assessment.sid })!
            items[index].studentMicrotaskGrades.append(grade)
        }
        XCTAssertNoThrow(try This.studentMicrotaskGradesUtils.save(items: grades))
        compareItems(items, This.util.getAll())
    }
    
    func compareItems(_ items: [AssessmentFields], _ entities: [Assessment]) {
        XCTAssertEqual(items.count, entities.count)
        for index in items.indices {
            let item = items[index]
            guard let entity = entities.first(where: { Int($0.sid) == item.sid }) else {
                XCTFail("entity is nil")
                return
            }
            compareItem(item, entity)
        }
    }
    
    func compareItem(_ item: AssessmentFields, _ entity: Assessment) {
        checkFields(of: entity, source: item)
        checkRelations(of: entity, source: item)
    }
    
    func checkRelations(of entity: Assessment, source item: AssessmentFields) {
        XCTAssertNotNil(entity.instructor)
        XCTAssertNotNil(entity.rubric)
        XCTAssertNotNil(entity.studentMicrotaskGrades?.allObjects as? [StudentMicrotaskGrade])
        XCTAssertNotNil(entity.students?.allObjects as? [Student])
        XCTAssertFalse(entity.studentMicrotaskGrades?.allObjects.isEmpty ?? true)
        XCTAssertFalse(entity.students?.allObjects.isEmpty ?? true)
        XCTAssertEqual(item.studentMicrotaskGrades.count, entity.studentMicrotaskGrades?.count)
        XCTAssertEqual(item.students.count, entity.students?.count)
        XCTAssertEqual(Int64(item.instructor.sid), entity.instructor?.sid)
        XCTAssertEqual(Int64(item.rubric.sid), entity.rubric?.sid)
    }
    
    func checkFields(of entity: Assessment, source item: AssessmentFields) {
        XCTAssertEqual(item.sid, Int(entity.sid))
        XCTAssertEqual(item.schoolId, Int(entity.schoolId))
        XCTAssertEqual(item.date, entity.date)
    }
}
