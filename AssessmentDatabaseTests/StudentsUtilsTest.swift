//
//  StudentsUtilsTest.swift
//  AssessmentDatabaseTests
//
//  Created by Vlad Zhavoronkov  on 8/1/19.
//  Copyright © 2019 Bytepace. All rights reserved.
//

import XCTest

// TODO: Save microtaskGrades. Set them into item.grades. Update student
final class StudentsUtilsTest: XCTestCase {
    typealias This = StudentsUtilsTest
    static let container = getMockPersistentContainer()
    static let util: StudentsUtils<MockStudentFields> = {
        let util = StudentsUtils<MockStudentFields>(with: container)
        util.instructorObjectIDsFetch = This.instructorsUtils.getObjectIds(whereSids:)
        return util
    }()
    
    static let instructorsUtils: InstructorsUtils<MockInstructorFields> = {
        let t = InstructorsUtils<MockInstructorFields>(with: container)
        t.schoolObjectIDsFetch = SchoolUtils<MockSchoolFields>(with: container).getObjectIds(whereSids:)
        return t
    }()
    
    private var mocks = StudentsUtilsTestMocks()
    
    override func setUp() {
        super.setUp()
        XCTAssertNoThrow(try This.instructorsUtils.save(items: mocks.instructors))
    }
    
    override func tearDown() {
        super.tearDown()
        try? This.util.delete(whereSids: mocks.students.sids)
        XCTAssertTrue(This.util.getAll().isEmpty)
        XCTAssertNoThrow(try This.instructorsUtils.delete(whereSids: mocks.instructors.sids))
        XCTAssertTrue(This.instructorsUtils.getAll().isEmpty)
    }
    
    func testSaveItem() {
        let item = mocks.students.randomElement()!
        XCTAssertNoThrow(try This.util.save(item: item))
        compareItems([item], This.util.getAll())
    }
    
    func testSaveItems() {
        let items = mocks.students
        XCTAssertNoThrow(try This.util.save(items: items))
        compareItems(items, This.util.getAll())
    }
    
    func testUpdateItemWithInstructor() {
        var item = mocks.students.randomElement()!
        let newInstructor = mocks.instructors.first(where: { $0.sid != item.instructorSids.first })!
        XCTAssertNoThrow(try This.util.save(item: item))
        item.instructorSids.append(newInstructor.sid)
        XCTAssertNoThrow(try This.util.update(whereSid: item.sid, like: item))
        compareItems([item], This.util.getAll())
    }
    
    private func compareItems(_ items: [MockStudentFields], _ entities: [MockStudentFields]) {
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
    
    private func compareItem(_ item: MockStudentFields, _ entity: MockStudentFields) {
        XCTAssertEqual(item.sid, Int(entity.sid))
        XCTAssertEqual(item.name, entity.name)
        XCTAssertEqual(item.email, entity.email)
        XCTAssertEqual(item.logbookPass, entity.logbookPass)
        XCTAssertEqual(item.assessmentSids.count, entity.assessmentSids.count)
        XCTAssertEqual(item.instructorSids.count, entity.instructorSids.count)
        XCTAssertEqual(item.microTaskGrades.count, entity.microTaskGrades.count)
    }
}
