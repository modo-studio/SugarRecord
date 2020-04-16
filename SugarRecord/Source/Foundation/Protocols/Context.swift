import Foundation

public protocol Context: Requestable {
    
    func fetch<T: Entity>(_ request: FetchRequest<T>) throws -> [T]
    func fetchOne<T: Entity>(_ request: FetchRequest<T>) throws -> T?
    func insert<T: Entity>(_ entity: T) throws
    func new<T: Entity>() throws -> T
    func query<T: Entity>(_ request: FetchRequest<T>, attributes: [String]) throws -> [[String: Any]]
    func query<T: Entity>(_ request: FetchRequest<T>, attribute: String) throws -> [String]?
    func querySet<T: Entity>(_ request: FetchRequest<T>, attribute: String) throws -> Set<String>?
    func queryOne<T: Entity>(_ request: FetchRequest<T>, attributes: [String]) throws -> [String: Any]?
    func count<T: Entity>(_ request: FetchRequest<T>) -> Int
    func create<T: Entity>() throws -> T
    func remove<T: Entity>(_ objects: [T]) throws
    func remove<T: Entity>(_ object: T) throws
    func removeAll() throws
    func saveToPersistentStore(_ completion: ((Swift.Result<Any?, Error>) -> Void)?)
    func batchUpdate(entityName: String, propertiesToUpdate: [AnyHashable : Any]?, predicate: NSPredicate?)
    func batchDelete(entityName: String, predicate: NSPredicate?)
}


// MARK: - Extension of Context implementing convenience methods.

public extension Context {
    
    func create<T: Entity>() throws -> T {
        let instance: T = try self.new()
        try self.insert(instance)
        return instance
    }
    
    func remove<T: Entity>(_ object: T) throws {
        return try self.remove([object])
    }
    
}
