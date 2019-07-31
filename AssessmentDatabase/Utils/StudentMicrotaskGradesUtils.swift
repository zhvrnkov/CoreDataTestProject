import Foundation
import CoreData

public class StudentMicrotaskGradesUtils: EntityUtils {
    public typealias EntityType = StudentMicrotaskGrade
    
    public var persistentContainer: NSPersistentContainer
    
    public init(with container: NSPersistentContainer) {
        persistentContainer = container
    }
}
