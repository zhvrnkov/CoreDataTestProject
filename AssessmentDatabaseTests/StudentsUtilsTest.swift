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
    static let util: StudentsUtils = {
        let util = StudentsUtils(with: container)
        util.instructorsUtils = This.instructorsUtils
        return util
    }()
    
    static let instructorsUtils = InstructorsUtils(with: container)
    
    private var mocks = StudentsUtilsTestMocks()
    
    override func setUp() {
        super.setUp()
        XCTAssertNoThrow(try This.instructorsUtils.save(items: mocks.instructors))
    }
    
    override func tearDown() {
        super.tearDown()
        This.util.deleteAll()
        This.instructorsUtils.deleteAll()
        
        XCTAssertTrue(This.util.getAll().isEmpty)
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
        XCTFail("nothing is here")
    }
    
    private func compareItems(_ items: [MockStudentFields], _ entities: [Student]) {
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
    
    private func compareItem(_ item: MockStudentFields, _ entity: Student) {
        XCTAssertEqual(item.assessmentSids.count, entity.assessments?.count)
        XCTAssertEqual(item.instructorSids.count, entity.instructors?.count)
        XCTAssertEqual(item.microTaskGradesSids.count, entity.microTaskGrades?.count)
    }
}
