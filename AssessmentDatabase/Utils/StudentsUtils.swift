import Foundation
import CoreData

public class StudentsUtils
    <EntityValueFields: StudentFields>
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
    
    public func configure<T: InstructorFields>(instructorUtils: InstructorsUtils<T>) {
        self.instructorObjectIDsFetch = instructorUtils.getObjectIds(whereSids:)
    }
    
    var container: NSPersistentContainer
    var backgroundContext: NSManagedObjectContext {
        return container.newBackgroundContext()
    }
    var queue: DispatchQueue = .global(qos: .userInitiated)
    var instructorObjectIDsFetch: ObjectIDsFetch?
    
    public init(with container: NSPersistentContainer) {
        self.container = container
    }
    
    public enum Errors: Error {
        case noFetch
        
        case assessmentsNotFound
        case instructorsNotFound
        case microtaskGradesNotFound
    }
}

extension StudentsUtils: EntityUtilsRealization {
    typealias Owner = StudentsUtils
    typealias EntityType = Student
    
    static func map(entity: Student) -> EntityValueFields {
        let assessments = (entity.assessments?.allObjects as? [Assessment]) ?? []
        let instructors = (entity.instructors?.allObjects as? [Instructor]) ?? []
        let entityMicrotaskGrades = (entity.microTaskGrades?.allObjects as? [StudentMicrotaskGrade]) ?? []
        let microtaskGrades: [EntityValueFields.StudentMicrotaskGradeFieldsType] = StudentMicrotaskGradesUtils.map(entities: entityMicrotaskGrades)
        return EntityValueFields.init(
            sid: Int(entity.sid),
            email: entity.email ?? dbError,
            logbookPass: entity.logbookPass ?? dbError,
            name: entity.name ?? dbError,
            assessmentSids: assessments.map { Int($0.sid) },
            instructorSids: instructors.map { Int($0.sid) },
            microTaskGrades: microtaskGrades)
    }
    
    static func copyFields(from item: EntityValueFields, to entity: Student) {
        entity.sid = Int64(item.sid)
        entity.name = item.name
        entity.email = item.email
        entity.logbookPass = item.logbookPass
    }
    
    func setRelations(
        from item: EntityValueFields,
        of entity: Student,
        in context: NSManagedObjectContext) throws
    {
        do {
            try set(instructorSids: item.instructorSids, of: entity, in: context)
        } catch {
            throw error
        }
    }
    
    #warning("what about clear student's instructor here?")
    private func set(
        instructorSids: [Int],
        of student: Student,
        in context: NSManagedObjectContext) throws
    {
        guard !instructorSids.isEmpty else {
            return
        }
        guard let fetch = instructorObjectIDsFetch else {
            throw Errors.noFetch
        }
        let ids = fetch(instructorSids)
        guard !ids.isEmpty,
            let contextInstructors = ids
                .map({ context.object(with: $0) }) as? [Instructor]
            else {
                throw Errors.instructorsNotFound
        }
        contextInstructors.forEach {
            student.addToInstructors($0)
            $0.addToStudents(student)
        }
    }
}
