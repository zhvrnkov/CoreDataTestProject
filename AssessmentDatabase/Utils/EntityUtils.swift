//
//  EntityUtils.swift
//  AssessmentDatabase
//
//  Created by Vlad Zhavoronkov  on 7/22/19.
//  Copyright © 2019 Bytepace. All rights reserved.
//

import Foundation
import CoreData

public struct FilterOutput<Item: Sidable> {
    let toDelete: [Item]
    let toSave: [Item]
}

public protocol EntityUtils: class {
    associatedtype EntityType: NSManagedObject
    associatedtype EntityValueFields
    
    var container: NSPersistentContainer { get set }
    var backgroundContext: NSManagedObjectContext { get }
    
    func copyFields(from item: EntityValueFields, to entity: EntityType)
    func setRelations(from item: EntityValueFields, of entity: EntityType, in context: NSManagedObjectContext) throws
    
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
        let context = backgroundContext
        context.performAndWait {
            let entity = EntityType(context: context)
            self.copyFields(from: item, to: entity)
            do {
                try self.setRelations(from: item, of: entity, in: context)
                try context.save()
                try saveMain()
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
        let context = backgroundContext
        context.performAndWait {
            items.forEach { item in
                let entity = EntityType(context: context)
                self.copyFields(from: item, to: entity)
                do {
                    try self.setRelations(from: item, of: entity, in: context)
                } catch let err {
                    error = err
                }
            }
            do {
                try context.save()
                try saveMain()
            } catch let err {
                error == nil ? error = err : ()
            }
        }
        if let error = error {
            throw error
        }
    }
    
    func delete(whereSid sid: Int) throws {
        var error: Error?
        let context = backgroundContext
        context.performAndWait {
            guard let entity = get(whereSid: sid) else {
                error = EntityUtilsError.entityNotFound
                return
            }
            let contextEntity = context.object(with: entity.objectID)
            context.delete(contextEntity)
            do {
                try context.save()
                try saveMain()
            } catch let err {
                error = err
            }
        }
        if let error = error {
            throw error
        }
    }
    
    func delete(whereSids sids: [Int]) throws {
        var error: Error?
        let context = backgroundContext
        context.performAndWait {
            let entities = get(whereSids: sids)
            entities.forEach { entity in
                let contextEntity = context.object(with: entity.objectID)
                context.delete(contextEntity)
            }
            do {
                try context.save()
                try saveMain()
            } catch let err {
                error = err
            }
        }
        if let error = error {
            throw error
        }
    }
    
    func update(whereSid sid: Int, like item: EntityValueFields) throws {
        var error: Error?
        let context = backgroundContext
        context.performAndWait {
            guard let entity = get(whereSid: sid),
                let contextEntity = context.object(with: entity.objectID) as? EntityType
            else {
                error = EntityUtilsError.entityNotFound
                return
            }
            copyFields(from: item, to: contextEntity)
            do {
                try setRelations(from: item, of: contextEntity, in: context)
                try context.save()
                try saveMain()
            } catch let err {
                error = err
            }
        }
        if let error = error {
            throw error
        }
    }
    
    func deleteAll() {
        let all = getAll()
        for item in all {
            container.viewContext.delete(item)
        }
        try? saveMain()
    }
    
    func saveMain() throws {
        var error: Error?
        container.viewContext.performAndWait {
            do {
                try container.viewContext.save()
            } catch let err {
                error = err
            }
        }
        if let error = error {
            throw error
        }
    }
    
    func filter<Entity: Sidable>(saved: [Entity], new: [Entity]) -> FilterOutput<Entity> {
        let toDelete = saved.filter { savedItem in !new.contains(where: { $0.sid == savedItem.sid })}
        let toSave = new.filter { newItem in !saved.contains(where: { $0.sid == newItem.sid })}
        
        return FilterOutput(toDelete: toDelete, toSave: toSave)
    }
}
