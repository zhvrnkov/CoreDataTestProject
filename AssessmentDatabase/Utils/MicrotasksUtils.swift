import Foundation
import CoreData

public class MicrotasksUtils: EntityUtils {
    public typealias EntityType = Microtask
    public typealias EntityValueFields = MicrotaskFields
    
    public var container: NSPersistentContainer
    public lazy var backgroundContext = container.newBackgroundContext()
    
    public var skillSetsUtils: SkillSetsUtils?
    
    public init(with container: NSPersistentContainer) {
        self.container = container
    }
    
    public func copyFields(from item: MicrotaskFields, to entity: Microtask) {
        entity.sid = Int64(item.sid)
    }
    
    public func setRelations(of entity: Microtask, like item: MicrotaskFields) throws {
        do {
            try set(skillSet: item.skillSet, of: entity)
        } catch {
            throw error
        }
    }
    
    private func set(skillSet: SkillSetFields, of microtask: Microtask) throws {
        guard let utils = skillSetsUtils else {
            throw Errors.noUtils
        }
        guard let savedSkillSet = utils.get(whereSid: skillSet.sid),
            let backgroundContextSkillSet = backgroundContext.object(with: savedSkillSet.objectID) as? SkillSet
        else {
            throw Errors.skillSetNotFound
        }
        backgroundContextSkillSet.addToMicroTasks(microtask)
        microtask.skillSet = backgroundContextSkillSet
    }
    
    public enum Errors: Error {
        case noUtils
        
        case skillSetNotFound
    }
}
