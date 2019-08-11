import Foundation
import CoreData

public class InstructorsUtils: EntityUtils {
    public typealias EntityType = Instructor
    public typealias EntityValueFields = InstructorFields
    
    public var container: NSPersistentContainer
    public var backgroundContext: NSManagedObjectContext {
        return container.newBackgroundContext()
    }
    
    public init(with container: NSPersistentContainer) {
        self.container = container
    }
    
    public func copyFields(from item: InstructorFields, to entity: Instructor) {
        entity.sid = Int64(item.sid)
    }
    
    public func setRelations(
        from item: InstructorFields,
        of entity: Instructor,
        in context: NSManagedObjectContext) throws
    {
        #warning("Nothing is here")
    }
    
    public enum Errors: Error {
        case noUtils
        
        case assessmentsNotFound
        case studentsNotFound
    }
}
