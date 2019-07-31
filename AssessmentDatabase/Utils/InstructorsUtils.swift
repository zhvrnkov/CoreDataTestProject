import Foundation
import CoreData

public class InstructorsUtils: EntityUtils {
    public typealias EntityType = Instructor
    
    public var persistentContainer: NSPersistentContainer
    
    public init(with container: NSPersistentContainer) {
        persistentContainer = container
    }
}
