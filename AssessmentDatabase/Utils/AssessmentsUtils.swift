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
        guard !students.isEmpty else {
            return
        }
        guard let utils = studentsUtils else {
            throw Errors.noUtils
        }
        let savedStudents = utils.get(whereSids: students.map { $0.sid })
        guard !savedStudents.isEmpty,
            let backgroundContextStudents = savedStudents
                .map({ backgroundContext.object(with: $0.objectID) }) as? [Student]
        else {
            throw Errors.studentsNotFound
        }
        assessment.addToStudents(NSSet(array: backgroundContextStudents))
        backgroundContextStudents.forEach {
            $0.addToAssessments(assessment)
        }
    }
    
    private func set(rubric: RubricFields, of assessment: Assessment) throws {
        guard let utils = rubricsUtils
            else { throw Errors.noUtils }
        guard let rubric = utils.get(whereSid: rubric.sid),
            let backgroundContextRubric = backgroundContext.object(with: rubric.objectID) as? Rubric
        else {
            throw Errors.rubricNotFound
        }
        backgroundContextRubric.addToAssessments(assessment)
        assessment.rubric = backgroundContextRubric
    }
    
    private func set(instructor: InstructorFields, of assessment: Assessment) throws {
        guard let utils = instructorsUtils
            else { throw Errors.noUtils }
        guard let instructor = utils.get(whereSid: instructor.sid),
            let backgroundContextInstructor = backgroundContext.object(with: instructor.objectID) as? Instructor
        else {
            throw Errors.instructorNotFound
        }
        backgroundContextInstructor.addToAssessments(assessment)
        assessment.instructor = backgroundContextInstructor
    }
    
    private func set(studentMicrotasksGrades: [StudentMicrotaskGradeFields], of assessment: Assessment) throws {
        guard !studentMicrotasksGrades.isEmpty else {
            return
        }
        guard let utils = studentMicrotaskGradesUtils else {
            throw Errors.noUtils
        }
        let savedStudentMicrotasksGrades = utils
            .get(whereSids: studentMicrotasksGrades.map { $0.sid })
        guard !savedStudentMicrotasksGrades.isEmpty,
            let backgroundContextGrades = savedStudentMicrotasksGrades
                .map({ backgroundContext.object(with: $0.objectID) }) as? [StudentMicrotaskGrade]
        else {
            throw Errors.studentMicrotasksGradesNotFound
        }
        assessment.addToStudentMicrotaskGrades(NSSet(array: backgroundContextGrades))
        backgroundContextGrades.forEach {
            $0.assessment = assessment
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
