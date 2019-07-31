import Foundation
import CoreData

public class MicrotasksUtils: EntityUtils {
    public typealias EntityType = Microtask
    
    public var persistentContainer: NSPersistentContainer
    
    public init(with container: NSPersistentContainer) {
        persistentContainer = container
    }
}
