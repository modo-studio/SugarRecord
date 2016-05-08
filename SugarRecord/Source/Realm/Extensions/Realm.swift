import Foundation
import RealmSwift

extension Realm: Context {
    
    public func fetch<T: Entity>(request: Request<T>) throws -> [T] {
        guard let entity = T.self as? Object.Type else { throw Error.InvalidType }
        var results = self.objects(entity.self)
        if let predicate = request.predicate {
            results = results.filter(predicate)
        }
        if let sortDescriptor = request.sortDescriptor, key = sortDescriptor.key {
            results = results.sorted(key, ascending: sortDescriptor.ascending)
        }
        return results.toArray().map { $0 as Any as! T }
    }
    
    public func insert<T: Entity>(entity: T) throws {
        guard let _ = T.self as? Object.Type else { throw Error.InvalidType }
        self.add(entity as! Object, update: false)
    }
    
    public func new<T: Entity>() throws -> T {
        guard let entity = T.self as? Object.Type else { throw Error.InvalidType }
        return entity.init() as! T
    }
    
    public func remove<T: Entity>(objects: [T]) throws {
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
