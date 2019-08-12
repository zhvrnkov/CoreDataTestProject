import Foundation
import CoreData

public class StudentsUtils: EntityUtils {
    public typealias EntityType = Student
    public typealias EntityValueFields = StudentFields
    
    public var container: NSPersistentContainer
    public var backgroundContext: NSManagedObjectContext {
        return container.newBackgroundContext()
    }
    public var instructorsUtils: InstructorsUtils?
    
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
            try set(instructorSids: item.instructorSids, of: entity, in: context)
        } catch {
            throw error
        }
    }
    
    private func set(
        instructorSids: [Int64],
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
    
    public enum Errors: Error {
        case noUtils
        
        case assessmentsNotFound
        case instructorsNotFound
        case microtaskGradesNotFound
    }
}
