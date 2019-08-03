//
//  GradesUtilsTest.swift
//  AssessmentDatabaseTests
//
//  Created by Vlad Zhavoronkov  on 8/3/19.
//  Copyright © 2019 Bytepace. All rights reserved.
//

import XCTest

final class GradesUtilsTest: XCTestCase {
    typealias This = GradesUtilsTest
    static let container = getMockPersistentContainer()
    static let util = GradesUtils(with: container)
    private let mockGrades = Mocks.mockGrades
    
    override func tearDown() {
        super.tearDown()
        This.util.deleteAll()
        XCTAssertTrue(This.util.getAll().isEmpty)
    }

    func testSaveItem() {
        let item = mockGrades[0]
        XCTAssertNoThrow(try This.util.save(item: item))
        compareItems([item], This.util.getAll())
    }
    
    func testSaveItems() {
        XCTAssertNoThrow(try This.util.save(items: mockGrades))
        compareItems(mockGrades, This.util.getAll())
    }
    
    private func compareItems(_ items: [GradeFields], _ entities: [Grade]) {
        XCTAssertEqual(items.count, entities.count)
        items.forEach { item in
            guard let entity = entities.first(where: { Int($0.sid) == item.sid })
            else {
                XCTFail("can't find entity")
                return
            }
            compareItem(item, entity)
        }
    }
    
    private func compareItem(_ item: GradeFields, _ entity: Grade) {
        XCTAssertEqual(item.sid, Int(entity.sid))
        XCTAssertEqual(item.title, entity.title)
    }
}
