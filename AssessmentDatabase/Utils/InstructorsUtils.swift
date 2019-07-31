import Foundation
import CoreData

public class InstructorsUtils: EntityUtils {
    public typealias EntityType = Instructor
    public typealias EntityValueFields = InstructorValueFields
    
    public var container: NSPersistentContainer
    
    public init(with container: NSPersistentContainer) {
        self.container = container
    }
    
    public func copyFields(from item: InstructorValueFields, to entity: Instructor) {
        fatalError()
    }
    
    public func save(item: InstructorValueFields) {
        fatalError()
    }
    
    public func save(items: [InstructorValueFields]) {
        fatalError()
    }
    
    public func delete(item: InstructorValueFields) {
        fatalError()
    }
    
    public func delete(items: [InstructorValueFields]) {
        fatalError()
    }
    
    public func update(item: InstructorValueFields) {
        fatalError()
    }
    
    public func update(items: [InstructorValueFields]) {
        fatalError()
    }
}
