//
//  InstructorUtilsTest.swift
//  AssessmentDatabaseTests
//
//  Created by Vlad Zhavoronkov  on 8/2/19.
//  Copyright © 2019 Bytepace. All rights reserved.
//

import XCTest

final class InstructorUtilsTest: XCTestCase {
    typealias This = InstructorUtilsTest
    static let container = getMockPersistentContainer()
    static let schoolUtils = SchoolUtils<MockSchoolFields>(with: container)
    static let util: InstructorsUtils<MockInstructorFields> = {
        let t = InstructorsUtils<MockInstructorFields>(with: container)
        t.schoolObjectIDsFetch = This.schoolUtils.getObjectIds(whereSids:)
        return t
    }()
    private var mocks = InstructorUtilsTestMocks()
    
    private lazy var mockInstructors = mocks.emptyInstructors

    override func setUp() {
        super.setUp()
        XCTAssertNoThrow(try This.schoolUtils.save(items: mocks.schools))
    }
    
    override func tearDown() {
        super.tearDown()
        
        try? This.schoolUtils.delete(whereSids: mocks.schools.sids)
        try? This.util.delete(whereSids: mockInstructors.sids)
        XCTAssertTrue(This.util.getAll().isEmpty)
        XCTAssertTrue(This.schoolUtils.getAll().isEmpty)
    }
    
    func testSaveEmptyItem() {
        let item = mocks.emptyInstructors.randomElement()!
        XCTAssertNoThrow(try This.util.save(item: item))
        compareItems([item], This.util.getAll())
    }
    
    func testSaveEmptyItems() {
        let items = mocks.emptyInstructors
        XCTAssertNoThrow(try This.util.save(items: items))
        compareItems(items, This.util.getAll())
    }
    
    func testSaveItemWithScools() {
        let item = mocks.itemsWithScools.randomElement()!
        XCTAssertNoThrow(try This.util.save(item: item))
        compareItems([item], This.util.getAll())
    }
    
    func testUpdateItemSchools() {
        var item = mocks.itemsWithScools.randomElement()!
        item.schools = []
        XCTAssertNoThrow(try This.util.save(item: item))
        compareItems([item], This.util.getAll())
        
        item.schools = mocks.schools
        XCTAssertNoThrow(try This.util.update(whereSid: item.sid, like: item))
        compareItems([item], This.util.getAll())
    }
    
    func compareItems(_ items: [MockInstructorFields], _ entities: [MockInstructorFields]) {
        XCTAssertEqual(items.count, entities.count)
        items.forEach { item in
            guard let entity = entities.first(where: { Int($0.sid) == item.sid }) else {
                XCTFail("can't find entity")
                return
            }
            compareItem(item, entity)
        }
    }
    
    func compareItem(_ item: MockInstructorFields, _ entity: MockInstructorFields) {
        XCTAssertTrue(item.sid == Int(entity.sid))
        XCTAssertTrue(item.loginUsername == entity.loginUsername)
        XCTAssertTrue(item.firstName == entity.firstName)
        XCTAssertTrue(item.lastName == entity.lastName)
        XCTAssertTrue(item.avatar == entity.avatar)
        XCTAssertTrue(item.email == entity.email)
        XCTAssertTrue(item.phone == entity.phone)
        XCTAssertTrue(item.phoneStudent == entity.phoneStudent)
        XCTAssertTrue(item.address == entity.address)
        XCTAssertTrue(item.address2 == entity.address2)
        XCTAssertTrue(item.city == entity.city)
        XCTAssertTrue(item.state == entity.state)
        XCTAssertTrue(item.zip == entity.zip)
        XCTAssertTrue(item.country == entity.country)
        XCTAssertTrue(item.credentials == entity.credentials)
        XCTAssertTrue(item.depiction == entity.depiction)
        XCTAssertTrue(item.fbid == entity.fbid)
        XCTAssertTrue(item.lang == entity.lang)
        XCTAssertTrue(item.flags == entity.flags)
        XCTAssertTrue(item.nauticedStatus == entity.nauticedStatus)
        XCTAssertTrue(item.gradeColors == entity.gradeColors)
        
        XCTAssertTrue(item.schools.count == entity.schools.count)
        XCTAssertTrue(item.assessments.count == entity.assessments.count)
        XCTAssertTrue(item.students.count == entity.students.count)
    }
}
