//
//  InstructorUtilsTest.swift
//  AssessmentDatabaseTests
//
//  Created by Vlad Zhavoronkov  on 8/2/19.
//  Copyright © 2019 Bytepace. All rights reserved.
//

import XCTest

final class InstructorUtilsTest: XCTestCase {
    typealias This = InstructorUtilsTest
    static let container = getMockPersistentContainer()
    static let util = InstructorsUtils(with: container)
    private var mocks = InstructorUtilsTestMocks()
    
    private lazy var mockInstructors = mocks.emptyInstructors

    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
        
        This.util.deleteAll()
        XCTAssertTrue(This.util.getAll().isEmpty)
    }
    
    func testSaveEmptyItem() {
        let item = mocks.emptyInstructors.randomElement()!
        XCTAssertNoThrow(try This.util.save(item: item))
        compareItems([item], This.util.getAll())
    }
    
    func testSaveEmptyItems() {
        let items = mocks.emptyInstructors
        XCTAssertNoThrow(try This.util.save(items: items))
        compareItems(items, This.util.getAll())
    }
    
    func compareItems(_ items: [InstructorFields], _ entities: [Instructor]) {
        XCTAssertEqual(items.count, entities.count)
        items.forEach { item in
            guard let entity = entities.first(where: { Int($0.sid) == item.sid }) else {
                XCTFail("can't find entity")
                return
            }
            compareItem(item, entity)
        }
    }
    
    func compareItem(_ item: InstructorFields, _ entity: Instructor) {
        XCTAssertEqual(Int64(item.sid), entity.sid)
        XCTAssertEqual(item.assessments.count, entity.assessments?.count)
        XCTAssertEqual(item.students.count, entity.students?.count)
    }
}
