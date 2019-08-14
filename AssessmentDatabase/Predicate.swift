//
//  Predicate.swift
//  AssessmentDatabaseTests
//
//  Created by Vlad Zhavoronkov  on 7/31/19.
//  Copyright © 2019 Bytepace. All rights reserved.
//

import Foundation

public struct Predicate {
    public let format: String
    public let arguments: [Any]
    
    public init(format: String, arguments: [Any]) {
        self.format = format
        self.arguments = arguments
    }
}
