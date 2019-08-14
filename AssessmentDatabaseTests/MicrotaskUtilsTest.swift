//
//  MicrotaskUtilsTest.swift
//  AssessmentDatabaseTests
//
//  Created by Vlad Zhavoronkov  on 8/2/19.
//  Copyright © 2019 Bytepace. All rights reserved.
//

import XCTest

final class MicrotaskUtilsTest: XCTestCase {
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
    private var mocks = MicrotaskUtilsTestMocks()
    
    override func setUp() {
        super.setUp()
        XCTAssertNoThrow(try This.rubricUtils.save(items: mocks.rubrics))
        XCTAssertNoThrow(try This.skillSetsUtils.save(items: mocks.skillSets))
    }

    override func tearDown() {
        super.tearDown()
        
        This.rubricUtils.deleteAll()
        This.skillSetsUtils.deleteAll()
        
        XCTAssertTrue(This.rubricUtils.getAll().isEmpty)
        XCTAssertTrue(This.skillSetsUtils.getAll().isEmpty)
    }

    func testSaveItem() {
        let item = mocks.microtasks.randomElement()!
        XCTAssertNoThrow(try This.util.save(item: item))
        compareItems([item], This.util.getAll())
    }
    
    
    func testSaveItems() {
        let items = mocks.microtasks
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
            XCTAssertTrue((entity.skillSet.microTasks.allObjects as? [Microtask])?.contains(where: { $0.sid == Int(item.sid) }) ?? false)
        }
    }
    
    private func compareItem(_ item: MicrotaskFields, _ entity: Microtask) {
        XCTAssertEqual(item.sid, entity.sid)
        XCTAssertEqual(item.skillSetSid, entity.skillSet.sid)
        XCTAssertEqual(item.isActive, entity.isActive)
        XCTAssertEqual(item.critical, entity.critical)
        XCTAssertEqual(item.depiction, entity.depiction)
        XCTAssertEqual(item.title, entity.title)
        XCTAssertEqual(item.weight , entity.weight )
    }
}
