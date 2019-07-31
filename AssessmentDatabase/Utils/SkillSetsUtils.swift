import Foundation
import CoreData

public class SkillSetsUtils: EntityUtils {
    public typealias EntityType = SkillSet
    
    public var persistentContainer: NSPersistentContainer
    
    public init(with container: NSPersistentContainer) {
        persistentContainer = container
    }
}
