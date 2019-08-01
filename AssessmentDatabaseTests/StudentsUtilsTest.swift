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
    
    func testSaveItem() {
        let item = mockStudents[0]
        XCTAssertNoThrow(try This.util.save(item: item))
        compareItems([item], This.util.getAll())
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
