import Foundation
import CoreData

public class AssessmentsUtils: EntityUtils {
    public typealias EntityType = Assessment
    public typealias EntityValueFields = AssessmentFields
    
    public var container: NSPersistentContainer
    public lazy var backgroundContext = container.newBackgroundContext()
    
    public var studentsUtils: StudentsUtils
    public var rubricsUtils: RubricsUtils
    
    public init(
        container: NSPersistentContainer,
        studentsUtils: StudentsUtils,
        rubricsUtils: RubricsUtils
    ) {
        self.container = container
        self.studentsUtils = studentsUtils
        self.rubricsUtils = rubricsUtils
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
        let savedStudents = studentsUtils.get(whereSids: students.map { $0.sid })
        if !savedStudents.isEmpty {
            assessment.addToStudents(NSSet(array: savedStudents))
        } else {
            throw Errors.studentsNotFound
        }
    }
    
    private func set(rubric: RubricFields, of assessment: Assessment) throws {
        guard let rubric = rubricsUtils.get(whereSid: rubric.sid),
            let backgroundContextRubric = backgroundContext.object(with: rubric.objectID) as? Rubric
        else {
            throw Errors.rubricNotFound
        }
        backgroundContextRubric.addToAssessments(assessment)
        assessment.rubric = backgroundContextRubric
    }
    
    public enum Errors: Error {
        case studentsNotFound
        case rubricNotFound
    }
}
