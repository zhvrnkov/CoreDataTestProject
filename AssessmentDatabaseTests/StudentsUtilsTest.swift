//
//  StudentsUtilsTest.swift
//  AssessmentDatabaseTests
//
//  Created by Vlad Zhavoronkov  on 8/1/19.
//  Copyright © 2019 Bytepace. All rights reserved.
//

import XCTest

// TODO: Save microtaskGrades. Set them into item.grades. Update student
final class StudentsUtilsTest: XCTestCase {
    typealias This = StudentsUtilsTest
    static let container = getMockPersistentContainer()
    static let util: StudentsUtils = {
        let util = StudentsUtils(with: container)
        util.assessmentsUtils = This.assessmentsUtils
        util.instructorsUtils = This.instructorsUtils
        return util
    }()
    
    static let assessmentsUtils = AssessmentsUtils(container: container)
    static let instructorsUtils = InstructorsUtils(with: container)
    static let rubricsUtils = RubricsUtils(with: container)
    
    private var mocks = StudentsUtilsTestMocks()
    
    override func setUp() {
        super.setUp()
        This.assessmentsUtils.rubricsUtils = This.rubricsUtils
        This.assessmentsUtils.instructorsUtils = This.instructorsUtils
        
        XCTAssertNoThrow(try This.instructorsUtils.save(items: mocks.instructors))
        XCTAssertNoThrow(try This.rubricsUtils.save(items: mocks.rubrics))
        XCTAssertNoThrow(try This.assessmentsUtils.save(items: mocks.assessments))
    }
    
    override func tearDown() {
        super.tearDown()
        This.util.deleteAll()
        This.instructorsUtils.deleteAll()
        This.rubricsUtils.deleteAll()
        This.assessmentsUtils.deleteAll()
        
        XCTAssertTrue(This.util.getAll().isEmpty)
        XCTAssertTrue(This.instructorsUtils.getAll().isEmpty)
        XCTAssertTrue(This.rubricsUtils.getAll().isEmpty)
        XCTAssertTrue(This.assessmentsUtils.getAll().isEmpty)
    }
    
    func testSaveEmptyItem() {
        let item = mocks.emptyStudents.randomElement()!
        XCTAssertNoThrow(try This.util.save(item: item))
        compareItems([item], This.util.getAll())
    }
    
    func testSaveEmptyItems() {
        let items = mocks.emptyStudents
        XCTAssertNoThrow(try This.util.save(items: items))
        compareItems(items, This.util.getAll())
    }
    
    func testSaveItemWithRelations() {
        let item = mocks.studentsWithRelations.randomElement()!
        XCTAssertNoThrow(try This.util.save(item: item))
        compareItems([item], This.util.getAll())
    }
    
    func testSaveItemsWithRelations() {
        let items = mocks.studentsWithRelations
        XCTAssertNoThrow(try This.util.save(items: items))
        compareItems(items, This.util.getAll())
    }
    
    func testUpdateItemWithRelations() {
        var item = mocks.studentsWithRelations.randomElement()!
        let itemAssessments = item.assessmentSids
        let itemInstructors = item.instructorSids
        let itemGrades = item.microTaskGradesSids
        item.assessmentSids = []
        item.instructorSids = []
        item.microTaskGradesSids = []
        XCTAssertNoThrow(try This.util.save(item: item))
        item.assessmentSids = itemAssessments
        item.instructorSids = itemInstructors
        item.microTaskGradesSids = itemGrades
        XCTAssertNoThrow(try This.util.update(whereSid: item.sid, like: item))
        compareItems([item], This.util.getAll())
    }
    
    func testUpdateItemsWithRelations() {
        var items = mocks.studentsWithRelations
        try? items.forEach {
            var item = $0
            let itemAssessments = item.assessmentSids
            let itemInstructors = item.instructorSids
            let itemGrades = item.microTaskGradesSids
            item.assessmentSids = []
            item.instructorSids = []
            item.microTaskGradesSids = []
            XCTAssertNoThrow(try This.util.save(item: item))
            item.assessmentSids = itemAssessments
            item.instructorSids = itemInstructors
            item.microTaskGradesSids = itemGrades
            XCTAssertNoThrow(try This.util.update(whereSid: item.sid, like: item))
        }
        compareItems(items, This.util.getAll())
    }
    
    private func compareItems(_ items: [MockStudentFields], _ entities: [Student]) {
        XCTAssertEqual(items.count, entities.count)
        for index in items.indices {
            let item = items[index]
            guard let entity = entities.first(where: { Int($0.sid) == item.sid }) else {
                XCTFail("entity is nil")
                return
            }
            compareItem(item, entity)
        }
    }
    
    private func compareItem(_ item: MockStudentFields, _ entity: Student) {
        XCTAssertEqual(item.assessmentSids.count, entity.assessments?.count)
        XCTAssertEqual(item.instructorSids.count, entity.instructors?.count)
        XCTAssertEqual(item.microTaskGradesSids.count, entity.microTaskGrades?.count)
    }
}
