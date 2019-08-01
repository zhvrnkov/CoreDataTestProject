import Foundation
import CoreData

public class StudentMicrotaskGradesUtils: EntityUtils {
    public typealias EntityType = StudentMicrotaskGrade
    public typealias EntityValueFields = StudentMicrotaskGradeValueFields
    
    public var container: NSPersistentContainer
    public lazy var backgroundContext = container.newBackgroundContext()
    
    public init(with container: NSPersistentContainer) {
        self.container = container
    }
    
    public func copyFields(from item: StudentMicrotaskGradeValueFields, to entity: StudentMicrotaskGrade) {
        fatalError()
    }
    
    public func setRelations(of entity: StudentMicrotaskGrade, like item: StudentMicrotaskGradeValueFields) throws {
        fatalError()
    }
    
    public func update(item: StudentMicrotaskGradeValueFields) {
        fatalError()
    }
    
    public func update(items: [StudentMicrotaskGradeValueFields]) {
        fatalError()
    }
}
