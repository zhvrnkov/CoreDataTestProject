import Foundation
import CoreData

public class RubricsUtils: EntityUtils {
    public typealias EntityType = Rubric
    public typealias EntityValueFields = RubricFields
    
    public var container: NSPersistentContainer
    
    public init(with container: NSPersistentContainer) {
        self.container = container
    }
    
    public func copyFields(from item: RubricFields, to entity: Rubric) {
        fatalError()
    }
    
    public func save(item: RubricFields) {
        fatalError()
    }
    
    public func save(items: [RubricFields]) {
        fatalError()
    }
    
    public func delete(item: RubricFields) {
        fatalError()
    }
    
    public func delete(items: [RubricFields]) {
        fatalError()
    }
    
    public func update(item: RubricFields) {
        fatalError()
    }
    
    public func update(items: [RubricFields]) {
        fatalError()
    }
}
