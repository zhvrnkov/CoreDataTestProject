import Foundation
import CoreData

public class StudentsUtils: EntityUtilsMethods {
    public typealias EntityType = Student
    public typealias EntityValueFields = StudentFields
    
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
    var instructorsUtils: InstructorsUtils?
    
    init(with container: NSPersistentContainer) {
        self.container = container
    }
    
    public enum Errors: Error {
        case noUtils
        
        case assessmentsNotFound
        case instructorsNotFound
        case microtaskGradesNotFound
    }
}

extension StudentsUtils: EntityUtils {
    func copyFields(from item: StudentFields, to entity: Student) {
        entity.sid = Int64(item.sid)
        entity.name = item.name
        entity.email = item.email
        entity.logbookPass = item.logbookPass
    }
    
    func setRelations(
        from item: StudentFields,
        of entity: Student,
        in context: NSManagedObjectContext) throws
    {
        do {
            try set(instructorSids: item.instructorSids, of: entity, in: context)
        } catch {
            throw error
        }
    }
    
    private func set(
        instructorSids: [Int],
        of student: Student,
        in context: NSManagedObjectContext) throws
    {
        guard !instructorSids.isEmpty else {
            return
        }
        guard let util = instructorsUtils else {
            throw Errors.noUtils
        }
        let savedInstructors = util.get(whereSids: instructorSids)
        guard !savedInstructors.isEmpty,
            let contextInstructors = savedInstructors
                .map({ context.object(with: $0.objectID) }) as? [Instructor]
            else {
                throw Errors.instructorsNotFound
        }
        contextInstructors.forEach {
            student.addToInstructors($0)
            $0.addToStudents(student)
        }
    }
}
