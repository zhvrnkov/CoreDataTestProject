import Foundation
import CoreData

public class GradesUtils: EntityUtils {
    public typealias EntityType = Grade
    
    public var persistentContainer: NSPersistentContainer
    
    public init(with container: NSPersistentContainer) {
        persistentContainer = container
    }
}
