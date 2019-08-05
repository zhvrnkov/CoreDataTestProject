import Foundation
import CoreData

public class InstructorsUtils: EntityUtils {
    public typealias EntityType = Instructor
    public typealias EntityValueFields = InstructorFields
    
    public var container: NSPersistentContainer
    public lazy var backgroundContext: NSManagedObjectContext = {
        let moc = container.newBackgroundContext()
        moc.mergePolicy = NSMergePolicy(merge: NSMergePolicyType.overwriteMergePolicyType)
        return moc
    }()
    
    public var assessmentsUtils: AssessmentsUtils?
    public var studentsUtils: StudentsUtils?
    
    public init(with container: NSPersistentContainer) {
        self.container = container
    }
    
    public func copyFields(from item: InstructorFields, to entity: Instructor) {
        entity.sid = Int64(item.sid)
        #warning("Not fully implemented")
    }
    
    public func setRelations(of entity: Instructor, like item: InstructorFields) throws {
        do {
            try set(assessments: item.assessments, of: entity)
            try set(students: item.students, of: entity)
        } catch {
            throw error
        }
    }
    
    private func set(assessments: [AssessmentFields], of instructor: Instructor) throws {
        guard !assessments.isEmpty else {
            return
        }
        guard let utils = assessmentsUtils else {
            throw Errors.noUtils
        }
        let savedAssessments = utils.get(whereSids: assessments.map { $0.sid })
        guard !savedAssessments.isEmpty,
            let backgroundContextAssessments = savedAssessments
                .map({ backgroundContext.object(with: $0.objectID) }) as? [Assessment]
        else {
            throw Errors.assessmentsNotFound
        }
        backgroundContextAssessments.forEach {
            instructor.addToAssessments($0)
            $0.instructor = instructor
        }
    }
    
    private func set(students: [StudentFields], of instructor: Instructor) throws {
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
        backgroundContextStudents.forEach {
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
