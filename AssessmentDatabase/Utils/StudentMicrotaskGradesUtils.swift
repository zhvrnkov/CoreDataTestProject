import Foundation
import CoreData

public class StudentMicrotaskGradesUtils: EntityUtils {
    public typealias EntityType = StudentMicrotaskGrade
    public typealias EntityValueFields = StudentMicrotaskGradeValueFields
    
    public var container: NSPersistentContainer
    
    public init(with container: NSPersistentContainer) {
        self.container = container
    }
    
    public func copyFields(from item: StudentMicrotaskGradeValueFields, to entity: StudentMicrotaskGrade) {
        fatalError()
    }
    
    public func save(item: StudentMicrotaskGradeValueFields) {
        fatalError()
    }
    
    public func save(items: [StudentMicrotaskGradeValueFields]) {
        fatalError()
    }
    
    public func delete(item: StudentMicrotaskGradeValueFields) {
        fatalError()
    }
    
    public func delete(items: [StudentMicrotaskGradeValueFields]) {
        fatalError()
    }
    
    public func update(item: StudentMicrotaskGradeValueFields) {
        fatalError()
    }
    
    public func update(items: [StudentMicrotaskGradeValueFields]) {
        fatalError()
    }
}
