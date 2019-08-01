import Foundation
import CoreData

public class GradesUtils: EntityUtils {
    public typealias EntityType = Grade
    public typealias EntityValueFields = GradeFields
    
    public var container: NSPersistentContainer
    public lazy var backgroundContext = container.newBackgroundContext()
    
    public init(with container: NSPersistentContainer) {
        self.container = container
    }
    
    public func copyFields(from item: GradeFields, to entity: Grade) {
        entity.sid = Int64(item.sid)
        entity.title = item.title
    }
    
    public func setRelations(of entity: Grade, like item: GradeFields) throws {
        #warning("Nothing is implemented")
    }
}
