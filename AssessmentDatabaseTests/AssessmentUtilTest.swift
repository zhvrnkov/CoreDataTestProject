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
    static let util = AssessmentsUtils(container: container, studentsUtils: studentsUtil, rubricsUtils: rubricsUtil)
    static let rubricsUtil = RubricsUtils(with: container)
    static let studentsUtil = StudentsUtils(with: container)
    static let context = util.container.viewContext
    
    override func setUp() {
        super.setUp()
        XCTAssertNoThrow(try This.rubricsUtil.save(items: mockRubrics))
        XCTAssertNoThrow(try This.studentsUtil.save(items: mockStudents))
    }
    
    override func tearDown() {
        super.tearDown()
        XCTAssertNoThrow(try This.rubricsUtil.delete(whereSids:
            mockRubrics.map { $0.sid }))
        XCTAssertNoThrow(try This.studentsUtil.delete(whereSids:
            mockStudents.map { $0.sid }))
    }
    
    func testSaveItem() {
        let item = mockAssessments[0]
        XCTAssertNoThrow(try This.util.save(item: item))
        let entity = This.util.get(whereSid: item.sid)
        XCTAssertNotNil(entity)
        compareItems([item], [entity!])
    }
    
    func testSaveItems() {
        let items = Array(mockAssessments[1..<mockAssessments.count])
        XCTAssertNoThrow(try This.util.save(items: items))
        compareItems(items, This.util.getAll())
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
            let item = items[index]
            guard let entity = entities.first(where: { item.sid == $0.sid }) else {
                XCTFail("no such entity with id: \(item.sid)")
                return
            }
            compareStudent(item, entity)
        }
    }
    
    func compareStudent(_ item: StudentFields, _ entity: Student) {
        XCTAssertEqual(item.sid, Int(entity.sid))
    }
    
    func comapareRubric(_ item: RubricFields, _ entity: Rubric) {
        XCTAssertEqual(item.sid, Int(entity.sid))
    }
}
