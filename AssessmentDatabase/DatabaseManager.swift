//
//  DatabaseManager.swift
//  AssessmentDatabase
//
//  Created by Vlad Zhavoronkov  on 7/22/19.
//  Copyright © 2019 Bytepace. All rights reserved.
//

import Foundation
import CoreData

public enum DatabaseEnviorment {
    case test
    case common
}

final public class DatabaseManager {
    public static let shared = DatabaseManager()
    private init() {
        switch DatabaseManager.env {
        case .common:
            persistentContainer = DatabaseManager.getInitializedPersistentContainer()
        case .test:
            persistentContainer = DatabaseManager.getMockPersistentContainer()
        }
    }
    
    public static var env: DatabaseEnviorment = .common
    
    public let persistentContainer: PersistentContainer
    
    private static func getInitializedPersistentContainer(named name: String = "DataModel") -> PersistentContainer {
        let container = PersistentContainer(name: name)
        var errorToThrow: Error?
        container.loadPersistentStores { _, error in
            if let error = error {
                errorToThrow = error
            }
        }
        if let error = errorToThrow {
            fatalError(error.localizedDescription)
        } else {
            return container
        }
    }
    
    private static func getMockPersistentContainer(named name: String = "DataModel") -> PersistentContainer {
        let managedObjectModel = getManagedObjectModel()
        let container = PersistentContainer(name: name, managedObjectModel: managedObjectModel)
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        description.shouldAddStoreAsynchronously = false
        
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { (description, error) in
            precondition( description.type == NSInMemoryStoreType )
            if let error = error {
                fatalError("Create an in-mem coordinator failed \(error)")
            }
        }
        return container
    }
    
    private static func getManagedObjectModel() -> NSManagedObjectModel {
        return NSManagedObjectModel.mergedModel(from: [Bundle(for: DatabaseManager.self)])!
    }
}
