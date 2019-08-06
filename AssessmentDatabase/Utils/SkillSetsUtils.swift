import Foundation
import CoreData

public class SkillSetsUtils: EntityUtils {
    public typealias EntityType = SkillSet
    public typealias EntityValueFields = SkillSetFields
    
    public var container: NSPersistentContainer
    public var backgroundContext: NSManagedObjectContext {
        return container.newBackgroundContext()
    }
    
    public var rubricUtils: RubricsUtils?
    
    public init(with container: NSPersistentContainer) {
        self.container = container
    }
    
    public func copyFields(from item: SkillSetFields, to entity: SkillSet) {
        entity.sid = Int64(item.sid)
    }
    
    public func setRelations(
        from item: SkillSetFields,
        of entity: SkillSet,
        in context: NSManagedObjectContext) throws
    {
        do {
            try set(rubric: item.rubric, of: entity, in: context)
        } catch {
            throw error
        }
    }
    
    private func set(
        rubric: RubricFields,
        of skillSet: SkillSet,
        in context: NSManagedObjectContext) throws
    {
        guard let utils = rubricUtils else {
            throw Errors.noUtils
        }
        guard let savedRubric = utils.get(whereSid: rubric.sid),
            let contextRubric = context.object(with: savedRubric.objectID) as? Rubric
        else {
            throw Errors.rubricNotFound
        }
        contextRubric.addToSkillSets(skillSet)
        skillSet.rubric = contextRubric
    }
    
    public enum Errors: Error {
        case noUtils
        
        case rubricNotFound
    }
}
