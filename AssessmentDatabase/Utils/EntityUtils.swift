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
    
    var persistentContainer: NSPersistentContainer { get set }
    
    func getAll() -> [EntityType]
    func asyncGetAll(_ completion: @escaping (Result<[EntityType], Error>) -> Void)
    
    func get(where predicate: Predicate) -> [EntityType]
    func asyncGet(where predicate: Predicate, _ completeion: @escaping (Result<[EntityType], Error>) -> Void)
}

public extension EntityUtils {
    func getAll() -> [EntityType] {
        let request: NSFetchRequest<EntityType> = NSFetchRequest<EntityType>(
            entityName: String(describing: EntityType.self))
        var output: [EntityType] = []
        let context = persistentContainer.viewContext
        context.performAndWait {
            do {
                output = try context.fetch(request)
            } catch {
                fatalError(error.localizedDescription)
            }
        }
        return output
    }
    
    func asyncGetAll(_ completion: @escaping (Result<[EntityType], Error>) -> Void) {
        let request: NSFetchRequest<EntityType> = NSFetchRequest<EntityType>(
            entityName: String(describing: EntityType.self)
        )
        let context = persistentContainer.viewContext
        context.perform {
            do {
                completion(.success(try context.fetch(request)))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func get(where predicate: Predicate) -> [EntityType] {
        let request: NSFetchRequest<EntityType> = NSFetchRequest(entityName: "\(EntityType.self)")
        request.predicate = NSPredicate(format: predicate.format, argumentArray: predicate.arguments)
        var output: [EntityType] = []
        let context = persistentContainer.viewContext
        context.performAndWait {
            do {
                output = try context.fetch(request)
            } catch {
                fatalError(error.localizedDescription)
            }
        }
        return output
    }
    
    func asyncGet(where predicate: Predicate, _ completeion: @escaping (Result<[EntityType], Error>) -> Void) {
        let request: NSFetchRequest<EntityType> = NSFetchRequest(entityName: "\(EntityType.self)")
        request.predicate = NSPredicate(format: predicate.format, argumentArray: predicate.arguments)
        let context = persistentContainer.viewContext
        context.perform {
            do {
                completeion(.success(try context.fetch(request)))
            } catch {
                completeion(.failure(error))
            }
        }
    }
    
    func deleteAll() {
        let all = getAll()
        for item in all {
            persistentContainer.viewContext.delete(item)
        }
        try? persistentContainer.viewContext.save()
    }
}
