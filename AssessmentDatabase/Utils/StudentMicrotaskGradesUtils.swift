import Foundation
import CoreData

public class StudentMicrotaskGradesUtils: EntityUtils {
    public typealias EntityType = StudentMicrotaskGrade
    public typealias EntityValueFields = StudentMicrotaskGradeFields
    
    public var container: NSPersistentContainer
    public lazy var backgroundContext = container.newBackgroundContext()
    
    public var assessmentsUtils: AssessmentsUtils?
    public var gradesUtils: GradesUtils?
    public var studentsUtils: StudentsUtils?
    public var microtasksUtils: MicrotasksUtils?
    
    public init(with container: NSPersistentContainer) {
        self.container = container
    }
    
    public func copyFields(from item: StudentMicrotaskGradeFields, to entity: StudentMicrotaskGrade) {
        entity.sid = Int64(item.sid)
    }
    
    public func setRelations(of entity: StudentMicrotaskGrade, like item: StudentMicrotaskGradeFields) throws {
        do {
            try set(assessment: item.assessment, of: entity)
            try set(grade: item.grade, of: entity)
            try set(microTask: item.microTask, of: entity)
            try set(student: item.student, of: entity)
        } catch {
            throw error
        }
    }
    
    private func set(assessment: AssessmentFields, of entity: StudentMicrotaskGrade) throws {
        guard let utils = assessmentsUtils
            else { throw Errors.noUtils }
        
        guard let assessment = utils.get(whereSid: assessment.sid),
            let backgroundContextAssessment = backgroundContext.object(with: assessment.objectID) as? Assessment
        else {
            throw Errors.assessmentNotFound
        }
        entity.assessment = backgroundContextAssessment
        backgroundContextAssessment.addToStudentMicrotaskGrades(entity)
        
    }
    
    private func set(grade: GradeFields, of entity: StudentMicrotaskGrade) throws {
        guard let utils = gradesUtils
            else { throw Errors.noUtils }
        guard let grade = utils.get(whereSid: grade.sid),
            let backgroundContextGrade = backgroundContext.object(with: grade.objectID) as? Grade
        else {
            throw Errors.gradeNotFound
        }
        entity.grade = backgroundContextGrade
        backgroundContextGrade.addToStudentMicrotaskGrades(entity)
    }
    
    private func set(microTask: MicrotaskFields, of entity: StudentMicrotaskGrade) throws {
        guard let utils = microtasksUtils
            else { throw Errors.noUtils }
        guard let savedMicrotask = utils.get(whereSid: microTask.sid),
            let backgroundContextMicrotask = backgroundContext.object(with: savedMicrotask.objectID) as? Microtask
        else {
            throw Errors.microTaskNotFound
        }
        entity.microTask = backgroundContextMicrotask
        backgroundContextMicrotask.addToStudentMicroTaskGrades(entity)
    }
    
    private func set(student: StudentFields, of entity: StudentMicrotaskGrade) throws {
        guard let utils = studentsUtils
            else { throw Errors.noUtils }
        guard let student = utils.get(whereSid: student.sid),
            let backgroundContextStudent = backgroundContext.object(with: student.objectID) as? Student
        else {
            throw Errors.studentNotFound
        }
        entity.student = backgroundContextStudent
        backgroundContextStudent.addToMicroTaskGrades(entity)
    }
    
    public enum Errors: Error {
        case noUtils
        
        case assessmentNotFound
        case gradeNotFound
        case microTaskNotFound
        case studentNotFound
    }
}
