import Foundation
import CoreData

public class AssessmentsUtils: EntityUtils {
    public typealias EntityType = Assessment
    public typealias EntityValueFields = AssessmentFields
    
    public var container: NSPersistentContainer
    public lazy var backgroundContext = container.newBackgroundContext()
    
    public var studentsUtils: StudentsUtils?
    public var rubricsUtils: RubricsUtils?
    public var instructorsUtils: InstructorsUtils?
    public var studentMicrotaskGradesUtils: StudentMicrotaskGradesUtils?
    
    public init(
        container: NSPersistentContainer
    ) {
        self.container = container
    }
    
    public func update(item: AssessmentFields) {
        fatalError()
    }
    
    public func update(items: [AssessmentFields]) {
        fatalError()
    }
    
    public func copyFields(from item: AssessmentFields, to entity: Assessment) {
        entity.sid = Int64(item.sid)
        entity.schoolId = Int64(item.schoolId)
        entity.date = item.date
    }
    
    public func setRelations(of entity: Assessment, like item: AssessmentFields) throws {
        do {
            try set(rubric: item.rubric, of: entity)
            try set(students: item.students, of: entity)
            try set(instructor: item.instructor, of: entity)
            try set(studentMicrotasksGrades: item.studentMicrotaskGrades, of: entity)
        } catch {
            throw error
        }
    }
    
    private func set(students: [StudentFields], of assessment: Assessment) throws {
        guard let savedStudents = studentsUtils?.get(whereSids: students.map { $0.sid }) else {
            throw Errors.noUtils
        }
        if !savedStudents.isEmpty {
            guard let backgroundContextStudents = savedStudents.map({ backgroundContext.object(with: $0.objectID) }) as? [Student]
            else {
                fatalError()
            }
            assessment.addToStudents(NSSet(array: backgroundContextStudents))
            backgroundContextStudents.forEach {
                $0.addToAssessments(assessment)
            }
        } else if !students.isEmpty {
            throw Errors.studentsNotFound
        }
    }
    
    private func set(rubric: RubricFields, of assessment: Assessment) throws {
        guard let rubric = rubricsUtils?.get(whereSid: rubric.sid),
            let backgroundContextRubric = backgroundContext.object(with: rubric.objectID) as? Rubric
        else {
            throw Errors.rubricNotFound
        }
        backgroundContextRubric.addToAssessments(assessment)
        assessment.rubric = backgroundContextRubric
    }
    
    private func set(instructor: InstructorFields, of assessment: Assessment) throws {
        guard let instructor = instructorsUtils?.get(whereSid: instructor.sid),
            let backgroundContextInstructor = backgroundContext.object(with: instructor.objectID) as? Instructor
        else {
            throw Errors.instructorNotFound
        }
        backgroundContextInstructor.addToAssessments(assessment)
        assessment.instructor = backgroundContextInstructor
    }
    
    private func set(studentMicrotasksGrades: [StudentMicrotaskGradeFields], of assessment: Assessment) throws {
        guard let savedStudentMicrotasksGrades = studentMicrotaskGradesUtils?.get(whereSids: studentMicrotasksGrades.map { $0.sid }) else {
            throw Errors.noUtils
        }
        if !savedStudentMicrotasksGrades.isEmpty {
            guard let backgroundContextGrades = savedStudentMicrotasksGrades.map({ backgroundContext.object(with: $0.objectID) }) as? [StudentMicrotaskGrade]
            else {
                fatalError()
            }
            print(backgroundContextGrades)
            assessment.addToStudentMicrotaskGrades(NSSet(array: backgroundContextGrades))
            backgroundContextGrades.forEach {
                $0.assessment = assessment
            }
        } else if !studentMicrotasksGrades.isEmpty {
            throw Errors.studentMicrotasksGradesNotFound
        }
    }
    
    public enum Errors: Error {
        case noUtils
        
        case studentsNotFound
        case rubricNotFound
        case instructorNotFound
        case studentMicrotasksGradesNotFound
    }
}
