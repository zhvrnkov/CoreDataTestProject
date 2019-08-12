import Foundation
import CoreData

public class InstructorsUtils: EntityUtils {
    public typealias EntityType = Instructor
    public typealias EntityValueFields = InstructorFields
    
    public var container: NSPersistentContainer
    public var backgroundContext: NSManagedObjectContext {
        return container.newBackgroundContext()
    }
    
    public init(with container: NSPersistentContainer) {
        self.container = container
    }
    
    public func copyFields(from item: InstructorFields, to entity: Instructor) {
        entity.sid = Int64(item.sid)
        entity.loginUsername = item.loginUsername
        entity.firstName = item.firstName
        entity.lastName = item.lastName
        entity.avatar = item.avatar
        entity.email = item.email
        entity.phone = item.phone
        entity.phoneStudent = item.phoneStudent
        entity.address = item.address
        entity.address2 = item.address2
        entity.city = item.city
        entity.state = item.state
        entity.zip = item.zip
        entity.country = item.country
        entity.credentials = item.credentials
        entity.depiction = item.depiction
        entity.fbid = item.fbid
        entity.lang = item.lang
        entity.flags = item.flags
        entity.schools = []
    }
    
    public func setRelations(
        from item: InstructorFields,
        of entity: Instructor,
        in context: NSManagedObjectContext) throws
    {
        #warning("Nothing is here")
    }
    
    public enum Errors: Error {
        case noUtils
        
        case assessmentsNotFound
        case studentsNotFound
    }
}
