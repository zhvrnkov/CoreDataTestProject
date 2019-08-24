import Foundation
import CoreData

public class InstructorsUtils: EntityUtilsMethods {
    public typealias EntityType = Instructor
    public typealias EntityValueFields = InstructorFields
    
    public func getAll() -> [EntityType] {
        return _getAll()
    }
    
    public func asyncGetAll(_ completion: @escaping (Result<[EntityType], Error>) -> Void) {
        _asyncGetAll(completion)
    }
    
    public func get(where predicate: Predicate) -> [EntityType] {
        return _get(where: predicate)
    }
    
    public func asyncGet(where predicate: Predicate, _ completeion: @escaping (Result<[EntityType], Error>) -> Void) {
        _asyncGet(where: predicate, completeion)
    }
    
    public func get(whereSid sid: Int) -> EntityType? {
        return _get(whereSid: sid)
    }
    
    public func asyncGet(whereSid sid: Int, _ completeion: @escaping (Result<EntityType?, Error>) -> Void) {
        return _asyncGet(whereSid: sid, completeion)
    }
    
    public func get(whereSids sids: [Int]) -> [EntityType] {
        return _get(whereSids: sids)
    }
    
    public func asyncGet(whereSids sids: [Int], _ completeion: @escaping (Result<[EntityType], Error>) -> Void) {
        return _asyncGet(whereSids: sids, completeion)
    }
    
    public func save(item: EntityValueFields) throws {
        try _save(item: item)
    }
    public func save(items: [EntityValueFields]) throws {
        try _save(items: items)
    }
    
    public func delete(whereSid sid: Int) throws {
        try _delete(whereSid: sid)
    }
    public func delete(whereSids sids: [Int]) throws {
        try _delete(whereSids: sids)
    }
    
    public func update(whereSid sid: Int, like item: EntityValueFields) throws {
        try _update(whereSid: sid, like: item)
    }
    
    var container: NSPersistentContainer
    var backgroundContext: NSManagedObjectContext {
        return container.newBackgroundContext()
    }
    
    init(with container: NSPersistentContainer) {
        self.container = container
    }
    
    public enum Errors: Error {
        case noUtils
        
        case assessmentsNotFound
        case studentsNotFound
    }
}

extension InstructorsUtils: EntityUtils {
    func copyFields(from item: InstructorFields, to entity: Instructor) {
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
        entity.fbid = item.fbid as [NSString]
        entity.lang = item.lang
        entity.flags = item.flags as [NSString]
        entity.schools = []
    }
    
    func setRelations(
        from item: InstructorFields,
        of entity: Instructor,
        in context: NSManagedObjectContext) throws
    {}
}
