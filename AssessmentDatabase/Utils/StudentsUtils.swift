import Foundation
import CoreData

public class StudentsUtils: EntityUtils {
    public typealias EntityType = Student
    public typealias EntityValueFields = StudentFields
    
    public var container: NSPersistentContainer
    
    public init(with container: NSPersistentContainer) {
        self.container = container
    }
    
    public func copyFields(from item: StudentFields, to entity: Student) {
        fatalError()
    }
    
    public func save(item: StudentFields) {
        fatalError()
    }
    
    public func save(items: [StudentFields]) {
        fatalError()
    }
    
    public func delete(item: StudentFields) {
        fatalError()
    }
    
    public func delete(items: [StudentFields]) {
        fatalError()
    }
    
    public func update(item: StudentFields) {
        fatalError()
    }
    
    public func update(items: [StudentFields]) {
        fatalError()
    }
}
