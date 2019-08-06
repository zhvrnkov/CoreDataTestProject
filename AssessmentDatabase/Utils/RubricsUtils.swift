import Foundation
import CoreData

public class RubricsUtils: EntityUtils {
    public typealias EntityType = Rubric
    public typealias EntityValueFields = RubricFields
    
    public var container: NSPersistentContainer
    public var backgroundContext: NSManagedObjectContext {
        return container.newBackgroundContext()
    }
    
    public var skillSetsUtils: SkillSetsUtils?
    
    public init(with container: NSPersistentContainer) {
        self.container = container
    }
    
    public func copyFields(from item: RubricFields, to entity: Rubric) {
        entity.sid = Int64(item.sid)
    }
    
    public func setRelations(
        from item: RubricFields,
        of entity: Rubric,
        in context: NSManagedObjectContext) throws
    {
        do {
            try set(skillSets: item.skillSets, of: entity, in: context)
        } catch {
            throw error
        }
    }
    
    private func set(
        skillSets: [SkillSetFields],
        of rubric: Rubric,
        in context: NSManagedObjectContext) throws
    {
        guard !skillSets.isEmpty else {
            return
        }
        guard let utils = skillSetsUtils
            else { throw Errors.noUtils }
        let savedSkillSets = utils.get(whereSids: skillSets.map { $0.sid })
        guard !savedSkillSets.isEmpty,
            let contextSkillSets = savedSkillSets
                .map({ context.object(with: $0.objectID )}) as? [SkillSet]
        else {
            throw Errors.skillSetsNotFound
        }
        contextSkillSets.forEach {
            rubric.addToSkillSets($0)
            $0.rubric = rubric
        }
    }
    
    public enum Errors: Error {
        case noUtils
        
        case skillSetsNotFound
    }
}
