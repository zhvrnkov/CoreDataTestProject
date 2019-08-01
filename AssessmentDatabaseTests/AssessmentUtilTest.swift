//
//  AssessmentUtilTest.swift
//  AssessmentDatabaseTests
//
//  Created by Vlad Zhavoronkov  on 7/31/19.
//  Copyright © 2019 Bytepace. All rights reserved.
//

import Foundation
import XCTest

final class AssessmentUtilTest: XCTestCase {
    typealias This = AssessmentUtilTest
    static let container = getMockPersistentContainer()
    static let util = AssessmentsUtils(with: container)
    static let rubricUtil = RubricsUtils(with: container)
    static let context = util.container.viewContext
    
    override func setUp() {
        super.setUp()
        XCTAssertNoThrow(try This.rubricUtil.save(items: mockRubrics))
    }
    
    override func tearDown() {
        super.tearDown()
        This.rubricUtil.delete(whereSids:
            mockRubrics.map { $0.sid })
    }
    
    func testSaveItem() {
        let item = mockAssessments[0]
        XCTAssertNoThrow(try This.util.save(item: item))
        compareItems([item], This.util.getAll())
    }
    
    func testSaveItems() {
        let items = Array(mockAssessments[1..<mockAssessments.count])
        XCTAssertNoThrow(try This.util.save(items: items))
        compareItems(mockAssessments, This.util.getAll())
    }
    
    func compareItems(_ items: [AssessmentFields], _ entities: [Assessment]) {
        XCTAssertEqual(items.count, entities.count)
        for index in items.indices {
            let item = items[index]
            guard let entity = entities.first(where: { Int($0.sid) == item.sid }) else {
                XCTFail("entity is nil")
                return
            }
            XCTAssertNotNil(entity.rubric)
            compareItem(item, entity)
        }
    }
    
    func compareItem(_ item: AssessmentFields, _ entity: Assessment) {
        XCTAssertEqual(item.sid, Int(entity.sid))
        XCTAssertEqual(item.schoolId, Int(entity.schoolId))
        XCTAssertEqual(item.date, entity.date)
        guard let students = entity.students?.allObjects as? [Student],
            let rubric = entity.rubric
        else {
            XCTFail()
            return
        }
        compareStudents(item.students, students)
        comapareRubric(item.rubric, rubric)
    }
    
    func compareStudents(_ items: [StudentFields], _ entities: [Student]) {
        XCTAssertEqual(items.count, entities.count)
        for index in items.indices {
            compareStudent(items[index], entities[index])
        }
    }
    
    func compareStudent(_ item: StudentFields, _ entity: Student) {
        XCTFail()
    }
    
    func comapareRubric(_ item: RubricFields, _ entity: Rubric) {
        XCTFail()
    }
}
