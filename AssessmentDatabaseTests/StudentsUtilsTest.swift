//
//  StudentsUtilsTest.swift
//  AssessmentDatabaseTests
//
//  Created by Vlad Zhavoronkov  on 8/1/19.
//  Copyright © 2019 Bytepace. All rights reserved.
//

import XCTest

class StudentsUtilsTest: XCTestCase {
    typealias This = StudentsUtilsTest
    static let util = StudentsUtils(with: getMockPersistentContainer())
    static let context = util.container.viewContext
    private let mockStudents = Mocks.mockStudents
    
    override func tearDown() {
        super.tearDown()
        This.util.deleteAll()
        XCTAssertTrue(This.util.getAll().isEmpty)
    }
    
    func testSaveItem() {
        let item = mockStudents[0]
        XCTAssertNoThrow(try This.util.save(item: item))
        compareItems([item], This.util.getAll())
    }
    
    func testSaveItems() {
        let items = Array(mockStudents[1..<mockStudents.count])
        XCTAssertNoThrow(try This.util.save(items: items))
        compareItems(items, This.util.getAll())
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
        
    }
}
