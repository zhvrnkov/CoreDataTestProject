import Foundation
import CoreData

public class InstructorsUtils
    <EntityValueFields: InstructorFields>
    : EntityUtils
{
    
    public func getAll() -> [EntityValueFields] {
        return _getAll()
    }
    
    public func asyncGetAll(_ completion: @escaping (Result<[EntityValueFields], Error>) -> Void) {
        _asyncGetAll(completion)
    }
    
    public func get(where predicate: Predicate) -> [EntityValueFields] {
        return _get(where: predicate)
    }
    
    public func asyncGet(where predicate: Predicate, _ completeion: @escaping (Result<[EntityValueFields], Error>) -> Void) {
        _asyncGet(where: predicate, completeion)
    }
    
    public func get(whereSid sid: Int) -> EntityValueFields? {
        return _get(whereSid: sid)
    }
    
    public func asyncGet(whereSid sid: Int, _ completeion: @escaping (Result<EntityValueFields?, Error>) -> Void) {
        return _asyncGet(whereSid: sid, completeion)
    }
    
    public func get(whereSids sids: [Int]) -> [EntityValueFields] {
        return _get(whereSids: sids)
    }
    
    public func asyncGet(whereSids sids: [Int], _ completeion: @escaping (Result<[EntityValueFields], Error>) -> Void) {
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
    var queue: DispatchQueue = .global(qos: .userInitiated)
    
    public init(with container: NSPersistentContainer) {
        self.container = container
    }
    
    public enum Errors: Error {
        case noUtils
        
        case assessmentsNotFound
        case studentsNotFound
    }
}

extension InstructorsUtils: EntityUtilsRealization {
    typealias Owner = InstructorsUtils
    typealias EntityType = Instructor
    
    static func map(entity: Instructor) -> EntityValueFields {
        let entityAssessments = (entity.assessments?.allObjects as? [Assessment]) ?? []
        let entityStudents = (entity.students?.allObjects as? [Student]) ?? []
        let assessments: [EntityValueFields.AssessmentFieldsType] =
            AssessmentsUtils.map(entities: entityAssessments)
        let students: [EntityValueFields.StudentFieldsType] =
            StudentsUtils.map(entities: entityStudents)
        return EntityValueFields.init(
            sid: Int(entity.sid),
            loginUsername: entity.loginUsername ?? dbError,
            firstName: entity.firstName ?? dbError,
            lastName: entity.lastName ?? dbError,
            avatar: entity.avatar ?? dbError,
            email: entity.email ?? dbError,
            phone: entity.phone ?? dbError,
            phoneStudent: entity.phoneStudent ?? dbError,
            address: entity.address ?? dbError,
            address2: entity.address2 ?? dbError,
            city: entity.city ?? dbError,
            state: entity.state ?? dbError,
            zip: entity.zip ?? dbError,
            country: entity.country ?? dbError,
            credentials: entity.credentials ?? dbError,
            depiction: entity.depiction ?? dbError,
            fbid: (entity.fbid ?? []).map { $0 as String },
            lang: entity.lang ?? dbError,
            flags: (entity.flags ?? []).map { $0 as String },
            schools: [],
            assessments: assessments,
            students: students)
    }
    
    static func copyFields(from item: EntityValueFields, to entity: Instructor) {
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
        from item: EntityValueFields,
        of entity: Instructor,
        in context: NSManagedObjectContext) throws
    {}
}
