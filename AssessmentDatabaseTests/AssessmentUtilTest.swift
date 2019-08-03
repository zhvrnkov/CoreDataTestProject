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
    static let skillSetsUtils: SkillSetsUtils = {
        let util = SkillSetsUtils(with: container)
        util.rubricUtils = This.rubricsUtil
        return util
    }()
    static let microtasksUtils: MicrotasksUtils = {
        let util = MicrotasksUtils(with: container)
        util.skillSetsUtils = This.skillSetsUtils
        return util
    }()
    static let studentsUtil = StudentsUtils(with: container)
    static let instructorsUtil = InstructorsUtils(with: container)
    static let studentMicrotaskGradesUtils = StudentMicrotaskGradesUtils(with: container)
    static let gradesUtils = GradesUtils(with: container)
    

    static let util: AssessmentsUtils = {
        let utils = AssessmentsUtils(container: container)
        utils.studentsUtils = studentsUtil
        utils.rubricsUtils = rubricsUtil
        utils.instructorsUtils = instructorsUtil
        utils.studentMicrotaskGradesUtils = studentMicrotaskGradesUtils
        return utils
    }()
    
    private let mockAssessments = Mocks.mockAssessments
    private let mockRubrics = Mocks.mockRubrics
    private let mockSkillSets = Mocks.mockSkillSets
    private let mockMicrotasks = Mocks.mockMicrotasks
    private let mockStudents = Mocks.mockStudents
    private let mockInstructors = Mocks.mockInstructors
    private let mockMicrotaskGrades = Mocks.mockMicrotaskGrades
    private let mockGrades = Mocks.mockGrades
    
    override func setUp() {
        super.setUp()
        This.studentMicrotaskGradesUtils.assessmentsUtils = This.util
        This.studentMicrotaskGradesUtils.studentsUtils = This.studentsUtil
        This.studentMicrotaskGradesUtils.gradesUtils = This.gradesUtils
        This.studentMicrotaskGradesUtils.microtasksUtils = This.microtasksUtils
        
        XCTAssertNoThrow(try This.instructorsUtil.save(items: mockInstructors))
        XCTAssertNoThrow(try This.rubricsUtil.save(items: mockRubrics))
        XCTAssertNoThrow(try This.skillSetsUtils.save(items: mockSkillSets.reduce([]) { $0 + $1 }))
        XCTAssertNoThrow(try This.microtasksUtils.save(items: mockMicrotasks.reduce([]) { $0 + $1 }))
        XCTAssertNoThrow(try This.studentsUtil.save(items: mockStudents))
        XCTAssertNoThrow(try This.gradesUtils.save(items: mockGrades))
    }
    
    override func tearDown() {
        super.tearDown()
        This.instructorsUtil.deleteAll()
        This.rubricsUtil.deleteAll()
        This.studentsUtil.deleteAll()
        This.studentMicrotaskGradesUtils.deleteAll()
        This.gradesUtils.deleteAll()
        This.skillSetsUtils.deleteAll()
        This.microtasksUtils.deleteAll()
        
        XCTAssertTrue(This.instructorsUtil.getAll().isEmpty)
        XCTAssertTrue(This.rubricsUtil.getAll().isEmpty)
        XCTAssertTrue(This.studentsUtil.getAll().isEmpty)
        XCTAssertTrue(This.studentMicrotaskGradesUtils.getAll().isEmpty)
        XCTAssertTrue(This.gradesUtils.getAll().isEmpty)
        XCTAssertTrue(This.skillSetsUtils.getAll().isEmpty)
        XCTAssertTrue(This.microtasksUtils.getAll().isEmpty)
    }
    
    func testSaveItem() {
        let item = mockAssessments[0]
        var clearedItem = item
        clearedItem.studentMicrotaskGrades = []
        XCTAssertNoThrow(try This.util.save(item: clearedItem))
        XCTAssertNoThrow(try This.studentMicrotaskGradesUtils.save(items: item.studentMicrotaskGrades))
        guard let entity = This.util.get(whereSid: item.sid) else {
            XCTFail("can't find entity")
            return
        }
        compareItems([item], [entity])
    }

    func testSaveItems() {
        let items = Array(mockAssessments[1..<mockAssessments.count])
        var clearedItems = items
        for index in clearedItems.indices {
            clearedItems[index].studentMicrotaskGrades = []
        }
        XCTAssertNoThrow(try This.util.save(items: clearedItems))
        XCTAssertNoThrow(try This.studentMicrotaskGradesUtils.save(items: items.reduce([]) { $0 + $1.studentMicrotaskGrades }))
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
