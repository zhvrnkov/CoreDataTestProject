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
    static let util: MicrotasksUtils<MockMicrotaskFields> = {
        let util = MicrotasksUtils<MockMicrotaskFields>(with: container)
        util.skillSetObjectIDFetch = This.skillSetsUtils.getObjectId(whereSid:)
        return util
    }()
    static let skillSetsUtils: SkillSetsUtils<MockSkillSets> = {
        let util = SkillSetsUtils<MockSkillSets>(with: container)
        util.rubricObjectIDFetch = This.rubricUtils.getObjectId(whereSid:)
        return util
    }()
    static let rubricUtils = RubricsUtils<MockRubricFields>(with: container)
    private var mocks = MicrotaskUtilsTestMocks()
    
    override func setUp() {
        super.setUp()
        XCTAssertNoThrow(try This.rubricUtils.save(items: mocks.rubrics))
        XCTAssertNoThrow(try This.skillSetsUtils.save(items: mocks.skillSets))
    }

    override func tearDown() {
        super.tearDown()
        
        XCTAssertNoThrow(try This.rubricUtils.delete(whereSids: mocks.rubrics.sids))
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

    private func compareItems(_ items: [MockMicrotaskFields], _ entities: [MockMicrotaskFields]) {
        XCTAssertEqual(items.count, entities.count)
        items.forEach { item in
            guard let entity = entities.first(where: { Int($0.sid) == item.sid })
            else {
                XCTFail("can't find entity")
                return
            }
            compareItem(item, entity)
            guard let skillSet = This.skillSetsUtils.get(whereSid: entity.skillSetSid) else {
                XCTFail()
                return
            }
            XCTAssertTrue(skillSet.microTasks.contains(where: { $0.sid == item.sid }))
        }
    }
    
    private func compareItem(_ item: MicrotaskFields, _ entity: MockMicrotaskFields) {
        XCTAssertEqual(item.sid, Int(entity.sid))
        XCTAssertEqual(item.skillSetSid, entity.skillSetSid)
        XCTAssertEqual(item.isActive, entity.isActive)
        XCTAssertEqual(item.critical, entity.critical)
        XCTAssertEqual(item.depiction, entity.depiction)
        XCTAssertEqual(item.title, entity.title)
        XCTAssertEqual(item.weight , entity.weight)
    }
}
