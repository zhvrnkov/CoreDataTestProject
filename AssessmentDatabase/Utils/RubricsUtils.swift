import Foundation
import CoreData

public class RubricsUtils<EntityValueFields: RubricFields>: EntityUtils {
    public func getAll() -> [EntityValueFields] {
        return _getAll()
    }
    
    public func asyncGetAll(_ completion: @escaping (Result<[EntityValueFields], Error>) -> Void) {
        _asyncGetAll(completion)
    }
    
    public func get(where predicate: Predicate) -> [EntityValueFields] {
        return _get(where: predicate)
    }
    
    public func asyncGet(where predicate: Predicate, _ completeion: @escaping (Result<[EntityValueFields], Error>) -> Void) {
        _asyncGet(where: predicate, completeion)
    }
    
    public func get(whereSid sid: Int) -> EntityValueFields? {
        return _get(whereSid: sid)
    }
    
    public func asyncGet(whereSid sid: Int, _ completeion: @escaping (Result<EntityValueFields?, Error>) -> Void) {
        return _asyncGet(whereSid: sid, completeion)
    }
    
    public func get(whereSids sids: [Int]) -> [EntityValueFields] {
        return _get(whereSids: sids)
    }
    
    public func asyncGet(whereSids sids: [Int], _ completeion: @escaping (Result<[EntityValueFields], Error>) -> Void) {
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

extension RubricsUtils: EntityUtilsRealization {
    typealias Owner = RubricsUtils
    typealias EntityType = Rubric
    
    static func map(entity: Rubric) -> EntityValueFields {
        let skillSets = (entity.skillSets?.allObjects as? [SkillSet]) ?? []
        let grades = (entity.grades?.allObjects as? [Grade]) ?? []
        return EntityValueFields.init(
            sid: Int(entity.sid),
            title: entity.title ?? dbError,
            lastUpdate: Int(entity.lastUpdate),
            weight: Int(entity.weight),
            isActive: entity.isActive,
            skillSets: SkillSetsUtils.map(entities: skillSets),
            grades: GradesUtils.map(entities: grades))
    }
    
    static func copyFields(from item: EntityValueFields, to entity: Rubric) {
        entity.sid = Int64(item.sid)
        entity.title = item.title
        entity.weight = Int64(item.weight)
        entity.lastUpdate = Int64(item.lastUpdate)
        entity.isActive = item.isActive
    }
    
    static func setRelations(from item: EntityValueFields, of entity: Rubric, in context: NSManagedObjectContext) throws {}
}
