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
    static let skillSetsUtils = SkillSetsUtils(with: container)
    static let util: RubricsUtils = {
        let utils = RubricsUtils(with: container)
        utils.skillSetsUtils = skillSetsUtils
        return utils
    }()
    private var mocks = RubricUtilsTestMocks()
    
    override func setUp() {
        super.setUp()
        This.skillSetsUtils.rubricUtils = This.util
    }
    
    override func tearDown() {
        super.tearDown()

        This.util.deleteAll()
        XCTAssertTrue(This.util.getAll().isEmpty)
    }
    
    func testSaveItem() {
        let item = mocks.rubrics.randomElement()!
        XCTAssertNoThrow(try This.util.save(item: item))
        compareItems([item], This.util.getAll())
    }
    
    func testSaveItems() {
        var items = mocks.getAllRubrics()
        let skillSets = mocks.skillSets
        XCTAssertNoThrow(try This.util.save(items: items))
        XCTAssertNoThrow(try This.skillSetsUtils.save(items: skillSets))
        for index in items.indices {
            let itemSkillSets = skillSets.filter { $0.rubric.sid == items[index].sid }
            items[index].skillSets = itemSkillSets
        }
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
        compareSkillSets(of: item, and: entity)
    }
    
    private func compareSkillSets(of item: MockRubricFields, and entity: Rubric) {
        item.skillSets.forEach { skillSet in
            guard let entitySkillSets = (entity.skillSets?.allObjects as? [SkillSet])?.first(where: { $0.sid == Int64(skillSet.sid) })
            else {
                XCTFail("no such skillSet")
                return
            }
            XCTAssertEqual(entitySkillSets.sid, Int64(skillSet.sid))
        }
    }
}
