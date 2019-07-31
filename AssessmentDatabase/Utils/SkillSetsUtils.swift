import Foundation
import CoreData

public class SkillSetsUtils: EntityUtils {
    public typealias EntityType = SkillSet
    public typealias EntityValueFields = SkillSetValueFields
    
    public var container: NSPersistentContainer
    
    public init(with container: NSPersistentContainer) {
        self.container = container
    }
    
    public func copyFields(from item: SkillSetValueFields, to entity: SkillSet) {
        fatalError()
    }
    
    public func save(item: SkillSetValueFields) {
        fatalError()
    }
    
    public func save(items: [SkillSetValueFields]) {
        fatalError()
    }
    
    public func delete(item: SkillSetValueFields) {
        fatalError()
    }
    
    public func delete(items: [SkillSetValueFields]) {
        fatalError()
    }
    
    public func update(item: SkillSetValueFields) {
        fatalError()
    }
    
    public func update(items: [SkillSetValueFields]) {
        fatalError()
    }
}
