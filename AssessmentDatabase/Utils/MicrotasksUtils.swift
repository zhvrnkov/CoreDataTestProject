import Foundation
import CoreData

public class MicrotasksUtils: EntityUtils {
    public typealias EntityType = Microtask
    public typealias EntityValueFields = MicrotaskValueFields
    
    public var container: NSPersistentContainer
    public lazy var backgroundContext = container.newBackgroundContext()
    
    public init(with container: NSPersistentContainer) {
        self.container = container
    }
    
    public func copyFields(from item: MicrotaskValueFields, to entity: Microtask) {
        fatalError()
    }
    
    public func setRelations(of entity: Microtask, like item: MicrotaskValueFields) throws {
        fatalError()
    }
    
    public func update(item: MicrotaskValueFields) {
        fatalError()
    }
    
    public func update(items: [MicrotaskValueFields]) {
        fatalError()
    }
}
