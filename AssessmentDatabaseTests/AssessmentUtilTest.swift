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
    static let util = AssessmentsUtils(with: getMockPersistentContainer())
    static let context = util.container.viewContext
    
    func testSaveItem() {
        let item = assessments[0]
        This.util.save(item: item)
        compareItems([item], This.util.getAll())
    }
    
    func testSaveItems() {
        let items = Array(assessments[1..<assessments.count])
        This.util.save(items: items)
        compareItems(assessments, This.util.getAll())
    }
    
    func compareItems(_ items: [AssessmentFields], _ entities: [Assessment]) {
        XCTAssertEqual(items.count, entities.count)
        for index in items.indices {
            let item = items[index]
            let entity = entities.first { Int($0.sid) == item.sid }
            XCTAssertNotNil(entity)
            compareItem(item, entity!)
//            compareStudents(item.students, entity.students?.allObjects as! [Student])
//            comapareRubric(item.rubric, entity.rubric!)
        }
    }
    
    func compareItem(_ item: AssessmentFields, _ entity: Assessment) {
        XCTAssertEqual(item.sid, Int(entity.sid))
        XCTAssertEqual(item.schoolId, Int(entity.schoolId))
        XCTAssertEqual(item.date, entity.date)
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
