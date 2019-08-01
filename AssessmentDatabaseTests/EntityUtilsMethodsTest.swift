//
//  AssessmentDatabaseTests.swift
//  AssessmentDatabaseTests
//
//  Created by Vlad Zhavoronkov  on 7/22/19.
//  Copyright © 2019 Bytepace. All rights reserved.
//

import XCTest
import CoreData

class EntityUtilsMethodsTest: XCTestCase {
    typealias This = EntityUtilsMethodsTest
    static var utils: GradesUtils = .init(with: getMockPersistentContainer())
    static let context = This.utils.container.viewContext
    
    override func setUp() {
        super.setUp()
        XCTAssertNoThrow(try This.utils.save(items: mockGrades))
    }
    
    override func tearDown() {
        super.tearDown()
        This.utils.deleteAll()
    }
    
    func testThatPersistentContainerIsSetted() {
        XCTAssertNoThrow(try DatabaseManager.shared.getInitializedPersistentContainer())
    }
    
    func testNumberOfItems() {
        let grades = This.utils.getAll()
        XCTAssertEqual(grades.count, mockGrades.count)
        mockGrades.forEach { item in
            let entity = grades.first(where: { Int($0.sid) == item.sid })
            XCTAssertNotNil(entity)
            XCTAssertEqual(item.sid, Int(entity!.sid))
            XCTAssertEqual(item.title, entity?.title)
        }
    }
    
    func testAsyncNumberOfItems() {
        let expectation = XCTestExpectation(description: "")
        This.utils.asyncGetAll { result in
            switch result {
            case .success(let grades):
                XCTAssertEqual(grades.count, mockGrades.count)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10)
    }
    
    func testWhereSid() {
        mockGrades.forEach {
            let item = This.utils.get(whereSid: $0.sid)
            XCTAssertNotNil(item)
            XCTAssertEqual(item?.sid, Int64($0.sid), "\($0.sid)")
        }
    }
    
    func testAsyncWhereSid() {
        let exp = XCTestExpectation(description: "")
        This.utils.asyncGet(whereSid: mockGrades[0].sid) { result in
            switch result {
            case .success(let output):
                XCTAssertNotNil(output)
                XCTAssertEqual(output?.sid, Int64(mockGrades[0].sid))
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 10)
    }
    
    func testWhereSids() {
        let mocks = mockGrades[0..<(mockGrades.count / 2)]
        let items = This.utils.get(whereSids: mocks.map { $0.sid })
        XCTAssertEqual(items.count, mocks.count)
    }
    
    func testAsyncWhereSids() {
        let exp = XCTestExpectation(description: "")
        This.utils.asyncGet(whereSids: mockGrades.map { $0.sid }) { result in
            switch result {
            case .success(let output):
                XCTAssertEqual(output.count, mockGrades.count)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 10)
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
    
//    func testUpdateMany() {
//        var toUpdate = Array(mockGrades[0...2])
//        toUpdate[0].title = "Lorem Upsum"
//        toUpdate[1].title = "Datur Fixum"
//        toUpdate[2].title = "Ergo sum"
//        XCTAssertNoThrow(try This.utils.update(whereSids: toUpdate.map { $0.sid }, like: toUpdate))
//        let entities = This.utils.get(whereSids: toUpdate.map { $0.sid })
//        XCTAssertFalse(entities.isEmpty)
//        toUpdate.forEach { item in
//            guard let entity = entities.first(where: { Int($0.sid) == item.sid }) else {
//                XCTFail()
//                return
//            }
//            compareItem(item, entity)
//        }
//    }
    
    func compareItem(_ item: MockGradeFields, _ entity: Grade) {
        XCTAssertEqual(item.sid, Int(entity.sid))
        XCTAssertEqual(item.title, entity.title)
    }
}
