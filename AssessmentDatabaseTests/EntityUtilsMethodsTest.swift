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
    private let mocks = EntityUtilsMethodsTestMocks()
    private lazy var mockGrades = mocks.mockGrades
    
    override func setUp() {
        super.setUp()
        XCTAssertNoThrow(try This.utils.save(items: mockGrades))
    }
    
    override func tearDown() {
        super.tearDown()
        XCTAssertNoThrow(try This.utils.delete(whereSids: mockGrades.sids))
        XCTAssertTrue(This.utils.getAll().isEmpty)
    }
    
    func testThatPersistentContainerIsSetted() {
        XCTAssertNoThrow(try DatabaseManager.getInitializedPersistentContainer())
    }
    
    func testGetAll() {
        let grades = This.utils.getAll()
        XCTAssertEqual(grades.count, mockGrades.count)
        mockGrades.forEach { item in
            guard let entity = grades.first(where: { Int($0.sid) == item.sid }) else {
                XCTFail()
                return
            }
            XCTAssertNotNil(entity)
            XCTAssertEqual(item.sid, entity.sid)
            XCTAssertEqual(item.title, entity.title)
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
            XCTAssertEqual(item?.sid, Int($0.sid), "\($0.sid)")
        }
    }
    
    func testAsyncGetWhereSid() {
        let exp = XCTestExpectation(description: "")
        This.utils.asyncGet(whereSid: mockGrades[0].sid) { result in
            switch result {
            case .success(let output):
                XCTAssertNotNil(output)
                XCTAssertEqual(output?.sid, Int(self.mockGrades[0].sid))
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
            XCTAssertNotEqual($0.sid, item.sid)
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
    
    func testFilterWithEmptyNew() {
        let saved = mocks.savedItems
        let new: [MockGradeFields] = []
        let output = This.utils._filter(saved: saved.map { $0.sid }, new: new.map { $0.sid })
        XCTAssertEqual(saved.count, output.toDelete.count)
        XCTAssertEqual(output.toAdd.count, 0)
        let itemsToDelete = output.toDelete.compactMap { sid in saved.first(where: { $0.sid == sid })}
        compareFilterItems(saved, itemsToDelete)
    }
    
    func testFilterWithNewThatNotInSaved() {
        let saved = mocks.savedItems
        let new = (Int(saved.count)..<Int(saved.count + 10))
            .map { MockGradeFields.mock(sid: $0) }
        let output = This.utils._filter(saved: saved.map { $0.sid }, new: new.map { $0.sid })
        XCTAssertEqual(new.count, output.toAdd.count)
        XCTAssertEqual(saved.count, output.toDelete.count)
        let itemsToSave = output.toAdd.compactMap { sid in new.first(where: { $0.sid == sid })}
        let itemsToDelete = output.toDelete.compactMap { sid in saved.first(where: { $0.sid == sid })}
        compareFilterItems(new, itemsToSave)
        compareFilterItems(saved, itemsToDelete)
    }
    
    func testFilterWithHalfInSavedAndHalfDont() {
        let saved = mocks.savedItems
        let new = (Int(saved.count/2)..<Int(saved.count))
            .map { MockGradeFields.mock(sid: $0) }
        let toDelete = (0..<Int(saved.count/2))
            .map { MockGradeFields.mock(sid: $0) }
        let toSave = (Int(saved.count)..<Int(saved.count/2 + saved.count))
            .map { MockGradeFields.mock(sid: $0) }
        let output = This.utils._filter(saved: saved.map { $0.sid }, new: (new + toSave).map { $0.sid })
        XCTAssertEqual(toDelete.count, output.toDelete.count)
        XCTAssertEqual(toSave.count, output.toAdd.count)
        let itemsToDelete = output.toDelete.compactMap{ sid in saved.first { $0.sid == sid }}
        let itemsToSave = output.toAdd.compactMap { sid in toSave.first { $0.sid == sid }}
        compareFilterItems(toDelete, itemsToDelete)
        compareFilterItems(toSave, itemsToSave)
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
        XCTAssertEqual(item.sid, entity.sid)
        XCTAssertEqual(item.title, entity.title)
    }
    
    func compareFilterItems(_ saved: [MockGradeFields], _ new: [MockGradeFields]) {
        saved.forEach { item in
            guard let toDelete = new.first(where: { $0.sid == item.sid }) else {
                XCTFail()
                return
            }
            XCTAssertEqual(toDelete.sid, item.sid)
        }
    }
}
