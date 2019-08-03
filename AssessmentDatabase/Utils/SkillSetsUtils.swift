import Foundation
import CoreData

public class SkillSetsUtils: EntityUtils {
    public typealias EntityType = SkillSet
    public typealias EntityValueFields = SkillSetFields
    
    public var container: NSPersistentContainer
    public lazy var backgroundContext = container.newBackgroundContext()
    
    public var rubricUtils: RubricsUtils?
    
    public init(with container: NSPersistentContainer) {
        self.container = container
    }
    
    public func copyFields(from item: SkillSetFields, to entity: SkillSet) {
        entity.sid = Int64(item.sid)
    }
    
    public func setRelations(of entity: SkillSet, like item: SkillSetFields) throws {
        do {
            try set(rubric: item.rubric, of: entity)
        } catch {
            throw error
        }
    }
    
    private func set(rubric: RubricFields, of skillSet: SkillSet) throws {
        guard let utils = rubricUtils else {
            throw Errors.noUtils
        }
        guard let savedRubric = utils.get(whereSid: rubric.sid),
            let backgroundContextRubric = backgroundContext.object(with: savedRubric.objectID) as? Rubric
        else {
            throw Errors.rubricNotFound
        }
        backgroundContextRubric.addToSkillSets(skillSet)
        skillSet.rubric = backgroundContextRubric
    }
    
    public enum Errors: Error {
        case noUtils
        
        case rubricNotFound
    }
}
