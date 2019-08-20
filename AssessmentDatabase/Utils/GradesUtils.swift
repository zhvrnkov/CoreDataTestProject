import Foundation
import CoreData

public class GradesUtils: EntityUtilsMethods {
    public typealias EntityType = Grade
    public typealias EntityValueFields = GradeFields
    
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
    
    public enum Errors: Error {
        case noUtils

        case rubricNotFound
    }
    
    var container: NSPersistentContainer
    var backgroundContext: NSManagedObjectContext {
        return container.newBackgroundContext()
    }
    var rubricUtils: RubricsUtils?
    
    init(with container: NSPersistentContainer) {
        self.container = container
    }
}

extension GradesUtils: EntityUtils {
    public func copyFields(from item: GradeFields, to entity: Grade) {
        entity.sid = item.sid
        entity.title = item.title
        entity.score = item.score
        entity.passed = item.passed
    }
    
    public func setRelations(
        from item: GradeFields,
        of entity: Grade,
        in context: NSManagedObjectContext) throws
    {
        do {
            try set(rubricSid: item.rubricSid, of: entity, in: context)
        } catch {
            throw error
        }
    }
    
    private func set(
        rubricSid: Int, of grade: Grade, in context: NSManagedObjectContext) throws
    {
        guard let utils = rubricUtils else {
            throw Errors.noUtils
        }
        guard let rubric = utils.get(whereSid: rubricSid),
            let contextRubric = context.object(with: rubric.objectID) as? Rubric
        else {
            throw Errors.rubricNotFound
        }
        grade.rubric = contextRubric
        contextRubric.addToGrades(grade)
    }
}
