//
//  RubricUtilsTest.swift
//  AssessmentDatabaseTests
//
//  Created by Vlad Zhavoronkov  on 8/1/19.
//  Copyright © 2019 Bytepace. All rights reserved.
//

import XCTest

class RubricUtilsTest: XCTestCase {
    typealias This = RubricUtilsTest
    static let container = getMockPersistentContainer()
    static let skillSetsUtils = SkillSetsUtils(with: container)
    static let util: RubricsUtils = {
        let utils = RubricsUtils(with: container)
        utils.skillSetsUtils = skillSetsUtils
        return utils
    }()
    static let context = util.container.viewContext
    private var mockRubrics = Mocks.mockEmptyRubrics
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
        This.util.deleteAll()
    }
    
    func testSaveItem() {
        let item = mockRubrics[0]
        XCTAssertNoThrow(try This.util.save(item: item))
        compareItems([item], This.util.getAll())
    }
    
    func testSaveItems() {
        let items = Array(mockRubrics[1..<mockRubrics.count])
        XCTAssertNoThrow(try This.util.save(items: items))
        compareItems(items, This.util.getAll())
    }
    
    private func compareItems(
        _ items: [MockRubricFields],
        _ entities: [Rubric]
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
    
    private func compareItem(_ item: MockRubricFields, _ entity: Rubric) {
        XCTAssertEqual(item.skillSets.count, entity.skillSets?.count)
    }
}
