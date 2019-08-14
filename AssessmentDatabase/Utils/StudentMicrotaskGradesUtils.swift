import Foundation
import CoreData

public class StudentMicrotaskGradesUtils: EntityUtils {
    public typealias EntityType = StudentMicrotaskGrade
    public typealias EntityValueFields = StudentMicrotaskGradeFields
    
    public var container: NSPersistentContainer
    public var backgroundContext: NSManagedObjectContext {
        return container.newBackgroundContext()
    }
    
    public var assessmentsUtils: AssessmentsUtils?
    public var gradesUtils: GradesUtils?
    public var studentsUtils: StudentsUtils?
    public var microtasksUtils: MicrotasksUtils?
    
    public init(with container: NSPersistentContainer) {
        self.container = container
    }
    
    public func copyFields(from item: StudentMicrotaskGradeFields, to entity: StudentMicrotaskGrade) {
        entity.sid = item.sid
        entity.isSynced = item.isSynced
        entity.lastUpdated = item.lastUpdated
        entity.passed = item.passed
    }
    
    public func setRelations(
        from item: StudentMicrotaskGradeFields,
        of entity: StudentMicrotaskGrade,
        in context: NSManagedObjectContext) throws
    {
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
        guard let utils = assessmentsUtils
            else { throw Errors.noUtils }
        
        guard let assessment = utils.get(whereSid: assessmentSid),
            let contextAssessment = context.object(with: assessment.objectID) as? Assessment
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
        guard let utils = gradesUtils
            else { throw Errors.noUtils }
        guard let grade = utils.get(whereSid: gradeSid),
            let contextGrade = context.object(with: grade.objectID) as? Grade
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
        guard let utils = microtasksUtils
            else { throw Errors.noUtils }
        guard let savedMicrotask = utils.get(whereSid: microTaskSid),
            let contextMicrotask = context.object(with: savedMicrotask.objectID) as? Microtask
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
        guard let utils = studentsUtils
            else { throw Errors.noUtils }
        guard let student = utils.get(whereSid: studentSid),
            let contextStudent = context.object(with: student.objectID) as? Student
        else {
            throw Errors.studentNotFound
        }
        entity.student = contextStudent
        contextStudent.addToMicroTaskGrades(entity)
    }
    
    public enum Errors: Error {
        case noUtils
        
        case assessmentNotFound
        case gradeNotFound
        case microTaskNotFound
        case studentNotFound
    }
}
