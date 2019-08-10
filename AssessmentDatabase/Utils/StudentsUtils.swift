import Foundation
import CoreData

public class StudentsUtils: EntityUtils {
    public typealias EntityType = Student
    public typealias EntityValueFields = StudentFields
    
    public var container: NSPersistentContainer
    public var backgroundContext: NSManagedObjectContext {
        return container.newBackgroundContext()
    }
    
    public var assessmentsUtils: AssessmentsUtils?
    public var instructorsUtils: InstructorsUtils?
    public var microtaskGradesUtils: StudentMicrotaskGradesUtils?
    
    public init(with container: NSPersistentContainer) {
        self.container = container
    }
    
    public func copyFields(from item: StudentFields, to entity: Student) {
        entity.sid = Int64(item.sid)
    }
    
    public func setRelations(
        from item: StudentFields,
        of entity: Student,
        in context: NSManagedObjectContext) throws
    {
        do {
            try set(assessmentSids: item.assessmentSids, of: entity, in: context)
            try set(instructorSids: item.instructorSids, of: entity, in: context)
            try set(microtaskGrades: item.microTaskGrades, of: entity, in: context)
        } catch {
            throw error
        }
    }
    
    private func set(
        assessmentSids: [Int],
        of student: Student,
        in context: NSManagedObjectContext) throws
    {
        guard !assessmentSids.isEmpty else {
            return
        }
        guard let util = assessmentsUtils else {
            throw Errors.noUtils
        }
        let savedAssessments = util.get(whereSids: assessmentSids)
        guard !savedAssessments.isEmpty,
            let contextAssessments = savedAssessments
                .map({ context.object(with: $0.objectID) }) as? [Assessment]
        else {
            throw Errors.assessmentsNotFound
        }
        contextAssessments.forEach {
            student.addToAssessments($0)
            $0.addToStudents(student)
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
    
    private func set(
        microtaskGrades: [StudentMicrotaskGradeFields],
        of student: Student,
        in context: NSManagedObjectContext) throws
    {
        guard !microtaskGrades.isEmpty else {
            return
        }
        guard let util = microtaskGradesUtils else {
            throw Errors.noUtils
        }
        let savedMicrotaskGrades = util.get(whereSids: microtaskGrades.map { $0.sid })
        guard !savedMicrotaskGrades.isEmpty,
            let contextMicrotaskGrades = savedMicrotaskGrades
                .map({ context.object(with: $0.objectID) }) as? [StudentMicrotaskGrade]
        else {
            throw Errors.microtaskGradesNotFound
        }
        contextMicrotaskGrades.forEach {
            student.addToMicroTaskGrades($0)
            $0.student = student
        }
    }
    
    public enum Errors: Error {
        case noUtils
        
        case assessmentsNotFound
        case instructorsNotFound
        case microtaskGradesNotFound
    }
}
