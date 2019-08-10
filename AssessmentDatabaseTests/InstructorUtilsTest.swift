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
    static let util: InstructorsUtils = {
        let util = InstructorsUtils(with: container)
        util.assessmentsUtils = This.assessmentsUtils
        util.studentsUtils = This.studentsUtils
        return util
    }()
    static let assessmentsUtils = AssessmentsUtils(container: container)
    static let studentsUtils = StudentsUtils(with: container)
    static let rubricsUtils = RubricsUtils(with: container)
    
    private var mocks = InstructorUtilsTestMocks()
    
    private lazy var mockInstructors = mocks.emptyInstructors
    private lazy var mockRubrics = mocks.rubrics
    private lazy var mockStudents = mocks.students
    private lazy var mockAssessments = mocks.assessments

    override func setUp() {
        super.setUp()
        This.assessmentsUtils.instructorsUtils = This.util
        This.assessmentsUtils.rubricsUtils = This.rubricsUtils
        This.assessmentsUtils.studentsUtils = This.studentsUtils
        
        XCTAssertNoThrow(try This.rubricsUtils.save(items: mocks.rubrics))
        XCTAssertNoThrow(try This.studentsUtils.save(items: mocks.students))
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
    
    func testSaveItemWithStudents() {
        let item = mocks.instructorsWithStudents.randomElement()!
        XCTAssertNoThrow(try This.util.save(item: item))
        compareItems([item], This.util.getAll())
    }
    
    func testSaveItemsWithStudents() {
        let items = mocks.instructorsWithStudents
        XCTAssertNoThrow(try This.util.save(items: items))
        compareItems(items, This.util.getAll())
    }
    
    func testSaveItemWithAssessments() {
        var item = mocks.instructorsWithAssessments.randomElement()!
        let assessments = mocks.assessments.filter({ $0.instructorSid == item.sid })
        XCTAssertNoThrow(try This.util.save(item: item))
        item.assessments = assessments
        XCTAssertNoThrow(try This.assessmentsUtils.save(items: assessments))
        XCTAssertNoThrow(try This.util.update(whereSid: item.sid, like: item))
        compareItems([item], This.util.getAll())
    }

    func testSaveItemsWithAssessments() {
        var items = mocks.instructorsWithAssessments
        let assessments = mocks.assessments
        XCTAssertNoThrow(try This.util.save(items: items))
        XCTAssertNoThrow(try This.assessmentsUtils.save(items: assessments))
        try? assessments.forEach { assessment in
            guard let instructorIndex = items.firstIndex(where: {
                $0.sid == assessment.instructorSid
            }) else {
                XCTFail("no such instructor")
                return
            }
            items[instructorIndex].assessments.append(assessment)
            XCTAssertNoThrow(try This.util.update(whereSid: items[instructorIndex].sid, like: items[instructorIndex]))
        }
        
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
        XCTAssertEqual(Int64(item.sid), entity.sid)
        XCTAssertEqual(item.assessments.count, entity.assessments?.count)
        XCTAssertEqual(item.students.count, entity.students?.count)
    }
}
