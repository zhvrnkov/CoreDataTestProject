import Foundation
import CoreData

public class InstructorsUtils: EntityUtils {
    public typealias EntityType = Instructor
    public typealias EntityValueFields = InstructorFields
    
    public var container: NSPersistentContainer
    public lazy var backgroundContext = container.newBackgroundContext()
    
    public init(with container: NSPersistentContainer) {
        self.container = container
    }
    
    public func copyFields(from item: InstructorFields, to entity: Instructor) {
        entity.sid = Int64(item.sid)
        #warning("Not fully implemented")
    }
    
    public func setRelations(of entity: Instructor, like item: InstructorFields) throws {
        #warning("Not implemented")
    }
    
    public func update(item: InstructorFields) {
        fatalError()
    }
    
    public func update(items: [InstructorFields]) {
        fatalError()
    }
}
