import Foundation
import CoreData

public class MicrotasksUtils: EntityUtils {
    public typealias EntityType = Microtask
    public typealias EntityValueFields = MicrotaskFields
    
    public var container: NSPersistentContainer
    public lazy var backgroundContext = container.newBackgroundContext()
    
    public init(with container: NSPersistentContainer) {
        self.container = container
    }
    
    public func copyFields(from item: MicrotaskFields, to entity: Microtask) {
        fatalError()
    }
    
    public func setRelations(of entity: Microtask, like item: MicrotaskFields) throws {
        fatalError()
    }
    
    public func update(item: MicrotaskFields) {
        fatalError()
    }
    
    public func update(items: [MicrotaskFields]) {
        fatalError()
    }
}
