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
    
    public init(
        container: NSPersistentContainer
    ) {
        self.container = container
    }
    
    public func copyFields(from item: AssessmentFields, to entity: Assessment) {
        entity.sid = Int64(item.sid)
        entity.schoolId = Int64(item.schoolId)
        entity.date = item.date as NSDate
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
        } catch {
            throw error
        }
    }
    
    private func set(
        students: [StudentFields],
        of assessment: Assessment,
        in context: NSManagedObjectContext) throws
    {
        guard let utils = studentsUtils else {
            throw Errors.noUtils
        }
        let savedStudents = utils.get(whereSids: students.map { $0.sid })
        if students.count != savedStudents.count {
            throw Errors.studentsNotFound
        }
        guard let assessmentStudents = assessment.students.allObjects as? [Student],
            let contextStudents = savedStudents.map({ context.object(with: $0.objectID) }) as? [Student]
        else {
            throw Errors.badCasting
        }
        let filterOutput = filter(saved: assessmentStudents.map { $0.sid }, new: students.map { $0.sid })
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
        instructorSid: Int64,
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
    
    public enum Errors: Error {
        case noUtils
        case badCasting
        
        case studentsNotFound
        case rubricNotFound
        case instructorNotFound
        case studentMicrotasksGradesNotFound
    }
}
