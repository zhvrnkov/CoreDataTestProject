//
//  StudentsUtilsTest.swift
//  AssessmentDatabaseTests
//
//  Created by Vlad Zhavoronkov  on 8/1/19.
//  Copyright © 2019 Bytepace. All rights reserved.
//

import XCTest

class StudentsUtilsTest: XCTestCase {
    typealias This = StudentsUtilsTest
    static let container = getMockPersistentContainer()
    static let util: StudentsUtils = {
        let util = StudentsUtils(with: container)
        util.assessmentsUtils = This.assessmentsUtils
        util.instructorsUtils = This.instructorsUtils
        util.microtaskGradesUtils = This.microtaskGradesUtils
        return util
    }()
    static let rubricsUtils = RubricsUtils(with: container)
    static let skillSetsUtils: SkillSetsUtils = {
        let util = SkillSetsUtils(with: container)
        util.rubricUtils = This.rubricsUtils
        return util
    }()
    static let microtasksUtils: MicrotasksUtils = {
        let util = MicrotasksUtils(with: container)
        util.skillSetsUtils = This.skillSetsUtils
        return util
    }()
    static let gradesUtils = GradesUtils(with: container)
    static let microtaskGradesUtils: StudentMicrotaskGradesUtils = {
        let util = StudentMicrotaskGradesUtils(with: container)
        util.microtasksUtils = This.microtasksUtils
        util.assessmentsUtils = This.assessmentsUtils
        util.gradesUtils = This.gradesUtils
        return util
    }()
    static let instructorsUtils = InstructorsUtils(with: container)
    static let assessmentsUtils = AssessmentsUtils(container: container)
    static let context = util.container.viewContext
    
    private let mockStudents = Mocks.mockStudents
    private let mockRubrics = Mocks.mockEmptyRubrics
    private let mockInstructors = Mocks.mockEmptyInstructors
    private let mockAssessments = Mocks.mockEmptyAssessments
    private let mockGrades = Mocks.mockGrades
    private let mockSkillSets = Mocks.mockSkillSets.reduce([]) { $0 + $1 }
    private let mockMicroTasks = Mocks.mockMicrotasks.reduce([]) { $0 + $1 }
    private let microtasksGrades = Mocks.mockMicrotaskGrades
    
    override func setUp() {
        super.setUp()
        
        This.microtaskGradesUtils.studentsUtils = This.util
        
        This.assessmentsUtils.rubricsUtils = This.rubricsUtils
        This.assessmentsUtils.instructorsUtils = This.instructorsUtils
        
        XCTAssertNoThrow(try This.gradesUtils.save(items: mockGrades))
        XCTAssertNoThrow(try This.rubricsUtils.save(items: mockRubrics))
        XCTAssertNoThrow(try This.skillSetsUtils.save(items: mockSkillSets))
        XCTAssertNoThrow(try This.microtasksUtils.save(items: mockMicroTasks))
        XCTAssertNoThrow(try This.instructorsUtils.save(items: mockInstructors))
        XCTAssertNoThrow(try This.assessmentsUtils.save(items: mockAssessments))
    }
    
    override func tearDown() {
        super.tearDown()
        This.gradesUtils.deleteAll()
        This.rubricsUtils.deleteAll()
        This.skillSetsUtils.deleteAll()
        This.microtasksUtils.deleteAll()
        This.instructorsUtils.deleteAll()
        This.assessmentsUtils.deleteAll()
        
        XCTAssertTrue(This.gradesUtils.getAll().isEmpty)
        XCTAssertTrue(This.rubricsUtils.getAll().isEmpty)
        XCTAssertTrue(This.skillSetsUtils.getAll().isEmpty)
        XCTAssertTrue(This.microtasksUtils.getAll().isEmpty)
        XCTAssertTrue(This.instructorsUtils.getAll().isEmpty)
        XCTAssertTrue(This.assessmentsUtils.getAll().isEmpty)
    }
    
    func testSaveItem() {
        var item = mockStudents[0]
        item.microTaskGrades = microtasksGrades.filter { $0.student.sid == item.sid }
        var clearedStudent = item
        clearedStudent.microTaskGrades = []
        XCTAssertNoThrow(try This.util.save(item: clearedStudent))
        XCTAssertNoThrow(try This.microtaskGradesUtils.save(items: item.microTaskGrades))
        compareItems([item], This.util.getAll())
    }
    
    func testSaveItems() {
        let items = Array(mockStudents)
        var clearedItems = items
        for index in clearedItems.indices {
            clearedItems[index].microTaskGrades = []
        }
        XCTAssertNoThrow(try This.util.save(items: clearedItems))
        XCTAssertNoThrow(try This.microtaskGradesUtils.save(items: items.map({ $0.microTaskGrades }).reduce([]) { $0 + $1 }))
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
        XCTAssertEqual(item.assessments.count, entity.assessments?.count)
        XCTAssertEqual(item.instructors.count, entity.instructors?.count)
        XCTAssertEqual(item.microTaskGrades.count, entity.microTaskGrades?.count)
    }
}
