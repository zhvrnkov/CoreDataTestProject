//
//  SkillSetsUtilsTest.swift
//  AssessmentDatabaseTests
//
//  Created by Vlad Zhavoronkov  on 8/3/19.
//  Copyright © 2019 Bytepace. All rights reserved.
//

import XCTest

class SkillSetsUtilsTest: XCTestCase {
    typealias This = SkillSetsUtilsTest
    static let container = getMockPersistentContainer()
    static let rubricsUtils = RubricsUtils(with: container)
    static let util: SkillSetsUtils = {
        let utils = SkillSetsUtils(with: container)
        utils.rubricUtils = This.rubricsUtils
        return utils
    }()
    
    private let mockSkillSets = Mocks.mockSkillSets
    private let mockRubrics = Mocks.mockEmptyRubrics
    
    override func setUp() {
        super.setUp()
        XCTAssertNoThrow(try This.rubricsUtils.save(items: mockRubrics))
    }
    
    override func tearDown() {
        super.setUp()
        This.rubricsUtils.deleteAll()
        XCTAssertTrue(This.rubricsUtils.getAll().isEmpty)
    }
    
    func testSaveItem() {
        let item = mockSkillSets[0][0]
        XCTAssertNotNil(try This.util.save(item: item))
        compareItems([item], This.util.getAll())
    }
    
    func testSaveItems() {
        let items = mockSkillSets.reduce([]) { $0 + $1 }
        XCTAssertNoThrow(try This.util.save(items: items))
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
        XCTAssertEqual(Int64(item.rubric.sid), entity.rubric?.sid)
    }
}
