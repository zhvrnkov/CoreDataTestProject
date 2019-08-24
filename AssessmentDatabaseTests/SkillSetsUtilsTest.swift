//
//  SkillSetsUtilsTest.swift
//  AssessmentDatabaseTests
//
//  Created by Vlad Zhavoronkov  on 8/3/19.
//  Copyright © 2019 Bytepace. All rights reserved.
//

import XCTest

final class SkillSetsUtilsTest: XCTestCase {
    typealias This = SkillSetsUtilsTest
    static let container = getMockPersistentContainer()
    static let rubricsUtils = RubricsUtils<MockRubricFields>(with: container)
    static let util: SkillSetsUtils<MockSkillSets> = {
        let util = SkillSetsUtils<MockSkillSets>(with: container)
        util.rubricObjectIDFetch = This.rubricsUtils.getObjectId(whereSid:)
        return util
    }()
    private var mocks = SkillSetsUtilsTestMocks()
    
    override func setUp() {
        super.setUp()
        XCTAssertNoThrow(try This.rubricsUtils.save(items: mocks.rubrics))
    }
    
    override func tearDown() {
        super.setUp()
        
        XCTAssertNoThrow(try This.rubricsUtils.delete(whereSids: mocks.rubrics.sids))
        XCTAssertTrue(This.rubricsUtils.getAll().isEmpty)
    }
    
    func testSaveItem() {
        let item = mocks.skillSets.randomElement()!
        XCTAssertNoThrow(try This.util.save(item: item))
        compareItems([item], This.util.getAll())
    }
    
    func testSaveItems() {
        let items = mocks.skillSets
        XCTAssertNoThrow(try This.util.save(items: items))
        compareItems(items, This.util.getAll())
    }
    
    func testSaveIncompleteItemAndThenSaveComplete() {
        XCTAssertNoThrow(try This.rubricsUtils.delete(whereSids: mocks.rubrics.sids))
        let item = mocks.skillSets.randomElement()!
        XCTAssertThrowsError(try This.util.save(item: item))
        XCTAssertNoThrow(try This.rubricsUtils.save(items: mocks.rubrics))
        XCTAssertNoThrow(try This.util.save(item: item))
        compareItems([item], This.util.getAll())
    }
    
    func testSaveIncompleteItemsAndSaveComplete() {
        XCTAssertNoThrow(try This.rubricsUtils.delete(whereSids: mocks.rubrics.sids))
        let item = mocks.skillSets.randomElement()!
        XCTAssertThrowsError(try This.util.save(items: [item]))
        XCTAssertNoThrow(try This.rubricsUtils.save(items: mocks.rubrics))
        XCTAssertNoThrow(try This.util.save(items: [item]))
        compareItems([item], This.util.getAll())
    }
    
    private func compareItems(_ items: [MockSkillSets], _ entities: [MockSkillSets]) {
        XCTAssertEqual(items.count, entities.count)
        items.forEach { item in
            guard let entity = entities.first(where: { Int($0.sid) == item.sid })
            else {
                XCTFail("can'f find entity")
                return
            }
            compareItem(item, entity)
            guard let rubric = This.rubricsUtils.get(whereSid: entity.rubricSid) else {
                XCTFail()
                return
            }
            XCTAssertTrue(rubric.skillSets.contains(where: { $0.sid == item.sid }))
        }
    }
    
    private func compareItem(_ item: MockSkillSets, _ entity: MockSkillSets) {
        XCTAssertEqual(item.sid, entity.sid)
        XCTAssertEqual(item.rubricSid, entity.rubricSid)
        XCTAssertEqual(item.title, entity.title)
        XCTAssertEqual(item.weight, entity.weight)
        XCTAssertEqual(item.isActive, entity.isActive)
    }
}
