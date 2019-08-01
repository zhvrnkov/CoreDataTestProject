import Foundation
import CoreData

public class SkillSetsUtils: EntityUtils {
    public typealias EntityType = SkillSet
    public typealias EntityValueFields = SkillSetValueFields
    
    public var container: NSPersistentContainer
    public lazy var backgroundContext = container.newBackgroundContext()
    
    public init(with container: NSPersistentContainer) {
        self.container = container
    }
    
    public func copyFields(from item: SkillSetValueFields, to entity: SkillSet) {
        fatalError()
    }
    
    public func setRelations(of entity: SkillSet, like item: SkillSetValueFields) throws {
        fatalError()
    }
    
    public func update(item: SkillSetValueFields) {
        fatalError()
    }
    
    public func update(items: [SkillSetValueFields]) {
        fatalError()
    }
}
