import Foundation
import CoreData

public class AssessmentsUtils
    <EntityValueFields: AssessmentFields>
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
    
    public func configure<T: StudentFields, U: RubricFields, V: InstructorFields>
        (studentUtils: StudentsUtils<T>, rubricUtils: RubricsUtils<U>, instructorUtils: InstructorsUtils<V>)
    {
        self.studentObjectIDsFetch = studentUtils.getObjectIds(whereSids:)
        self.rubricObjectIDFetch = rubricUtils.getObjectId(whereSid:)
        self.instructorObjectIDFetch = instructorUtils.getObjectId(whereSid:)
    }
    
    
    var container: NSPersistentContainer
    var queue: DispatchQueue = .global(qos: .userInitiated)
    
    var studentObjectIDsFetch: ObjectIDsFetch?
    var rubricObjectIDFetch: ObjectIDFetch?
    var instructorObjectIDFetch: ObjectIDFetch?
    
    public init(with container: NSPersistentContainer) {
        self.container = container
    }
    
    public enum Errors: Error {
        case noFetch
        case badCasting
        
        case studentsNotFound
        case rubricNotFound
        case instructorNotFound
        case studentMicrotasksGradesNotFound
    }
}

extension AssessmentsUtils: EntityUtilsRealization {
    typealias Owner = AssessmentsUtils
    typealias EntityType = Assessment
    
    static func map(entity: Assessment) -> EntityValueFields {
        let instructorSid = Int(entity.instructor?.sid ?? badSid)
        var rubric: EntityValueFields.RubricFieldsType = .bad
        if let r = entity.rubric {
            rubric = RubricsUtils.map(entity: r)
        }
        let microtaskGrades = (entity.studentMicrotaskGrades?.allObjects as? [StudentMicrotaskGrade]) ?? []
        let students = (entity.students?.allObjects as? [Student]) ?? []
        return EntityValueFields.init(
            sid: Int(entity.sid),
            isSynced: entity.isSynced,
            date: (entity.date ?? NSDate()) as Date,
            schoolId: Int(entity.schoolId),
            instructorSid: instructorSid,
            rubric: rubric,
            microTaskGradeSids: microtaskGrades.map { Int($0.sid) },
            students: StudentsUtils.map(entities: students))
    }
    
    static func copyFields(from item: EntityValueFields, to entity: Assessment) {
        entity.sid = Int64(item.sid)
        entity.schoolId = Int64(item.schoolId)
        entity.date = item.date as NSDate
        entity.isSynced = item.isSynced
    }
    
    func setRelations(
        from item: EntityValueFields,
        of entity: Assessment,
        in context: NSManagedObjectContext) throws
    {
        do {
            try set(rubricSid: item.rubricSid, of: entity, in: context)
            try set(studentSids: item.studentSids, of: entity, in: context)
            try set(instructorSid: item.instructorSid, of: entity, in: context)
        } catch {
            throw error
        }
    }
    
    private func set(
        studentSids: [Int],
        of assessment: Assessment,
        in context: NSManagedObjectContext) throws
    {
        guard let fetch = studentObjectIDsFetch else {
            throw Errors.noFetch
        }
        let ids = fetch(studentSids)
        if studentSids.count != ids.count {
            throw Errors.studentsNotFound
        }
        guard let assessmentStudents = assessment.students?.allObjects as? [Student],
            let contextStudents = ids.map({ context.object(with: $0) }) as? [Student]
            else {
                throw Errors.badCasting
        }
        let filterOutput = _filter(saved: assessmentStudents.map { Int($0.sid) }, new: studentSids)
        filterOutput.toAdd.forEach { sidToAdd in
            if let studentToAdd = contextStudents.first(where: { $0.sid == sidToAdd }) {
                assessment.addToStudents(studentToAdd)
            }
        }
        filterOutput.toDelete.forEach { sidToDelete in
            if let studentToDelete = assessmentStudents.first(where: { $0.sid == sidToDelete }) {
                assessment.removeFromStudents(studentToDelete)
            }
        }
    }
    
    private func set(
        rubricSid: Int,
        of assessment: Assessment,
        in context: NSManagedObjectContext) throws
    {
        guard let fetch = rubricObjectIDFetch
            else { throw Errors.noFetch }
        
        guard let id = fetch(rubricSid),
            let contextRubric = context.object(with: id) as? Rubric
            else {
                throw Errors.rubricNotFound
        }
        assessment.rubric = contextRubric
    }
    
    private func set(
        instructorSid: Int,
        of assessment: Assessment,
        in context: NSManagedObjectContext) throws
    {
        guard let fetch = instructorObjectIDFetch
            else { throw Errors.noFetch }
        
        guard let id = fetch(instructorSid),
            let contextInstructor = context.object(with: id) as? Instructor
            else {
                throw Errors.instructorNotFound
        }
        assessment.instructor = contextInstructor
    }
}
