import Foundation
import CoreData

public class SkillSetsUtils
    <EntityValueFields: SkillSetFields>
    : EntityUtils
{
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
    
    var container: NSPersistentContainer
    var backgroundContext: NSManagedObjectContext {
        return container.newBackgroundContext()
    }
    
    var rubricObjectIDFetch: ObjectIDFetch?
    
    init(with container: NSPersistentContainer) {
        self.container = container
    }
    
    public enum Errors: Error {
        case noFetch
        
        case rubricNotFound
    }
}

extension SkillSetsUtils: EntityUtilsRealization {
    typealias Owner = SkillSetsUtils
    typealias EntityType = SkillSet
    
    static func map(entity: SkillSet) -> EntityValueFields {
        let entityMicrotasks = (entity.microTasks?.allObjects as? [Microtask]) ?? []
        let microtasks: [EntityValueFields.MicrotaskFieldsType] = MicrotasksUtils.map(entities: entityMicrotasks)
        return EntityValueFields.init(
            sid: Int(entity.sid),
            rubricSid: Int(entity.rubric?.sid ?? badSid),
            isActive: entity.isActive,
            title: entity.title ?? dbError,
            weight: Int(entity.weight),
            microTasks: microtasks)
    }
    
    static func copyFields(from item: EntityValueFields, to entity: SkillSet) {
        entity.sid = Int64(item.sid)
        entity.title = item.title
        entity.weight = Int64(item.weight)
        entity.isActive = item.isActive
    }
    
    func setRelations(
        from item: EntityValueFields,
        of entity: SkillSet,
        in context: NSManagedObjectContext) throws
    {
        do {
            try set(rubricSid: item.rubricSid, of: entity, in: context)
        } catch {
            throw error
        }
    }
    
    private func set(
        rubricSid: Int,
        of skillSet: SkillSet,
        in context: NSManagedObjectContext) throws
    {
        guard let fetch = rubricObjectIDFetch else {
            throw Errors.noFetch
        }
        guard let id = fetch(rubricSid),
            let contextRubric = context.object(with: id) as? Rubric
            else {
                throw Errors.rubricNotFound
        }
        contextRubric.addToSkillSets(skillSet)
        skillSet.rubric = contextRubric
    }
}
