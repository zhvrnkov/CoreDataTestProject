//
//  InstructorUtilsTest.swift
//  AssessmentDatabaseTests
//
//  Created by Vlad Zhavoronkov  on 8/2/19.
//  Copyright © 2019 Bytepace. All rights reserved.
//

import XCTest

class InstructorUtilsTest: XCTestCase {
    typealias This = InstructorUtilsTest
    static let container = getMockPersistentContainer()
    static let util = InstructorsUtils(with: container)

    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
        This.util.deleteAll()
        XCTAssertEqual(This.util.getAll().count, 0)
    }
    
    func testSaveItem() {
        let item = mockInstructors[0]
        XCTAssertNoThrow(try This.util.save(item: item))
        guard let entity = This.util.get(whereSid: item.sid) else {
            XCTFail("can't find entity")
            return
        }
        compareItems([item], [entity])
    }
    
    func testSaveItems() {
        XCTAssertNoThrow(try This.util.save(items: mockInstructors))
        compareItems(mockInstructors, This.util.getAll())
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
        
    }
}
