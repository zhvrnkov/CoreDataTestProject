import Foundation
import CoreData

public class GradesUtils
    <EntityValueFields: GradeFields>
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

extension GradesUtils: EntityUtilsRealization {
    typealias Owner = GradesUtils
    typealias EntityType = Grade
    
    static func map(entity: Grade) -> EntityValueFields {
        return EntityValueFields.init(
            sid: Int(entity.sid),
            title: entity.title ?? dbError,
            passed: entity.passed,
            score: Int(entity.score),
            rubricSid: Int(entity.rubric?.sid ?? badSid))
    }
    
    static func copyFields(from item: EntityValueFields, to entity: Grade) {
        entity.sid = Int64(item.sid)
        entity.title = item.title
        entity.score = Int64(item.score)
        entity.passed = item.passed
    }
    
    func setRelations(
        from item: EntityValueFields,
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
