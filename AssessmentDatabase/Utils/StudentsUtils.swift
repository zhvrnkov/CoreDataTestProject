import Foundation
import CoreData

public class StudentsUtils: EntityUtils {
    public typealias EntityType = Student
    public typealias EntityValueFields = StudentFields
    
    public var container: NSPersistentContainer
    public lazy var backgroundContext = container.newBackgroundContext()
    
    public var assessmentsUtils: AssessmentsUtils?
    public var instructorsUtils: InstructorsUtils?
    public var microtaskGradesUtils: StudentMicrotaskGradesUtils?
    
    public init(with container: NSPersistentContainer) {
        self.container = container
    }
    
    public func copyFields(from item: StudentFields, to entity: Student) {
        entity.sid = Int64(item.sid)
    }
    
    public func setRelations(of entity: Student, like item: StudentFields) throws {
        do {
            try set(assessments: item.assessments, of: entity)
            try set(instructors: item.instructors, of: entity)
            try set(microtaskGrades: item.microTaskGrades, of: entity)
        } catch {
            throw error
        }
    }
    
    private func set(assessments: [AssessmentFields], of student: Student) throws {
        guard !assessments.isEmpty else {
            return
        }
        guard let util = assessmentsUtils else {
            throw Errors.noUtils
        }
        let savedAssessments = util.get(whereSids: assessments.map { $0.sid })
        guard !savedAssessments.isEmpty,
            let backgroundContextAssessments = savedAssessments
                .map({ backgroundContext.object(with: $0.objectID) }) as? [Assessment]
        else {
            throw Errors.assessmentsNotFound
        }
        student.addToAssessments(NSSet(array: backgroundContextAssessments))
        backgroundContextAssessments.forEach {
            $0.addToStudents(student)
        }
    }
    
    private func set(instructors: [InstructorFields], of student: Student) throws {
        guard !instructors.isEmpty else {
            return
        }
        guard let util = instructorsUtils else {
            throw Errors.noUtils
        }
        let savedInstructors = util.get(whereSids: instructors.map { $0.sid })
        guard !savedInstructors.isEmpty,
            let backgroundContextInstructors = savedInstructors
                .map({ backgroundContext.object(with: $0.objectID) }) as? [Instructor]
        else {
            throw Errors.instructorsNotFound
        }
        student.addToInstructors(NSSet(array: backgroundContextInstructors))
        backgroundContextInstructors.forEach {
            $0.addToStudents(student)
        }
    }
    
    private func set(microtaskGrades: [StudentMicrotaskGradeFields], of student: Student) throws {
        guard !microtaskGrades.isEmpty else {
            return
        }
        guard let util = microtaskGradesUtils else {
            throw Errors.noUtils
        }
        let savedMicrotaskGrades = util.get(whereSids: microtaskGrades.map { $0.sid })
        guard !savedMicrotaskGrades.isEmpty,
            let backgroundContextMicrotaskGrades = savedMicrotaskGrades
                .map({ backgroundContext.object(with: $0.objectID) }) as? [StudentMicrotaskGrade]
        else {
            throw Errors.microtaskGradesNotFound
        }
        student.addToMicroTaskGrades(NSSet(array: backgroundContextMicrotaskGrades))
        backgroundContextMicrotaskGrades.forEach {
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
