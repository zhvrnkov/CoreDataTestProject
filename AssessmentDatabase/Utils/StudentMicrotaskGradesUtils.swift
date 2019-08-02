import Foundation
import CoreData

public class StudentMicrotaskGradesUtils: EntityUtils {
    public typealias EntityType = StudentMicrotaskGrade
    public typealias EntityValueFields = StudentMicrotaskGradeFields
    
    public var container: NSPersistentContainer
    public lazy var backgroundContext = container.newBackgroundContext()
    
    public init(with container: NSPersistentContainer) {
        self.container = container
    }
    
    public func copyFields(from item: StudentMicrotaskGradeFields, to entity: StudentMicrotaskGrade) {
        fatalError()
    }
    
    public func setRelations(of entity: StudentMicrotaskGrade, like item: StudentMicrotaskGradeFields) throws {
        fatalError()
    }
    
    public func update(item: StudentMicrotaskGradeFields) {
        fatalError()
    }
    
    public func update(items: [StudentMicrotaskGradeFields]) {
        fatalError()
    }
}
