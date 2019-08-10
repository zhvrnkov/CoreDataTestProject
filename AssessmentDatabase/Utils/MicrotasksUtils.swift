import Foundation
import CoreData

public class MicrotasksUtils: EntityUtils {
    public typealias EntityType = Microtask
    public typealias EntityValueFields = MicrotaskFields
    
    public var container: NSPersistentContainer
    public var backgroundContext: NSManagedObjectContext {
        return container.newBackgroundContext()
    }
    
    public var skillSetsUtils: SkillSetsUtils?
    
    public init(with container: NSPersistentContainer) {
        self.container = container
    }
    
    public func copyFields(from item: MicrotaskFields, to entity: Microtask) {
        entity.sid = Int64(item.sid)
    }
    
    public func setRelations(
        from item: MicrotaskFields,
        of entity: Microtask,
        in context: NSManagedObjectContext) throws
    {
        do {
            try set(skillSetSid: item.skillSetSid, of: entity, in: context)
        } catch {
            throw error
        }
    }
    
    private func set(
        skillSetSid: Int,
        of microtask: Microtask,
        in context: NSManagedObjectContext) throws
    {
        guard let utils = skillSetsUtils else {
            throw Errors.noUtils
        }
        guard let savedSkillSet = utils.get(whereSid: skillSetSid),
            let contextSkillSets = context.object(with: savedSkillSet.objectID) as? SkillSet
        else {
            throw Errors.skillSetNotFound
        }
        contextSkillSets.addToMicroTasks(microtask)
        microtask.skillSet = contextSkillSets
    }
    
    public enum Errors: Error {
        case noUtils
        
        case skillSetNotFound
    }
}
