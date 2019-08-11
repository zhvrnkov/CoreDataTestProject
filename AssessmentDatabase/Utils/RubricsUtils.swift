import Foundation
import CoreData

public class RubricsUtils: EntityUtils {
    public typealias EntityType = Rubric
    public typealias EntityValueFields = RubricFields
    
    public var container: NSPersistentContainer
    public var backgroundContext: NSManagedObjectContext {
        return container.newBackgroundContext()
    }
    
    public init(with container: NSPersistentContainer) {
        self.container = container
    }
    
    public func copyFields(from item: RubricFields, to entity: Rubric) {
        entity.sid = Int64(item.sid)
    }
    
    public func setRelations(
        from item: RubricFields,
        of entity: Rubric,
        in context: NSManagedObjectContext) throws
    {
        #warning("Nothing is here")
    }
    
    public enum Errors: Error {
        case noUtils
        
        case skillSetsNotFound
    }
}
