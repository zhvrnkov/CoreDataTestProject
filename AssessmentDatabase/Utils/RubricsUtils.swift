import Foundation
import CoreData

public class RubricsUtils: EntityUtilsMethods {
    public typealias EntityType = Rubric
    public typealias EntityValueFields = RubricFields
    
    public func getAll() -> [EntityType] {
        return _getAll()
    }
    
    public func asyncGetAll(_ completion: @escaping (Result<[EntityType], Error>) -> Void) {
        _asyncGetAll(completion)
    }
    
    public func get(where predicate: Predicate) -> [EntityType] {
        return _get(where: predicate)
    }
    
    public func asyncGet(where predicate: Predicate, _ completeion: @escaping (Result<[EntityType], Error>) -> Void) {
        _asyncGet(where: predicate, completeion)
    }
    
    public func get(whereSid sid: Int) -> EntityType? {
        return _get(whereSid: sid)
    }
    
    public func asyncGet(whereSid sid: Int, _ completeion: @escaping (Result<EntityType?, Error>) -> Void) {
        return _asyncGet(whereSid: sid, completeion)
    }
    
    public func get(whereSids sids: [Int]) -> [EntityType] {
        return _get(whereSids: sids)
    }
    
    public func asyncGet(whereSids sids: [Int], _ completeion: @escaping (Result<[EntityType], Error>) -> Void) {
        return _asyncGet(whereSids: sids, completeion)
    }
    
    public func save(item: EntityValueFields) throws {
        try _save(item: item)
    }
    public func save(items: [EntityValueFields]) throws {
        try _save(items: items)
    }
    
    public func delete(whereSid sid: Int) throws {
        try _delete(whereSid: sid)
    }
    public func delete(whereSids sids: [Int]) throws {
        try _delete(whereSids: sids)
    }
    
    public func update(whereSid sid: Int, like item: EntityValueFields) throws {
        try _update(whereSid: sid, like: item)
    }
    
    public var container: NSPersistentContainer
    public var backgroundContext: NSManagedObjectContext {
        return container.newBackgroundContext()
    }
    
    init(with container: NSPersistentContainer) {
        self.container = container
    }
    
    public enum Errors: Error {
        case noUtils
        
        case skillSetsNotFound
    }
}

extension RubricsUtils: EntityUtils {
    func copyFields(from item: RubricFields, to entity: Rubric) {
        entity.sid = Int64(item.sid)
        entity.title = item.title
        entity.weight = Int64(item.weight)
        entity.lastUpdate = Int64(item.lastUpdate)
        entity.isActive = item.isActive
    }
    
    func setRelations(
        from item: RubricFields,
        of entity: Rubric,
        in context: NSManagedObjectContext) throws
    {}
}
