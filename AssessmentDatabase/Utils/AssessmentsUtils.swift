import Foundation
import CoreData

public class AssessmentsUtils: EntityUtils {
    public typealias EntityType = Assessment
    public typealias EntityValueFields = AssessmentFields
    
    public var container: NSPersistentContainer
    
    public init(with container: NSPersistentContainer) {
        self.container = container
    }
    
    public func copyFields(from item: AssessmentFields, to entity: Assessment) {
        entity.sid = Int64(item.sid)
        entity.schoolId = Int64(item.sid)
        entity.date = item.date
    }
    
    public func save(item: AssessmentFields) {
        let backgroundContext = container.newBackgroundContext()
        backgroundContext.performAndWait {
            let entity = Assessment(context: backgroundContext)
            self.copyFields(from: item, to: entity)
            try! backgroundContext.save()
        }
    }
    
    public func save(items: [AssessmentFields]) {
        let backgroundContext = container.newBackgroundContext()
        backgroundContext.performAndWait {
            items.forEach { item in
                let entity = Assessment(context: backgroundContext)
                self.copyFields(from: item, to: entity)
            }
            try! backgroundContext.save()
        }
    }
    
    public func delete(item: AssessmentFields) {
        fatalError()
    }
    
    public func delete(items: [AssessmentFields]) {
        fatalError()
    }
    
    public func update(item: AssessmentFields) {
        fatalError()
    }
    
    public func update(items: [AssessmentFields]) {
        fatalError()
    }
}
