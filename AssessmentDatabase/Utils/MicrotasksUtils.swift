import Foundation
import CoreData

public class MicrotasksUtils: EntityUtils {
    public typealias EntityType = Microtask
    public typealias EntityValueFields = MicrotaskValueFields
    
    public var container: NSPersistentContainer
    
    public init(with container: NSPersistentContainer) {
        self.container = container
    }
    
    public func copyFields(from item: MicrotaskValueFields, to entity: Microtask) {
        fatalError()
    }
    
    public func save(item: MicrotaskValueFields) {
        fatalError()
    }
    
    public func save(items: [MicrotaskValueFields]) {
        fatalError()
    }
    
    public func delete(item: MicrotaskValueFields) {
        fatalError()
    }
    
    public func delete(items: [MicrotaskValueFields]) {
        fatalError()
    }
    
    public func update(item: MicrotaskValueFields) {
        fatalError()
    }
    
    public func update(items: [MicrotaskValueFields]) {
        fatalError()
    }
}
