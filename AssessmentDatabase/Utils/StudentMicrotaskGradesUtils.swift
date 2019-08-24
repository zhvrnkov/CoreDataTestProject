import Foundation
import CoreData

public class StudentMicrotaskGradesUtils
    <EntityValueFields: StudentMicrotaskGradeFields>:
    EntityUtils
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
    
    public var assessmentObjectIDFetch: ObjectIDFetch?
    public var gradeObjectIDFetch: ObjectIDFetch?
    public var studentObjectIDFetch: ObjectIDFetch?
    public var microtaskObjectIDFetch: ObjectIDFetch?
    
    public init(with container: NSPersistentContainer) {
        self.container = container
    }
    
    public enum Errors: Error {
        case noFetch
        
        case assessmentNotFound
        case gradeNotFound
        case microTaskNotFound
        case studentNotFound
    }
}

extension StudentMicrotaskGradesUtils: EntityUtilsRealization {
    typealias Owner = StudentMicrotaskGradesUtils
    typealias EntityType = StudentMicrotaskGrade
    
    static func map(
        entity: StudentMicrotaskGrade) -> EntityValueFields {
        return .init(
            sid: Int(entity.sid),
            lastUpdated: Int(entity.lastUpdated),
            passed: entity.passed,
            isSynced: entity.isSynced,
            assessmentSid: Int(entity.assessment?.sid ?? badSid),
            microTaskSid: Int(entity.microTask?.sid ?? badSid),
            studentSid: Int(entity.student?.sid ?? badSid),
            gradeSid: Int(entity.grade?.sid ?? badSid))
    }
    
    static func copyFields(from item: EntityValueFields, to entity: StudentMicrotaskGrade) {
        entity.sid = Int64(item.sid)
        entity.isSynced = item.isSynced
        entity.lastUpdated = Int64(item.lastUpdated)
        entity.passed = item.passed
    }
    
    func setRelations(
        from item: EntityValueFields,
        of entity: StudentMicrotaskGrade,
        in context: NSManagedObjectContext) throws {
        do {
            try set(assessmentSid: item.assessmentSid, of: entity, in: context)
            try set(gradeSid: item.gradeSid, of: entity, in: context)
            try set(microTaskSid: item.microTaskSid, of: entity, in: context)
            try set(studentSid: item.studentSid, of: entity, in: context)
        } catch {
            throw error
        }
    }
    
    private func set(
        assessmentSid: Int,
        of entity: StudentMicrotaskGrade,
        in context: NSManagedObjectContext) throws
    {
        guard let fetch = assessmentObjectIDFetch
            else { throw Errors.noFetch }
        
        guard let id = fetch(assessmentSid),
            let contextAssessment = context.object(with: id) as? Assessment
            else {
                throw Errors.assessmentNotFound
        }
        entity.assessment = contextAssessment
        contextAssessment.addToStudentMicrotaskGrades(entity)
        
    }
    
    private func set(
        gradeSid: Int,
        of entity: StudentMicrotaskGrade,
        in context: NSManagedObjectContext) throws
    {
        guard let fetch = gradeObjectIDFetch
            else { throw Errors.noFetch }
        
        guard let id = fetch(gradeSid),
            let contextGrade = context.object(with: id) as? Grade
            else {
                throw Errors.gradeNotFound
        }
        entity.grade = contextGrade
        contextGrade.addToStudentMicrotaskGrades(entity)
    }
    
    private func set(
        microTaskSid: Int,
        of entity: StudentMicrotaskGrade,
        in context: NSManagedObjectContext) throws
    {
        guard let fetch = microtaskObjectIDFetch
            else { throw Errors.noFetch }
        
        guard let id = fetch(microTaskSid),
            let contextMicrotask = context.object(with: id) as? Microtask
            else {
                throw Errors.microTaskNotFound
        }
        entity.microTask = contextMicrotask
        contextMicrotask.addToStudentMicroTaskGrades(entity)
    }
    
    private func set(
        studentSid: Int,
        of entity: StudentMicrotaskGrade,
        in context: NSManagedObjectContext) throws
    {
        guard let fetch = studentObjectIDFetch
            else { throw Errors.noFetch }
        
        guard let id = fetch(studentSid),
            let contextStudent = context.object(with: id) as? Student
            else {
                throw Errors.studentNotFound
        }
        entity.student = contextStudent
        contextStudent.addToMicroTaskGrades(entity)
    }
}
