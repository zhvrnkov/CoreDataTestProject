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
    static let rubricsUtil = RubricsUtils<MockRubricFields>(with: container)
    static let studentsUtil = StudentsUtils<MockStudentFields>(with: container)
    static let instructorsUtil: InstructorsUtils<MockInstructorFields> = {
        let t = InstructorsUtils<MockInstructorFields>(with: container)
        t.schoolObjectIDsFetch = SchoolUtils<MockSchoolFields>(with: container).getObjectIds(whereSids:)
        return t
    }()
    
    static let util: AssessmentsUtils<MockAssessmentFields> = {
        let utils = AssessmentsUtils<MockAssessmentFields>(with: container)
        utils.studentObjectIDsFetch = studentsUtil.getObjectIds(whereSids:)
        utils.rubricObjectIDFetch = rubricsUtil.getObjectId(whereSid:)
        utils.instructorObjectIDFetch = instructorsUtil.getObjectId(whereSid:)
        return utils
    }()
    
    private var mocks = AssessmentUtilsTestMocks()
    
    override func setUp() {
        super.setUp()
        
        This.studentsUtil.instructorObjectIDsFetch = This.instructorsUtil.getObjectIds(whereSids: )
        
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
        item.students += newStudents
        XCTAssertNoThrow(try This.util.update(whereSid: item.sid, like: item))
        compareItems([item], This.util.getAll())
    }
    
    func testRemoveStudentsFromAssessment() {
        var item = mocks.assessments.randomElement()!
        XCTAssertNoThrow(try This.util.save(item: item))
        item.students = []
        XCTAssertNoThrow(try This.util.update(whereSid: item.sid, like: item))
        compareItems([item], This.util.getAll())
    }
    
    func testUpdateAssessmentTime() {
        var item = mocks.assessments.randomElement()!
        XCTAssertNoThrow(try This.util.save(item: item))
        item.date = Date()
        XCTAssertNoThrow(try This.util.update(whereSid: item.sid, like: item))
        compareItems([item], This.util.getAll())
    }
    
    func testChangeRubricOfAssessment() {
        var item = mocks.assessments.randomElement()!
        XCTAssertNoThrow(try This.util.save(item: item))
        let newRubric = mocks.rubrics.first(where: { $0.sid != item.rubricSid })!
        item.rubric = newRubric
        XCTAssertNoThrow(try This.util.update(whereSid: item.sid, like: item))
        compareItems([item], This.util.getAll())
    }
    
    func compareItems(_ items: [MockAssessmentFields], _ entities: [MockAssessmentFields]) {
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
    
    func compareItem(_ item: MockAssessmentFields, _ entity: MockAssessmentFields) {
        checkFields(of: entity, source: item)
        checkRelations(of: entity, source: item)
    }
    
    func checkRelations(of entity: MockAssessmentFields, source item: MockAssessmentFields) {
        XCTAssertNotEqual(entity.instructorSid, Int(badSid))
        XCTAssertNotNil(entity.rubric)
        XCTAssertEqual(entity.microTaskGradeSids.count, item.microTaskGradeSids.count)
        XCTAssertEqual(item.students.count, entity.students.count)
        XCTAssertEqual(Int64(item.instructorSid), Int64(entity.instructorSid))
        XCTAssertEqual(Int64(item.rubricSid), Int64(entity.rubric.sid))
    }
    
    func checkFields(of entity: MockAssessmentFields, source item: MockAssessmentFields) {
        XCTAssertEqual(item.sid, Int(entity.sid))
        XCTAssertEqual(item.schoolId, Int(entity.schoolId))
        XCTAssertEqual(item.date.timeIntervalSince1970, entity.date.timeIntervalSince1970)
    }
    
    private func deleteAll() {
        XCTAssertNoThrow(try This.instructorsUtil.delete(whereSids: mocks.instructors.sids))
        XCTAssertTrue(This.instructorsUtil.getAll().isEmpty)
        XCTAssertTrue(This.studentsUtil.getAll().isEmpty)
        XCTAssertNoThrow(try This.rubricsUtil.delete(whereSids: mocks.rubrics.sids))
        XCTAssertTrue(This.rubricsUtil.getAll().isEmpty)
        XCTAssertTrue(This.util.getAll().isEmpty)
    }
}
