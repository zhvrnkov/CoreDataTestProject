//
//  RubricUtilsTest.swift
//  AssessmentDatabaseTests
//
//  Created by Vlad Zhavoronkov  on 8/1/19.
//  Copyright © 2019 Bytepace. All rights reserved.
//

import XCTest

final class RubricUtilsTest: XCTestCase {
    typealias This = RubricUtilsTest
    static let container = getMockPersistentContainer()
    static let util = RubricsUtils<MockRubricFields>(with: container)
    private var mocks = RubricUtilsTestMocks()
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()

        try? This.util.delete(whereSids: mocks.emptyRubrics.sids)
        XCTAssertTrue(This.util.getAll().isEmpty)
    }
    
    func testSaveEmptyItem() {
        let item = mocks.emptyRubrics.randomElement()!
        XCTAssertNoThrow(try This.util.save(item: item))
        compareItems([item], This.util.getAll())
    }
    
    func testSaveEmptyItems() {
        let items = mocks.emptyRubrics
        XCTAssertNoThrow(try This.util.save(items: items))
        compareItems(items, This.util.getAll())
    }
    
    private func compareItems(
        _ items: [MockRubricFields],
        _ entities: [MockRubricFields]
        ) {
        XCTAssertEqual(items.count, entities.count)
        for index in items.indices {
            let item = items[index]
            guard let entity = entities.first(where: { Int($0.sid) == item.sid })
                else {
                    XCTFail("entity is nil")
                    return
            }
            compareItem(item, entity)
        }
    }
    
    private func compareItem(_ item: MockRubricFields, _ entity: MockRubricFields) {
        XCTAssertEqual(item.sid, entity.sid)
        XCTAssertEqual(item.isActive, entity.isActive)
        XCTAssertEqual(item.lastUpdate, entity.lastUpdate)
        XCTAssertEqual(item.title, entity.title)
        XCTAssertEqual(item.weight, entity.weight)
    }
}
