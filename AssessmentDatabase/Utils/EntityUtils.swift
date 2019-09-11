//
//  EntityUtils.swift
//  AssessmentDatabase
//
//  Created by Vlad Zhavoronkov  on 7/22/19.
//  Copyright © 2019 Bytepace. All rights reserved.
//

import Foundation
import CoreData

typealias ObjectIDFetch = ((Int) -> NSManagedObjectID?)
typealias ObjectIDsFetch = (([Int]) -> [NSManagedObjectID])

let dbError = "Something happen with your local database. Place contact the support"
let badSid: Int64 = -1

public struct FilterOutput {
    let toDelete: [Int]
    let toAdd: [Int]
}

public protocol EntityUtils: class {
    associatedtype EntityValueFields: Sidable
    
    func getAll() -> [EntityValueFields]
    func asyncGetAll(_ completion: @escaping (Result<[EntityValueFields], Error>) -> Void)
    
    func get(where predicate: Predicate) -> [EntityValueFields]
    func asyncGet(where predicate: Predicate, _ completeion: @escaping (Result<[EntityValueFields], Error>) -> Void)
    
    func get(whereSid sid: Int) -> EntityValueFields?
    func asyncGet(whereSid sid: Int, _ completeion: @escaping (Result<EntityValueFields?, Error>) -> Void)
    
    func get(whereSids sids: [Int]) -> [EntityValueFields]
    func asyncGet(whereSids sids: [Int], _ completeion: @escaping (Result<[EntityValueFields], Error>) -> Void)
    
    func save(item: EntityValueFields) throws
    func save(items: [EntityValueFields]) throws
    
    func delete(whereSid sid: Int) throws
    func delete(whereSids sids: [Int]) throws
    
    func update(whereSid sid: Int, like item: EntityValueFields) throws
}

protocol EntityUtilsRealization: class {
    associatedtype Owner: EntityUtils
    associatedtype EntityType: NSManagedObject & DBSidable
    
    var container: NSPersistentContainer { get set }
    var queue: DispatchQueue { get }
    var backgroundContext: NSManagedObjectContext { get }
    
    func getObjectIds(whereSids: [Int]) -> [NSManagedObjectID]
    func setRelations(from item: Owner.EntityValueFields, of entity: EntityType, in context: NSManagedObjectContext) throws
    static func copyFields(from item: Owner.EntityValueFields, to entity: EntityType)
    static func map(entity: EntityType) -> Owner.EntityValueFields
}

extension EntityUtilsRealization {
    static func map(entities: [EntityType]) -> [Owner.EntityValueFields] {
        return entities.map { Self.map(entity: $0) }
    }
}

extension EntityUtilsRealization {
    var backgroundContext: NSManagedObjectContext {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.parent = container.viewContext
        return context
    }
    
