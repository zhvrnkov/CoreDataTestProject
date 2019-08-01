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
    associatedtype EntityValueFields
    
    var container: NSPersistentContainer { get set }
    var backgroundContext: NSManagedObjectContext { get set }
    
    func copyFields(from item: EntityValueFields, to entity: EntityType)
    func setRelations(of entity: EntityType, like item: EntityValueFields) throws
    
    func getAll() -> [EntityType]
    func asyncGetAll(_ completion: @escaping (Result<[EntityType], Error>) -> Void)
    
    func get(where predicate: Predicate) -> [EntityType]
    func asyncGet(where predicate: Predicate, _ completeion: @escaping (Result<[EntityType], Error>) -> Void)
    
    func get(whereSid sid: Int) -> EntityType?
    func asyncGet(whereSid sid: Int, _ completeion: @escaping (Result<EntityType?, Error>) -> Void)
    
    func get(whereSids sids: [Int]) -> [EntityType]
    func asyncGet(whereSids sids: [Int], _ completeion: @escaping (Result<[EntityType], Error>) -> Void)
    
    func save(item: EntityValueFields) throws
    func save(items: [EntityValueFields]) throws
    
    func delete(whereSid sid: Int) throws
    func delete(whereSids sids: [Int]) throws
    
    func update(whereSid sid: Int, like item: EntityValueFields) throws
    func update(items: [EntityValueFields]) throws
}

public extension EntityUtils {
    func getAll() -> [EntityType] {
        let request = NSFetchRequest<EntityType>(
            entityName: "\(EntityType.self)")
        var output: [EntityType] = []
        let context = container.viewContext
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
        let request = NSFetchRequest<EntityType>(
            entityName: "\(EntityType.self)"
        )
        let context = container.viewContext
        context.perform {
            do {
                completion(.success(try context.fetch(request)))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func get(where predicate: Predicate) -> [EntityType] {
        let request = NSFetchRequest<EntityType>(entityName: "\(EntityType.self)")
        request.predicate = NSPredicate(format: predicate.format, argumentArray: predicate.arguments)
        var output: [EntityType] = []
        let context = container.viewContext
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
        let request = NSFetchRequest<EntityType>(entityName: "\(EntityType.self)")
        request.predicate = NSPredicate(format: predicate.format, argumentArray: predicate.arguments)
        let context = container.viewContext
        context.perform {
            do {
                completeion(.success(try context.fetch(request)))
            } catch {
                completeion(.failure(error))
            }
        }
    }
    
    func get(whereSid sid: Int) -> EntityType? {
        let predicate = Predicate(format: "sid==%d", arguments: [sid])
        let output = get(where: predicate)
        assert(output.count <= 1)
        return output.first
    }
    
    func asyncGet(whereSid sid: Int, _ completeion: @escaping (Result<EntityType?, Error>) -> Void) {
        let predicate = Predicate(format: "sid==%d", arguments: [sid])
        asyncGet(where: predicate) { result in
            switch result {
            case .success(let output):
                assert(output.count <= 1)
                completeion(.success(output.first))
            case .failure(let error):
                completeion(.failure(error))
            }
        }
    }
    
    func get(whereSids sids: [Int]) -> [EntityType] {
        let predicate = Predicate(format: "sid IN %@", arguments: [sids])
        return get(where: predicate)
    }
    
    func asyncGet(whereSids sids: [Int], _ completeion: @escaping (Result<[EntityType], Error>) -> Void) {
        let predicate = Predicate(format: "sid IN %@", arguments: [sids])
        asyncGet(where: predicate, completeion)
    }
    
    func save(item: EntityValueFields) throws {
        var error: Error?
        backgroundContext.performAndWait {
            let entity = EntityType(context: backgroundContext)
            self.copyFields(from: item, to: entity)
            do {
                try self.setRelations(of: entity, like: item)
                try backgroundContext.save()
            } catch let err {
                error = err
            }
        }
        if let error = error {
            throw error
        }
    }
    
    func save(items: [EntityValueFields]) throws {
        var error: Error?
        backgroundContext.performAndWait {
            items.forEach { item in
                let entity = EntityType(context: backgroundContext)
                self.copyFields(from: item, to: entity)
                do {
                    try self.setRelations(of: entity, like: item)
                } catch let err {
                    error = err
                }
            }
            do {
                try backgroundContext.save()
            } catch let err {
                error == nil ? error = err : ()
            }
        }
        if let error = error {
            throw error
        }
    }
    
    func delete(whereSid sid: Int) {
        guard let entity = get(whereSid: sid) else {
            fatalError("No such entity to delete")
        }
        backgroundContext.delete(entity)
    }
    
    func delete(whereSids sids: [Int]) {
        let entities = get(whereSids: sids)
        entities.forEach {
            backgroundContext.delete($0)
        }
    }
    
    func update(whereSid sid: Int, like item: EntityValueFields) throws {
        guard let entity = get(whereSid: sid) else {
            throw EntityUtilsError.entityNotFound
        }
        copyFields(from: item, to: entity)
        do {
            try backgroundContext.save()
        } catch {
            throw error
        }
    }
    
    func update(items: [EntityValueFields]) throws {
        
    }
    
    func deleteAll() {
        let all = getAll()
        for item in all {
            container.viewContext.delete(item)
        }
        try? container.viewContext.save()
    }
}
