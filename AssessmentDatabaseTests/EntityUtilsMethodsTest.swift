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
    static var utils: AssessmentsUtils = .init(with: getMockPersistentContainer())
    static var context = This.utils.persistentContainer.viewContext
    let numberOfItems = 10
    
    override func setUp() {
        super.setUp()
        createItems(number: numberOfItems)
    }
    
    func createItems(number: Int) {
        print(#function)
        let context = This.context
        for _ in 0..<number {
            Assessment(context: context)
        }
        try! context.save()
    }
    
    override func tearDown() {
        super.tearDown()
        clearItems()
    }
    
    func clearItems() {
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest<NSFetchRequestResult>(entityName: "Assessment")
        let objs = try! This.context.fetch(fetchRequest)
        for case let obj as NSManagedObject in objs {
            This.context.delete(obj)
        }
        try! This.context.save()

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