    func getObjectIds(whereSids sids: [Int]) -> [NSManagedObjectID] {
        return queue.sync { () -> [NSManagedObjectID] in
            let request = NSFetchRequest<EntityType>(
                entityName: "\(EntityType.self)")
            request.predicate = NSPredicate(format: "sid IN %@", argumentArray: [sids])
            var output: [NSManagedObjectID] = []
            let context = container.viewContext
            context.performAndWait {
                do {
                    output = try context.fetch(request).map { $0.objectID }
                } catch {
                    print(#function, #file, #line, error)
                }
            }
            return output
        }
    }
    
    func getObjectId(whereSid sid: Int) -> NSManagedObjectID? {
        return getObjectIds(whereSids: [sid]).first
    }
    
    func _getAll() -> [Owner.EntityValueFields] {
        return queue.sync { () -> [Owner.EntityValueFields] in
            let request = NSFetchRequest<EntityType>(
                entityName: "\(EntityType.self)")
            var output: [Owner.EntityValueFields] = []
            let context = container.viewContext
            context.performAndWait {
                do {
                    output = Self.map(entities: try context.fetch(request))
                } catch {
                    print(#function, #file, #line, error)
                }
            }
            return output
        }
    }
    
    func _asyncGetAll(_ completion: @escaping (Result<[Owner.EntityValueFields], Error>) -> Void) {
        queue.async { [weak self] in
            let request = NSFetchRequest<EntityType>(
                entityName: "\(EntityType.self)"
            )
            let context = self?.container.viewContext
            context?.perform {
                do {
                    completion(.success(try Self.map(entities: context?.fetch(request) ?? [])))
                } catch {
                    completion(.failure(error))
                }
            }
        }
    }
    
    func _get(where predicate: Predicate) -> [Owner.EntityValueFields] {
        return queue.sync { () -> [Owner.EntityValueFields] in
            let request = NSFetchRequest<EntityType>(entityName: "\(EntityType.self)")
            request.predicate = NSPredicate(format: predicate.format, argumentArray: predicate.arguments)
            var output: [Owner.EntityValueFields] = []
            let context = container.viewContext
            context.performAndWait {
                do {
                    output = Self.map(entities: try context.fetch(request))
                } catch {
                    print(#function, #file, #line, error)
                }
            }
            return output
        }
    }
    
    func _asyncGet(where predicate: Predicate, _ completeion: @escaping (Result<[Owner.EntityValueFields], Error>) -> Void) {
        queue.async { [weak self] in
            let request = NSFetchRequest<EntityType>(entityName: "\(EntityType.self)")
            request.predicate = NSPredicate(format: predicate.format, argumentArray: predicate.arguments)
            let context = self?.container.viewContext
            context?.perform {
                do {
                    completeion(.success(try Self.map(entities: context?.fetch(request) ?? [])))
                } catch {
                    completeion(.failure(error))
                }
            }
        }
    }
    
    func _get(whereSid sid: Int) -> Owner.EntityValueFields? {
        let predicate = Predicate(format: "sid==%d", arguments: [sid])
        let output = _get(where: predicate)
        return output.first
    }
    
    func _asyncGet(whereSid sid: Int, _ completeion: @escaping (Result<Owner.EntityValueFields?, Error>) -> Void) {
        let predicate = Predicate(format: "sid==%d", arguments: [sid])
        _asyncGet(where: predicate) { result in
            switch result {
            case .success(let output):
                completeion(.success(output.first))
            case .failure(let error):
                completeion(.failure(error))
            }
        }
    }
    
    func _get(whereSids sids: [Int]) -> [Owner.EntityValueFields] {
        let predicate = Predicate(format: "sid IN %@", arguments: [sids])
        return _get(where: predicate)
    }
    
    func _asyncGet(whereSids sids: [Int], _ completeion: @escaping (Result<[Owner.EntityValueFields], Error>) -> Void) {
        let predicate = Predicate(format: "sid IN %@", arguments: [sids])
        _asyncGet(where: predicate, completeion)
    }

    func _save(item: Owner.EntityValueFields) throws {
        try queue.sync {
            var error: Error?
            let context = backgroundContext
            context.performAndWait {
                let entity = EntityType(context: context)
                Self.copyFields(from: item, to: entity)
                do {
                    try self.setRelations(from: item, of: entity, in: context)
                    try context.save()
                    try _saveMain()
                } catch let err {
                    error = err
                }
            }
            if let error = error {
                throw error
            }
        }
    }
    
    func _save(items: [Owner.EntityValueFields]) throws {
        try queue.sync {
            var error: Error?
            let context = backgroundContext
            context.performAndWait {
                items.forEach { item in
                    let entity = EntityType(context: context)
                    Self.copyFields(from: item, to: entity)
                    do {
                        try self.setRelations(from: item, of: entity, in: context)
                    } catch let err {
                        context.delete(entity)
                        error = err
                    }
                }
                do {
                    try context.save()
                    try _saveMain()
                } catch let err {
                    error = err
                }
            }
            if let error = error {
                throw error
            }
        }
    }
    
    func _delete(whereSids sids: [Int]) throws {
        try queue.sync {
            var error: Error?
            let request = NSFetchRequest<EntityType>(entityName: "\(EntityType.self)")
            request.predicate = NSPredicate(format: "sid IN %@", argumentArray: [sids])
            let context = backgroundContext
            context.performAndWait {
                let entities = try! context.fetch(request)
                if entities.count != sids.count {
                    error = EntityUtilsError.entityNotFound
                }
                entities.forEach { entity in
                    let contextEntity = context.object(with: entity.objectID)
                    context.delete(contextEntity)
                }
                do {
                    try context.save()
                    try _saveMain()
                } catch let err {
                    error = err
                }
            }
            if let error = error {
                throw error
            }
        }
    }
    
    func _delete(whereSid sid: Int) throws {
        try _delete(whereSids: [sid])
    }
    
    func _update(whereSid sid: Int, like item: Owner.EntityValueFields) throws {
        try queue.sync {
            var error: Error?
            let context = backgroundContext
            let request = NSFetchRequest<EntityType>(entityName: "\(EntityType.self)")
            request.predicate = NSPredicate(format: "sid==%d", argumentArray: [sid])
            context.performAndWait {
                guard let entity = try? context.fetch(request).first,
                    let contextEntity = context.object(with: entity.objectID) as? EntityType
                else {
                    error = EntityUtilsError.entityNotFound
                    return
                }
                Self.copyFields(from: item, to: contextEntity)
                do {
                    try self.setRelations(from: item, of: contextEntity, in: context)
                    try context.save()
                    try _saveMain()
                } catch let err {
                    error = err
                }
            }
            if let error = error {
                throw error
            }
        }
    }
    
    func _deleteAll() {
        let all = _getAll()
        try? _delete(whereSids: all.reduce([]) { $0 + [$1.sid] })
        try? _saveMain()
    }
    
    func _saveMain() throws {
        try queue.sync {
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
    }
    
    func _filter(saved: [Int], new: [Int]) -> FilterOutput {
        let toDelete = saved.filter { savedSid in !new.contains(savedSid)}
        let toSave = new.filter { newSid in !saved.contains(newSid)}
        
        return FilterOutput(toDelete: toDelete, toAdd: toSave)
    }
    
    func isEntityExists(sid: Int) -> Bool {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "\(EntityType.self)")
        fetchRequest.predicate = NSPredicate(format: "sid==%d", argumentArray: [sid])
        fetchRequest.includesSubentities = false
        
        var entitiesCount = 0
        do {
            entitiesCount = try container.viewContext.count(for: fetchRequest)
        } catch {
            print(#file, #line, "error executing fetch request: \(error)")
        }
        
        return entitiesCount > 0
    }
}
