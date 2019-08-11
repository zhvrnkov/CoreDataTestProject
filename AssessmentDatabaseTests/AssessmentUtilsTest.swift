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
    static let studentsUtil = StudentsUtils(with: container)
    static let instructorsUtil = InstructorsUtils(with: container)
    
    static let util: AssessmentsUtils = {
        let utils = AssessmentsUtils(container: container)
        utils.studentsUtils = studentsUtil
        utils.rubricsUtils = rubricsUtil
        utils.instructorsUtils = instructorsUtil
        return utils
    }()
    
    private var mocks = AssessmentUtilsTestMocks()
    
    override func setUp() {
        super.setUp()
        
        This.studentsUtil.instructorsUtils = This.instructorsUtil
        
        XCTAssertNoThrow(try This.instructorsUtil.save(items: mocks.instructors))
        XCTAssertNoThrow(try This.studentsUtil.save(items: mocks.students))
        XCTAssertNoThrow(try This.rubricsUtil.save(items: mocks.rubrics))
    }
   
    override func tearDown() {
        super.tearDown()
        deleteAll()
        checkAll()
    }
    
    func testSaveItem() {
        let item = mocks.assessments.randomElement()!
        XCTAssertNoThrow(try This.util.save(item: item))
        compareItems([item], This.util.getAll())
    }
    
    func testSaveItems() {
        let items = mocks.assessments
        XCTAssertNoThrow(try This.util.save(items: items))
        compareItems(items, This.util.getAll())
    }
    
    func testUpdateItem() {
        XCTFail()
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
        XCTAssertEqual(entity.studentMicrotaskGrades?.allObjects.count, item.studentMicrotaskGrades.count)
        XCTAssertEqual(entity.students?.allObjects.count, item.students.count)
        XCTAssertEqual(item.studentMicrotaskGrades.count, entity.studentMicrotaskGrades?.count)
        XCTAssertEqual(item.students.count, entity.students?.count)
        XCTAssertEqual(Int64(item.instructorSid), entity.instructor?.sid)
        XCTAssertEqual(Int64(item.rubric.sid), entity.rubric?.sid)
    }
    
    func checkFields(of entity: Assessment, source item: AssessmentFields) {
        XCTAssertEqual(item.sid, Int(entity.sid))
        XCTAssertEqual(item.schoolId, Int(entity.schoolId))
        XCTAssertEqual(item.date, entity.date)
    }
    
    private func deleteAll() {
        This.instructorsUtil.deleteAll()
        This.studentsUtil.deleteAll()
        This.rubricsUtil.deleteAll()
        This.util.deleteAll()
    }
    
    private func checkAll() {
        XCTAssertTrue(This.instructorsUtil.getAll().isEmpty)
        XCTAssertTrue(This.studentsUtil.getAll().isEmpty)
        XCTAssertTrue(This.rubricsUtil.getAll().isEmpty)
        XCTAssertTrue(This.util.getAll().isEmpty)
    }
}
