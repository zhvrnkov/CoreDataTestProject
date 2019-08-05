//
//  AssessmentDatabaseTests.swift
//  AssessmentDatabaseTests
//
//  Created by Vlad Zhavoronkov  on 7/22/19.
//  Copyright © 2019 Bytepace. All rights reserved.
//

import XCTest
import CoreData

final class EntityUtilsMethodsTest: XCTestCase {
    typealias This = EntityUtilsMethodsTest
    static var utils: GradesUtils = .init(with: getMockPersistentContainer())
    static let context = This.utils.container.viewContext
    private let mockGrades = EntityUtilsMethodsTestMocks().mockGrades
    
    override func setUp() {
        super.setUp()
        XCTAssertNoThrow(try This.utils.save(items: mockGrades))
    }
    
    override func tearDown() {
        super.tearDown()
        This.utils.deleteAll()
        XCTAssertEqual(This.utils.getAll().count, 0)
    }
    
    func testThatPersistentContainerIsSetted() {
        XCTAssertNoThrow(try DatabaseManager.getInitializedPersistentContainer())
    }
    
    func testGetAll() {
        let grades = This.utils.getAll()
        XCTAssertEqual(grades.count, mockGrades.count)
        mockGrades.forEach { item in
            let entity = grades.first(where: { Int($0.sid) == item.sid })
            XCTAssertNotNil(entity)
            XCTAssertEqual(item.sid, Int(entity!.sid))
            XCTAssertEqual(item.title, entity?.title)
        }
    }
    
    func testAsynGetAll() {
        let expectation = XCTestExpectation(description: "")
        This.utils.asyncGetAll { result in
            switch result {
            case .success(let grades):
                XCTAssertEqual(grades.count, self.mockGrades.count)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10)
    }
    
    func testGetWherePredicate() {
        let item = mockGrades[0]
        let predicate = Predicate(format: "sid==%d", arguments: [item.sid])
        let entities = This.utils.get(where: predicate)
        compareItems([item], entities)
    }
    
    func testAsyncGetWherePredicate() {
        let item = mockGrades[mockGrades.count - 1]
        let predicate = Predicate(format: "sid==%d", arguments: [item.sid])
        let exp = XCTestExpectation(description: "check entity in async get method")
        This.utils.asyncGet(where: predicate) { result in
            switch result {
            case .success(let data):
                self.compareItems([item], data)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 10)
    }
    
    func testGetWhereSid() {
        mockGrades.forEach {
            let item = This.utils.get(whereSid: $0.sid)
            XCTAssertNotNil(item)
            XCTAssertEqual(item?.sid, Int64($0.sid), "\($0.sid)")
        }
    }
    
    func testAsyncGetWhereSid() {
        let exp = XCTestExpectation(description: "")
        This.utils.asyncGet(whereSid: mockGrades[0].sid) { result in
            switch result {
            case .success(let output):
                XCTAssertNotNil(output)
                XCTAssertEqual(output?.sid, Int64(self.mockGrades[0].sid))
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 10)
    }
    
    func testGetWhereSids() {
        let mocks = mockGrades[0..<(mockGrades.count / 2)]
        let items = This.utils.get(whereSids: mocks.map { $0.sid })
        XCTAssertEqual(items.count, mocks.count)
    }
    
    func testAsyncGetWhereSids() {
        let exp = XCTestExpectation(description: "")
        This.utils.asyncGet(whereSids: mockGrades.map { $0.sid }) { result in
            switch result {
            case .success(let output):
                XCTAssertEqual(output.count, self.mockGrades.count)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 10)
    }
    
    func testSaveItem() {
        let item = mockGrades[0]
        XCTAssertNoThrow(try This.utils.save(item: item))
        XCTAssertEqual(This.utils.getAll().count, mockGrades.count + 1)
    }
    
    func testDeleteWhereSid() {
        let item = mockGrades[0]
        XCTAssertNoThrow(try This.utils.delete(whereSid: item.sid))
        This.utils.getAll().forEach {
            XCTAssertNotEqual(Int($0.sid), item.sid)
        }
    }
    
    func testDeleteWhereSids() {
        XCTAssertNoThrow(try This.utils.delete(whereSids: mockGrades.map { $0.sid }))
        XCTAssertTrue(This.utils.getAll().isEmpty)
    }
    
    func testUpdate() {
        var toUpdate = mockGrades[0]
        toUpdate.title = "Ipsum Lorem"
        XCTAssertNoThrow(try This.utils.update(whereSid: toUpdate.sid, like: toUpdate))
        guard let entity = This.utils.get(whereSid: toUpdate.sid) else {
            XCTFail()
            return
        }
        compareItem(toUpdate, entity)
    }
    
    func compareItems(_ items: [MockGradeFields], _ entities: [Grade]) {
        XCTAssertEqual(items.count, entities.count)
        for index in items.indices {
            let item = items[index]
            guard let entity = entities.first(where: { Int($0.sid) == item.sid }) else {
                XCTFail("can't found entity")
                return
            }
            compareItem(item, entity)
        }
    }
    
    func compareItem(_ item: MockGradeFields, _ entity: Grade) {
        XCTAssertEqual(item.sid, Int(entity.sid))
        XCTAssertEqual(item.title, entity.title)
    }
}
