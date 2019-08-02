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
    static let rubricsUtil = RubricsUtils(with: container)
    static let studentsUtil = StudentsUtils(with: container)
    static let instructorsUtil = InstructorsUtils(with: container)
    static let studentMicrotaskGradesUtils = StudentMicrotaskGradesUtils(with: container)

    static let util: AssessmentsUtils = {
        let utils = AssessmentsUtils(container: container)
        utils.studentsUtils = studentsUtil
        utils.rubricsUtils = rubricsUtil
        utils.instructorsUtils = instructorsUtil
        utils.studentMicrotaskGradesUtils = studentMicrotaskGradesUtils
        return utils
    }()
    
    private let mockRubrics = Mocks.mockRubrics
    private let mockStudents = Mocks.mockStudents
    private let mockInstructors = Mocks.mockInstructors
    private let mockMicrotaskGrades = Mocks.mockMicrotaskGrades
    
    override func setUp() {
        super.setUp()
//        let context = This.context
//        context.performAndWait {
//            mockRubrics.forEach {
//                let r = Rubric(context: context)
//                This.rubricsUtil.copyFields(from: $0, to: r)
//                try! This.rubricsUtil.setRelations(of: r, like: $0)
//            }
//            mockStudents.forEach {
//                let s = Student(context: context)
//                This.studentsUtil.copyFields(from: $0, to: s)
//                try! This.studentsUtil.setRelations(of: s, like: $0)
//            }
//            mockInstructors.forEach {
//                let i = Instructor(context: context)
//                This.instructorsUtil.copyFields(from: $0, to: i)
//                try! This.instructorsUtil.setRelations(of: i, like: $0)
//            }
//            mockMicrotaskGrades.forEach {
//                let g = StudentMicrotaskGrade(context: context)
//                This.studentMicrotaskGradesUtils.copyFields(from: $0, to: g)
//                try! This.studentMicrotaskGradesUtils.setRelations(of: g, like: $0)
//            }
//            try! context.save()
//        }
        XCTAssertNoThrow(try This.rubricsUtil.save(items: mockRubrics))
        XCTAssertNoThrow(try This.studentsUtil.save(items: mockStudents))
        XCTAssertNoThrow(try This.instructorsUtil.save(items: mockInstructors))
        XCTAssertNoThrow(try This.studentMicrotaskGradesUtils.save(items: mockMicrotaskGrades))
    }
    
    override func tearDown() {
        super.tearDown()
        XCTAssertNoThrow(try This.rubricsUtil.delete(whereSids:
            mockRubrics.map { $0.sid }))
        XCTAssertNoThrow(try This.studentsUtil.delete(whereSids:
            mockStudents.map { $0.sid }))
        XCTAssertNoThrow(try This.instructorsUtil.delete(whereSids:
            mockInstructors.map { $0.sid }))
        XCTAssertNoThrow(try This.studentMicrotaskGradesUtils.delete(whereSids:
            mockMicrotaskGrades.map { $0.sid }))
    }
    
    func testSaveItem() {
        let item = Mocks.mockAssessments[0]
        XCTAssertNoThrow(try This.util.save(item: item))
        guard let entity = This.util.get(whereSid: item.sid) else {
            XCTFail("can't find entity")
            return
        }
        compareItems([item], [entity])
    }
    
    func testSaveItems() {
        let items = Array(Mocks.mockAssessments[1..<Mocks.mockAssessments.count])
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
            compareItem(item, entity)
        }
    }
    
    func compareItem(_ item: AssessmentFields, _ entity: Assessment) {
        checkFields(of: entity, source: item)
        checkRelations(of: entity)
        
        guard let students = entity.students?.allObjects as? [Student],
              let rubric = entity.rubric,
              let instructor = entity.instructor,
              let microtaskGrades = entity.studentMicrotaskGrades?.allObjects as? [StudentMicrotaskGrade]
        else {
            XCTFail()
            return
        }
        compareInstructors([item.instructor], [instructor])
        comapareRubric(item.rubric, rubric)
        comapreMicrotaskGrades(item.studentMicrotaskGrades, microtaskGrades)
        compareStudents(item.students, students)
    }
    
    func checkRelations(of entity: Assessment) {
        XCTAssertNotNil(entity.instructor)
        XCTAssertNotNil(entity.rubric)
        XCTAssertNotNil(entity.studentMicrotaskGrades?.allObjects as? [StudentMicrotaskGrade])
        XCTAssertNotNil(entity.students?.allObjects as? [Student])
    }
    
    func checkFields(of entity: Assessment, source item: AssessmentFields) {
        XCTAssertEqual(item.sid, Int(entity.sid))
        XCTAssertEqual(item.schoolId, Int(entity.schoolId))
        XCTAssertEqual(item.date, entity.date)
    }
    
    func compareInstructors(_ items: [InstructorFields], _ entities: [Instructor]) {
        XCTAssertEqual(items.count, entities.count)
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
    
    func comapreMicrotaskGrades(_ items: [StudentMicrotaskGradeFields], _ entities: [StudentMicrotaskGrade]) {
        XCTAssertEqual(items.count, entities.count)
    }
    
    func compareStudent(_ item: StudentFields, _ entity: Student) {
        XCTAssertEqual(item.sid, Int(entity.sid))
    }
    
    func comapareRubric(_ item: RubricFields, _ entity: Rubric) {
        XCTAssertEqual(item.sid, Int(entity.sid))
    }
}
