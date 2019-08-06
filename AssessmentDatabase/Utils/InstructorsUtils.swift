import Foundation
import CoreData

public class InstructorsUtils: EntityUtils {
    public typealias EntityType = Instructor
    public typealias EntityValueFields = InstructorFields
    
    public var container: NSPersistentContainer
    public var backgroundContext: NSManagedObjectContext {
        return container.newBackgroundContext()
    }
    
    public var assessmentsUtils: AssessmentsUtils?
    public var studentsUtils: StudentsUtils?
    
    public init(with container: NSPersistentContainer) {
        self.container = container
    }
    
    public func copyFields(from item: InstructorFields, to entity: Instructor) {
        entity.sid = Int64(item.sid)
        #warning("Not fully implemented")
    }
    
    public func setRelations(
        from item: InstructorFields,
        of entity: Instructor,
        in context: NSManagedObjectContext) throws
    {
        do {
            try set(assessments: item.assessments, of: entity, in: context)
            try set(students: item.students, of: entity, in: context)
        } catch {
            throw error
        }
    }
    
    private func set(
        assessments: [AssessmentFields],
        of instructor: Instructor,
        in context: NSManagedObjectContext) throws
    {
        guard !assessments.isEmpty else {
            return
        }
        guard let utils = assessmentsUtils else {
            throw Errors.noUtils
        }
        let savedAssessments = utils.get(whereSids: assessments.map { $0.sid })
        guard !savedAssessments.isEmpty,
            let contextAssessments = savedAssessments
                .map({ context.object(with: $0.objectID) }) as? [Assessment]
        else {
            throw Errors.assessmentsNotFound
        }
        contextAssessments.forEach {
            instructor.addToAssessments($0)
            $0.instructor = instructor
        }
    }
    
    private func set(
        students: [StudentFields],
        of instructor: Instructor,
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
        contextStudents.forEach {
            instructor.addToStudents($0)
            $0.addToInstructors(instructor)
        }
    }
    
    public enum Errors: Error {
        case noUtils
        
        case assessmentsNotFound
        case studentsNotFound
    }
}
