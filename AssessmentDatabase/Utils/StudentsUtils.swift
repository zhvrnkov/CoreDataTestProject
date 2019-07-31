import Foundation
import CoreData

public class StudentsUtils: EntityUtils {
    public typealias EntityType = Student
    
    public var persistentContainer: NSPersistentContainer
    
    public init(with container: NSPersistentContainer) {
        persistentContainer = container
    }
}
