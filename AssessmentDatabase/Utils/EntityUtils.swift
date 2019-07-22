//
//  EntityUtils.swift
//  AssessmentDatabase
//
//  Created by Vlad Zhavoronkov  on 7/22/19.
//  Copyright © 2019 Bytepace. All rights reserved.
//

import Foundation
import CoreData

public protocol EntityUtils {
    associatedtype EntityType: NSManagedObject
    
    func getAll() -> [EntityType]
    func get(where predicate: String) -> [EntityType]
}
