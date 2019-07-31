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
    let numberOfItems = 10
    
    override func setUp() {
        super.setUp()
        createItems(number: numberOfItems)
    }
    
    func createItems(number: Int) {
        let context = This.context
        for _ in 0..<number {
            Grade(context: context)
        }
        try! context.save()
    }
    
    override func tearDown() {
        super.tearDown()
        This.utils.deleteAll()
    }
    
    func testThatPersistentContainerIsSetted() {
        XCTAssertNoThrow(try DatabaseManager.shared.getInitializedPersistentContainer())
    }
    
    func testNumberOfItems() {
        let assessments = This.utils.getAll()
        XCTAssertEqual(assessments.count, numberOfItems)
    }
    
    func testAsyncNumberOfItems() {
        let expectation = XCTestExpectation(description: "")
        This.utils.asyncGetAll { result in
            switch result {
            case .success(let assessments):
                XCTAssertEqual(assessments.count, self.numberOfItems)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10)
    }
}
