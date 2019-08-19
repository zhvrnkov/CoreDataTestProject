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
    
    func testAddStudentsToAssessment() {
        var item = mocks.assessments.randomElement()!
        let newStudents = mocks.students.filter { student in !item.studentSids.contains(student.sid) }
        XCTAssertNoThrow(try This.util.save(item: item))
        item.studentSids += newStudents.sids
        XCTAssertNoThrow(try This.util.update(whereSid: item.sid, like: item))
        compareItems([item], This.util.getAll())
    }
    
    func testRemoveStudentsFromAssessment() {
        var item = mocks.assessments.randomElement()!
        XCTAssertNoThrow(try This.util.save(item: item))
        item.studentSids = []
        XCTAssertNoThrow(try This.util.update(whereSid: item.sid, like: item))
        compareItems([item], This.util.getAll())
    }
    
    func testChangeRubricOfAssessment() {
        var item = mocks.assessments.randomElement()!
        XCTAssertNoThrow(try This.util.save(item: item))
        let newRubric = mocks.rubrics.first(where: { $0.sid != item.rubricSid })!
        item.rubricSid = newRubric.sid
        XCTAssertNoThrow(try This.util.update(whereSid: item.sid, like: item))
        compareItems([item], This.util.getAll())
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
        XCTAssertNotNil(entity.studentMicrotaskGrades.allObjects as? [StudentMicrotaskGrade])
        XCTAssertNotNil(entity.students.allObjects as? [Student])
        XCTAssertEqual(entity.studentMicrotaskGrades.allObjects.count, item.studentMicrotaskGrades.count)
        XCTAssertEqual(item.studentMicrotaskGrades.count, entity.studentMicrotaskGrades.count)
        XCTAssertEqual(item.studentSids.count, entity.students.count)
        XCTAssertEqual(Int(item.instructorSid), entity.instructor.sid)
        XCTAssertEqual(Int(item.rubricSid), entity.rubric.sid)
    }
    
    func checkFields(of entity: Assessment, source item: AssessmentFields) {
        XCTAssertEqual(item.sid, entity.sid)
        XCTAssertEqual(item.schoolId, entity.schoolId)
        XCTAssertEqual(item.date.timeIntervalSince1970, entity.date.timeIntervalSince1970)
    }
    
    private func deleteAll() {
        XCTAssertNoThrow(try This.instructorsUtil.delete(whereSids: mocks.instructors.sids))
        XCTAssertTrue(This.instructorsUtil.getAll().isEmpty)
        XCTAssertNoThrow(try This.studentsUtil.delete(whereSids: mocks.students.sids))
        XCTAssertTrue(This.studentsUtil.getAll().isEmpty)
        XCTAssertNoThrow(try This.rubricsUtil.delete(whereSids: mocks.rubrics.sids))
        XCTAssertTrue(This.rubricsUtil.getAll().isEmpty)
        XCTAssertNoThrow(try This.util.delete(whereSids: mocks.assessments.sids))
        XCTAssertTrue(This.util.getAll().isEmpty)
    }
}
