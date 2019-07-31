import Foundation
import CoreData

public class GradesUtils: EntityUtils {
    public typealias EntityType = Grade
    public typealias EntityValueFields = GradeValueFields
    
    public var container: NSPersistentContainer
    
    public init(with container: NSPersistentContainer) {
        self.container = container
    }
    
    public func copyFields(from item: GradeValueFields, to entity: Grade) {
        fatalError()
    }
    
    public func save(item: GradeValueFields) {
        fatalError()
    }
    
    public func save(items: [GradeValueFields]) {
        fatalError()
    }
    
    public func delete(item: GradeValueFields) {
        fatalError()
    }
    
    public func delete(items: [GradeValueFields]) {
        fatalError()
    }
    
    public func update(item: GradeValueFields) {
        fatalError()
    }
    
    public func update(items: [GradeValueFields]) {
        fatalError()
    }
}
