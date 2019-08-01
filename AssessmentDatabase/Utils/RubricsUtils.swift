import Foundation
import CoreData

public class RubricsUtils: EntityUtils {
    public typealias EntityType = Rubric
    public typealias EntityValueFields = RubricFields
    
    public var container: NSPersistentContainer
    public lazy var backgroundContext = container.newBackgroundContext()
    
    public init(with container: NSPersistentContainer) {
        self.container = container
    }
    
    public func copyFields(from item: RubricFields, to entity: Rubric) {
        entity.sid = Int64(item.sid)
    }
    
    public func setRelations(of entity: Rubric, like item: RubricFields) throws {
        #warning("Nothing is implemented")
    }
    
    public func update(item: RubricFields) {
        fatalError()
    }
    
    public func update(items: [RubricFields]) {
        fatalError()
    }
}
