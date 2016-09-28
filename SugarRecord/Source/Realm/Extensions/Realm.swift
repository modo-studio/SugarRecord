import Foundation
import RealmSwift

extension Realm: Context {
    
    public func fetch<T: Entity>(_ request: FetchRequest<T>) throws -> [T] {
        guard let entity = T.self as? Object.Type else { throw StorageError.invalidType }
        var results = self.objects(entity.self)
        if let predicate = request.predicate {
            results = results.filter(predicate)
        }
        if let sortDescriptor = request.sortDescriptor, let key = sortDescriptor.key {
            results = results.sorted(byProperty: key, ascending: sortDescriptor.ascending)
        }
        return results.toArray().map { $0 as Any as! T }
    }
    
    public func insert<T: Entity>(_ entity: T) throws {
        guard let _ = T.self as? Object.Type else { throw StorageError.invalidType }
        self.add(entity as! Object, update: false)
    }
    
    public func new<T: Entity>() throws -> T {
        guard let entity = T.self as? Object.Type else { throw StorageError.invalidType }
        return entity.init() as! T
    }
    
    public func remove<T: Entity>(_ objects: [T]) throws {
        let objectsToDelete = objects
            .map { $0.realm }
            .filter { $0 != nil }
            .map { $0! }
        self.delete(objectsToDelete)
    }
    
    public func removeAll() throws {
        self.deleteAll()
    }
    
}
