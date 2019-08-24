//
//  EntityUtils.swift
//  AssessmentDatabase
//
//  Created by Vlad Zhavoronkov  on 7/22/19.
//  Copyright © 2019 Bytepace. All rights reserved.
//

import Foundation
import CoreData

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
    var backgroundContext: NSManagedObjectContext { get }
    
    static func copyFields(from item: Owner.EntityValueFields, to entity: EntityType)
    func setRelations(from item: Owner.EntityValueFields, of entity: EntityType, in context: NSManagedObjectContext) throws
    static func map(entity: EntityType) -> Owner.EntityValueFields
}

extension EntityUtilsRealization {
    static func map(entities: [EntityType]) -> [Owner.EntityValueFields] {
        return entities.map { Self.map(entity: $0) }
    }
}

extension EntityUtilsRealization {
    func _getAll() -> [Owner.EntityValueFields] {
        let request = NSFetchRequest<EntityType>(
            entityName: "\(EntityType.self)")
        var output: [Owner.EntityValueFields] = []
        let context = container.viewContext
        context.performAndWait {
            do {
                output = Self.map(entities: try context.fetch(request))
            } catch {
                fatalError(error.localizedDescription)
            }
        }
        return output
    }
    
    func _asyncGetAll(_ completion: @escaping (Result<[Owner.EntityValueFields], Error>) -> Void) {
        let request = NSFetchRequest<EntityType>(
            entityName: "\(EntityType.self)"
        )
        let context = container.viewContext
        context.perform {
            do {
                completion(.success(try Self.map(entities: context.fetch(request))))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func _get(where predicate: Predicate) -> [Owner.EntityValueFields] {
        let request = NSFetchRequest<EntityType>(entityName: "\(EntityType.self)")
        request.predicate = NSPredicate(format: predicate.format, argumentArray: predicate.arguments)
        var output: [Owner.EntityValueFields] = []
        let context = container.viewContext
        context.performAndWait {
            do {
                output = Self.map(entities: try context.fetch(request))
            } catch {
                fatalError(error.localizedDescription)
            }
        }
        return output
    }
    
    func _asyncGet(where predicate: Predicate, _ completeion: @escaping (Result<[Owner.EntityValueFields], Error>) -> Void) {
        let request = NSFetchRequest<EntityType>(entityName: "\(EntityType.self)")
        request.predicate = NSPredicate(format: predicate.format, argumentArray: predicate.arguments)
        let context = container.viewContext
        context.perform {
            do {
                completeion(.success(try Self.map(entities: context.fetch(request))))
            } catch {
                completeion(.failure(error))
            }
        }
    }
    
    func _get(whereSid sid: Int) -> Owner.EntityValueFields? {
        let predicate = Predicate(format: "sid==%d", arguments: [sid])
        let output = _get(where: predicate)
        assert(output.count <= 1)
        return output.first
    }
    
    func _asyncGet(whereSid sid: Int, _ completeion: @escaping (Result<Owner.EntityValueFields?, Error>) -> Void) {
        let predicate = Predicate(format: "sid==%d", arguments: [sid])
        _asyncGet(where: predicate) { result in
            switch result {
            case .success(let output):
                assert(output.count <= 1)
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
        var error: Error?
        let context = backgroundContext
        context.performAndWait {
            let entity = EntityType(context: context)
            Self.copyFields(from: item, to: entity)
            do {
                try Self.setRelations(from: item, of: entity, in: context)
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
    
    func _save(items: [Owner.EntityValueFields]) throws {
        var error: Error?
        let context = backgroundContext
        context.performAndWait {
            items.forEach { item in
                let entity = EntityType(context: context)
                Self.copyFields(from: item, to: entity)
                do {
                    try Self.setRelations(from: item, of: entity, in: context)
                } catch let err {
                    error = err
                }
            }
            if error == nil {
                do {
                    try context.save()
                    try _saveMain()
                } catch let err {
                    error = err
                }
            }
        }
        if let error = error {
            throw error
        }
    }
    
    func _delete(whereSids sids: [Int]) throws {
        var error: Error?
        let request = NSFetchRequest<EntityType>(entityName: "\(EntityType.self)")
        request.predicate = NSPredicate(format: "sid IN %@", argumentArray: [sids])
        let context = backgroundContext
        context.performAndWait {
            let entities = try! context.fetch(request)
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
    
    func _delete(whereSid sid: Int) throws {
        try _delete(whereSids: [sid])
    }
    
    func _update(whereSid sid: Int, like item: Owner.EntityValueFields) throws {
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
                try Self.setRelations(from: item, of: contextEntity, in: context)
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
    
    func _deleteAll() {
        let all = _getAll()
        try? _delete(whereSids: all.reduce([]) { $0 + [$1.sid] })
        try? _saveMain()
    }
    
    func _saveMain() throws {
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
    
    func _filter(saved: [Int], new: [Int]) -> FilterOutput {
        let toDelete = saved.filter { savedSid in !new.contains(savedSid)}
        let toSave = new.filter { newSid in !saved.contains(newSid)}
        
        return FilterOutput(toDelete: toDelete, toAdd: toSave)
    }
}
