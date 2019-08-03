//
//  InstructorUtilsTest.swift
//  AssessmentDatabaseTests
//
//  Created by Vlad Zhavoronkov  on 8/2/19.
//  Copyright © 2019 Bytepace. All rights reserved.
//

import XCTest

class InstructorUtilsTest: XCTestCase {
    typealias This = InstructorUtilsTest
    static let container = getMockPersistentContainer()
    static let util: InstructorsUtils = {
        let util = InstructorsUtils(with: container)
        util.assessmentsUtils = This.assessmentsUtils
        util.studentsUtils = This.studentsUtils
        return util
    }()
    static let assessmentsUtils = AssessmentsUtils(container: container)
    static let studentsUtils = StudentsUtils(with: container)
    static let rubricsUtils = RubricsUtils(with: container)
    
    private let mockInstructors = Mocks.mockInstructors
    
    private let mockRubrics = Mocks.mockEmptyRubrics
    private let mockStudents = Mocks.mockEmptyStudents

    override func setUp() {
        super.setUp()
        This.assessmentsUtils.instructorsUtils = This.util
        This.assessmentsUtils.rubricsUtils = This.rubricsUtils
        
        XCTAssertNoThrow(try This.rubricsUtils.save(items: mockRubrics))
        XCTAssertNoThrow(try This.studentsUtils.save(items: mockStudents))
    }
    
    override func tearDown() {
        super.tearDown()
        
        This.util.deleteAll()
        This.assessmentsUtils.deleteAll()
        This.studentsUtils.deleteAll()
        This.rubricsUtils.deleteAll()
        
        XCTAssertTrue(This.util.getAll().isEmpty)
        XCTAssertTrue(This.assessmentsUtils.getAll().isEmpty)
        XCTAssertTrue(This.studentsUtils.getAll().isEmpty)
        XCTAssertTrue(This.rubricsUtils.getAll().isEmpty)
    }
    
    func testSaveItem() {
        let item = mockInstructors[0]
        var clearedItem = item
        clearedItem.assessments = []
        XCTAssertNoThrow(try This.util.save(item: clearedItem))
        XCTAssertNoThrow(try This.assessmentsUtils.save(items: item.assessments))
        compareItems([item], This.util.getAll())
    }

    func testSaveItems() {
        let items = mockInstructors
        var clearedItems = mockInstructors
        for index in clearedItems.indices {
            clearedItems[index].assessments = []
        }
        XCTAssertNoThrow(try This.util.save(items: clearedItems))
        XCTAssertNoThrow(try This.assessmentsUtils.save(items: items.map({$0.assessments}).reduce([]) { $0 + $1 }))
        compareItems(items, This.util.getAll())
    }
    
    func compareItems(_ items: [InstructorFields], _ entities: [Instructor]) {
        XCTAssertEqual(items.count, entities.count)
        items.forEach { item in
            guard let entity = entities.first(where: { Int($0.sid) == item.sid }) else {
                XCTFail("can't find entity")
                return
            }
            compareItem(item, entity)
        }
    }
    
    func compareItem(_ item: InstructorFields, _ entity: Instructor) {
        XCTAssertEqual(item.assessments.count, entity.assessments?.count)
        XCTAssertEqual(item.students.count, entity.students?.count)
    }
}
