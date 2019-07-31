import Foundation
import CoreData

public class RubricsUtils: EntityUtils {
    public typealias EntityType = Rubric
    
    public var persistentContainer: NSPersistentContainer
    
    public init(with container: NSPersistentContainer) {
        persistentContainer = container
    }
}
