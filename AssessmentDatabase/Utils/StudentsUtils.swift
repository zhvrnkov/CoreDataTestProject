import Foundation
import CoreData

public class StudentsUtils: EntityUtils {
    public typealias EntityType = Student
    public typealias EntityValueFields = StudentFields
    
    public var container: NSPersistentContainer
    public lazy var backgroundContext = container.newBackgroundContext()
    
    public init(with container: NSPersistentContainer) {
        self.container = container
    }
    
    public func copyFields(from item: StudentFields, to entity: Student) {
        entity.sid = Int64(item.sid)
    }
    
    public func setRelations(of entity: Student, like item: StudentFields) throws {
        #warning("Nothing is implemented")
    }
    
    public func update(item: StudentFields) {
        fatalError()
    }
    
    public func update(items: [StudentFields]) {
        fatalError()
    }
}
