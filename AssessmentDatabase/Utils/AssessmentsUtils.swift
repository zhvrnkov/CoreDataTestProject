import Foundation
import CoreData

public class AssessmentsUtils: EntityUtilsMethods {
    public typealias EntityType = Assessment
    public typealias EntityValueFields = AssessmentFields
    
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
    
    var studentsUtils: StudentsUtils?
    var rubricsUtils: RubricsUtils?
    var instructorsUtils: InstructorsUtils?
    
    init(container: NSPersistentContainer) {
        self.container = container
    }
    
    public enum Errors: Error {
        case noUtils
        case badCasting
        
        case studentsNotFound
        case rubricNotFound
        case instructorNotFound
        case studentMicrotasksGradesNotFound
    }
}

extension AssessmentsUtils: EntityUtils {
    func copyFields(from item: AssessmentFields, to entity: Assessment) {
        entity.sid = Int64(item.sid)
        entity.schoolId = Int64(item.schoolId)
        entity.date = item.date as NSDate
        entity.isSynced = item.isSynced
    }
    
    func setRelations(
        from item: AssessmentFields,
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
        guard let utils = studentsUtils else {
            throw Errors.noUtils
        }
        let savedStudents = utils.get(whereSids: studentSids)
        if studentSids.count != savedStudents.count {
            throw Errors.studentsNotFound
        }
        guard let assessmentStudents = assessment.students?.allObjects as? [Student],
            let contextStudents = savedStudents.map({ context.object(with: $0.objectID) }) as? [Student]
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
        guard let utils = rubricsUtils
            else { throw Errors.noUtils }
        guard let rubric = utils.get(whereSid: rubricSid),
            let contextRubric = context.object(with: rubric.objectID) as? Rubric
            else {
                throw Errors.rubricNotFound
        }
        contextRubric.addToAssessments(assessment)
        assessment.rubric = contextRubric
    }
    
    private func set(
        instructorSid: Int,
        of assessment: Assessment,
        in context: NSManagedObjectContext) throws
    {
        guard let utils = instructorsUtils
            else { throw Errors.noUtils }
        guard let instructor = utils.get(whereSid: instructorSid),
            let contextInstructor = context.object(with: instructor.objectID) as? Instructor
            else {
                throw Errors.instructorNotFound
        }
        contextInstructor.addToAssessments(assessment)
        assessment.instructor = contextInstructor
    }
}
