import Foundation
import CoreData

public class InstructorsUtils: EntityUtils {
    public typealias EntityType = Instructor
    public typealias EntityValueFields = InstructorValueFields
    
    public var container: NSPersistentContainer
    public lazy var backgroundContext = container.newBackgroundContext()
    
    public init(with container: NSPersistentContainer) {
        self.container = container
    }
    
    public func copyFields(from item: InstructorValueFields, to entity: Instructor) {
        fatalError()
    }
    
    public func setRelations(of entity: Instructor, like item: InstructorValueFields) throws {
        fatalError()
    }
    
    public func update(item: InstructorValueFields) {
        fatalError()
    }
    
    public func update(items: [InstructorValueFields]) {
        fatalError()
    }
}
