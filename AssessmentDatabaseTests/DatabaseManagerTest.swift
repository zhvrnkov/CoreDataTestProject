//
//  AssessmentDatabaseTests.swift
//  AssessmentDatabaseTests
//
//  Created by Vlad Zhavoronkov  on 7/22/19.
//  Copyright © 2019 Bytepace. All rights reserved.
//

import XCTest
@testable import AssessmentDatabase

class AssessmentDatabaseTests: XCTestCase {
    func testThatPersistentContainerIsSetted() {
        XCTAssertNoThrow(try DatabaseManager.shared.getInitializedPersistentContainer())
    }
}
