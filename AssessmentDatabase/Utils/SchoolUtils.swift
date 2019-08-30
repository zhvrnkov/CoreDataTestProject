//
//  SchoolUtils.swift
//  AssessmentDatabase
//
//  Created by Vlad Zhavoronkov  on 8/30/19.
//  Copyright © 2019 Bytepace. All rights reserved.
//

import Foundation
import CoreData

public final class SchoolUtils
    <EntityValueFields: SchoolFields>
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
    
    public func configure<T: StudentFields, U: RubricFields, V: InstructorFields>
        (studentUtils: StudentsUtils<T>, rubricUtils: RubricsUtils<U>, instructorUtils: InstructorsUtils<V>)
    {
        self.studentObjectIDsFetch = studentUtils.getObjectIds(whereSids:)
        self.rubricObjectIDFetch = rubricUtils.getObjectId(whereSid:)
        self.instructorObjectIDFetch = instructorUtils.getObjectId(whereSid:)
    }
    
    
    var container: NSPersistentContainer
    var queue: DispatchQueue = .global(qos: .userInitiated)
    
    var studentObjectIDsFetch: ObjectIDsFetch?
    var rubricObjectIDFetch: ObjectIDFetch?
    var instructorObjectIDFetch: ObjectIDFetch?
    
    public init(with container: NSPersistentContainer) {
        self.container = container
    }
}

extension SchoolUtils: EntityUtilsRealization {
    typealias Owner = SchoolUtils
    typealias EntityType = School
    
    static func map(entity: School) -> EntityValueFields {
        return EntityValueFields.init(sid: Int(entity.sid), name: entity.name ?? dbError)
    }
    
    func setRelations(from item: EntityValueFields, of entity: School, in context: NSManagedObjectContext) throws {}
    
    static func copyFields(from item: EntityValueFields, to entity: School) {
        entity.sid = Int64(item.sid)
        entity.name = item.name
    }
}
