import Foundation
import CoreData

public class AssessmentsUtils: EntityUtils {
    public typealias EntityType = Assessment
    public typealias EntityValueFields = AssessmentFields
    
    public var container: NSPersistentContainer
    public var backgroundContext: NSManagedObjectContext {
        return container.newBackgroundContext()
    }
    
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
    
    public func setRelations(
        from item: AssessmentFields,
        of entity: Assessment,
        in context: NSManagedObjectContext) throws
    {
        do {
            try set(rubric: item.rubric, of: entity, in: context)
            try set(students: item.students, of: entity, in: context)
            try set(instructorSid: item.instructorSid, of: entity, in: context)
            try set(studentMicrotasksGrades: item.studentMicrotaskGrades, of: entity, in: context)
        } catch {
            throw error
        }
    }
    
    private func set(
        students: [StudentFields],
        of assessment: Assessment,
        in context: NSManagedObjectContext) throws
    {
        guard !students.isEmpty else {
            return
        }
        guard let utils = studentsUtils else {
            throw Errors.noUtils
        }
        let savedStudents = utils.get(whereSids: students.map { $0.sid })
        guard !savedStudents.isEmpty,
            let contextStudents = savedStudents
                .map({ context.object(with: $0.objectID) }) as? [Student]
        else {
            throw Errors.studentsNotFound
        }
//        assessment.students = NSSet(array: [])
        contextStudents.forEach {
            assessment.addToStudents($0)
            $0.addToAssessments(assessment)
        }
    }
    
    private func set(
        rubric: RubricFields,
        of assessment: Assessment,
        in context: NSManagedObjectContext) throws
    {
        guard let utils = rubricsUtils
            else { throw Errors.noUtils }
        guard let rubric = utils.get(whereSid: rubric.sid),
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
    
    private func set(
        studentMicrotasksGrades: [StudentMicrotaskGradeFields],
        of assessment: Assessment,
        in context: NSManagedObjectContext) throws
    {
        guard !studentMicrotasksGrades.isEmpty else {
            return
        }
        guard let utils = studentMicrotaskGradesUtils else {
            throw Errors.noUtils
        }
        let savedStudentMicrotasksGrades = utils
            .get(whereSids: studentMicrotasksGrades.map { $0.sid })
        guard !savedStudentMicrotasksGrades.isEmpty,
            let contextGrades = savedStudentMicrotasksGrades
                .map({ context.object(with: $0.objectID) }) as? [StudentMicrotaskGrade]
        else {
            throw Errors.studentMicrotasksGradesNotFound
        }
//        assessment.studentMicrotaskGrades = NSSet(array: [])
        contextGrades.forEach {
            assessment.addToStudentMicrotaskGrades($0)
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
