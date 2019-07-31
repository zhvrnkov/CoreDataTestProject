//
//  MockPersistentContainer.swift
//  AssessmentDatabaseTests
//
//  Created by Vlad Zhavoronkov  on 7/31/19.
//  Copyright © 2019 Bytepace. All rights reserved.
//

import Foundation
import CoreData

func getMockPersistentContainer() -> NSPersistentContainer {
    let managedObjectModel = getManagedObjectModel()
    let container = NSPersistentContainer(name: "DataModel", managedObjectModel: managedObjectModel)
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

func getManagedObjectModel() -> NSManagedObjectModel {
    return NSManagedObjectModel.mergedModel(from: [Bundle(for: EntityUtilsMethodsTest.self)])!
}
