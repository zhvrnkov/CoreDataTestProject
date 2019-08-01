import Foundation
import CoreData

public class AssessmentsUtils: EntityUtils {
    public typealias EntityType = Assessment
    public typealias EntityValueFields = AssessmentFields
    
    public var container: NSPersistentContainer
    public lazy var backgroundContext = container.newBackgroundContext()
    
    public init(with container: NSPersistentContainer) {
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
    
    public func setRelations(
        of assessment: Assessment,
        like fields: AssessmentFields
    ) throws {
        do {
            try set(rubric: fields.rubric, of: assessment)
            try set(students: fields.students, of: assessment)
        } catch {
            throw error
        }
    }
    
    private func set(students: [StudentFields], of assessment: Assessment) throws {
        let savedStudents = DatabaseManager.shared.students.get(whereSids: students.map { $0.sid })
        if !savedStudents.isEmpty {
            assessment.addToStudents(NSSet(array: savedStudents))
        } else {
            throw Errors.studentsNotFound
        }
    }
    
    private func set(rubric: RubricFields, of assessment: Assessment) throws {
        guard let rubric = DatabaseManager.shared.rubrics.get(whereSid: rubric.sid)
        else {
            throw Errors.rubricNotFound
        }
        assessment.rubric = rubric
    }
    
    public enum Errors: Error {
        case studentsNotFound
        case rubricNotFound
    }
}
