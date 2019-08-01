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
        let items = This.utils.get(whereSids: mockGrades.map { $0.sid })
        XCTAssertEqual(items.count, mockGrades.count)
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
    
    func compareItem(_ item: MockGradeFields, _ entity: Grade) {
        XCTAssertEqual(item.sid, Int(entity.sid))
        XCTAssertEqual(item.title, entity.title)
    }
}
