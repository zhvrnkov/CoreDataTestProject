//
//  MicrotaskUtilsTest.swift
//  AssessmentDatabaseTests
//
//  Created by Vlad Zhavoronkov  on 8/2/19.
//  Copyright © 2019 Bytepace. All rights reserved.
//

import XCTest

class MicrotaskUtilsTest: XCTestCase {
    typealias This = MicrotaskUtilsTest
    static let container = getMockPersistentContainer()
    static let util: MicrotasksUtils = {
        let util = MicrotasksUtils(with: container)
        util.skillSetsUtils = This.skillSetsUtils
        return util
    }()
    static let skillSetsUtils: SkillSetsUtils = {
        let util = SkillSetsUtils(with: container)
        util.rubricUtils = This.rubricUtils
        return util
    }()
    static let rubricUtils: RubricsUtils = {
        let util = RubricsUtils(with: container)
        return util
    }()
    private let mockMicrotasks = Mocks.mockMicrotasks
    
    override func setUp() {
        super.setUp()
        XCTAssertNoThrow(try This.rubricUtils.save(items: Mocks.mockEmptyRubrics))
        XCTAssertNoThrow(try This.skillSetsUtils.save(items:
            Mocks.mockSkillSets.reduce([]) { $0 + $1 }))
    }

    override func tearDown() {
        super.tearDown()
        This.rubricUtils.deleteAll()
        This.skillSetsUtils.deleteAll()
        XCTAssertTrue(This.rubricUtils.getAll().isEmpty)
        XCTAssertTrue(This.skillSetsUtils.getAll().isEmpty)
    }

    func testSaveItem() {
        let item = mockMicrotasks[0][0]
        XCTAssertNoThrow(try This.util.save(item: item))
        compareItems([item], This.util.getAll())
    }
    
    
    func testSaveItems() {
        let items = Mocks.mockMicrotasks.reduce([]) { $0 + $1 }
        XCTAssertNoThrow(try This.util.save(items: items))
        compareItems(items, This.util.getAll())
    }

    private func compareItems(_ items: [MicrotaskFields], _ entities: [Microtask]) {
        XCTAssertEqual(items.count, entities.count)
        items.forEach { item in
            guard let entity = entities.first(where: { Int($0.sid) == item.sid })
            else {
                XCTFail("can't find entity")
                return
            }
            compareItem(item, entity)
            XCTAssertTrue((entity.skillSet?.microTasks?.allObjects as? [Microtask])?.contains(where: { $0.sid == Int(item.sid) }) ?? false)
        }
    }
    
    private func compareItem(_ item: MicrotaskFields, _ entity: Microtask) {
        XCTAssertEqual(item.sid, Int(entity.sid))
        XCTAssertEqual(Int64(item.skillSet.sid), entity.skillSet?.sid)
    }
}
