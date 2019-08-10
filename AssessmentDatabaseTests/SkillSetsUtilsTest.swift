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
    static let rubricsUtils = RubricsUtils(with: container)
    static let microtasksUtils: MicrotasksUtils = {
        let util = MicrotasksUtils(with: container)
        util.skillSetsUtils = This.util
        return util
    }()
    static let util: SkillSetsUtils = {
        let util = SkillSetsUtils(with: container)
        util.rubricUtils = This.rubricsUtils
        return util
    }()
    private var mocks = SkillSetsUtilsTestMocks()
    
    override func setUp() {
        super.setUp()
        XCTAssertNoThrow(try This.rubricsUtils.save(items: mocks.rubrics))
    }
    
    override func tearDown() {
        super.setUp()
        
        This.rubricsUtils.deleteAll()
        XCTAssertTrue(This.rubricsUtils.getAll().isEmpty)
    }
    
    func testSaveItem() {
        var item = mocks.skillSets.randomElement()!
        let itemMicrotasks = mocks.microtasks.filter { $0.skillSetSid == item.sid }
        XCTAssertNotNil(try This.util.save(item: item))
        XCTAssertNotNil(try This.microtasksUtils.save(items: itemMicrotasks))
        item.microTasks = itemMicrotasks
        XCTAssertNoThrow(try This.util.update(whereSid: item.sid, like: item))
        compareItems([item], This.util.getAll())
    }
    
    func testSaveItems() {
        var items = mocks.skillSets
        let itemMicrotasks = mocks.microtasks
        XCTAssertNoThrow(try This.util.save(items: items))
        XCTAssertNoThrow(try This.microtasksUtils.save(items: itemMicrotasks))
        try? items.indices.forEach { index in
            let microtasks = itemMicrotasks.filter { $0.skillSetSid == items[index].sid }
            items[index].microTasks = microtasks
            XCTAssertNoThrow(try This.util.update(whereSid: items[index].sid, like: items[index]))
        }
        compareItems(items, This.util.getAll())
    }
    
    private func compareItems(_ items: [SkillSetFields], _ entities: [SkillSet]) {
        XCTAssertEqual(items.count, entities.count)
        items.forEach { item in
            guard let entity = entities.first(where: { Int($0.sid) == item.sid })
            else {
                XCTFail("can'f find entity")
                return
            }
            compareItem(item, entity)
            XCTAssertTrue((entity.rubric?.skillSets?.allObjects as? [SkillSet])?.contains(where: { $0.sid == Int(item.sid)}) ?? false)
        }
    }
    
    private func compareItem(_ item: SkillSetFields, _ entity: SkillSet) {
        XCTAssertEqual(item.sid, Int(entity.sid))
        XCTAssertEqual(Int64(item.rubricSid), entity.rubric?.sid)
        compareMicrotasks(of: item, and: entity)
    }
    
    private func compareMicrotasks(of item: SkillSetFields, and entity: SkillSet) {
        item.microTasks.forEach { microtask in
            guard ((entity.microTasks?.allObjects as? [Microtask])?.first(where: { $0.sid == microtask.sid })) != nil
            else {
                // TODO: Because of Merge Conflicts
                XCTFail("no such microtask")
                return
            }
        }
    }
}
