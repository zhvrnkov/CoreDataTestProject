import Foundation
import CoreData

public class MicrotasksUtils: EntityUtils {
    public typealias EntityType = Microtask
    public typealias EntityValueFields = MicrotaskFields
    
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
    
    var container: NSPersistentContainer
    var backgroundContext: NSManagedObjectContext {
        return container.newBackgroundContext()
    }
    
    var skillSetsUtils: SkillSetsUtils?
    
    init(with container: NSPersistentContainer) {
        self.container = container
    }
    
    public enum Errors: Error {
        case noUtils
        
        case skillSetNotFound
    }
}

extension MicrotasksUtils:  EntityUtilsRealization {
    func copyFields(from item: MicrotaskFields, to entity: Microtask) {
        entity.sid = Int64(item.sid)
        entity.isActive = item.isActive
        entity.weight = Int64(item.weight)
        entity.title = item.title
        entity.depiction = item.depiction
        entity.critical = Int64(item.critical)
    }
    
    func setRelations(
        from item: MicrotaskFields,
        of entity: Microtask,
        in context: NSManagedObjectContext) throws
    {
        do {
            try set(skillSetSid: item.skillSetSid, of: entity, in: context)
        } catch {
            throw error
        }
    }
    
    private func set(
        skillSetSid: Int,
        of microtask: Microtask,
        in context: NSManagedObjectContext) throws
    {
        guard let utils = skillSetsUtils else {
            throw Errors.noUtils
        }
        guard let savedSkillSet = utils.get(whereSid: skillSetSid),
            let contextSkillSets = context.object(with: savedSkillSet.objectID) as? SkillSet
            else {
                throw Errors.skillSetNotFound
        }
        contextSkillSets.addToMicroTasks(microtask)
        microtask.skillSet = contextSkillSets
    }
}
