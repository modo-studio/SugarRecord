import Foundation

public protocol Context: Requestable {
    
    func fetch<T: Entity>(request: Request<T>) throws -> [T]
    func insert<T: Entity>(entity: T) throws
    func new<T: Entity>() throws -> T
    func create<T: Entity>() throws -> T
    func remove<T: Entity>(objects: [T]) throws
    func remove<T: Entity>(object: T) throws
    func removeAll() throws
}


// MARK: - Extension of Context implementing convenience methods.

public extension Context {

    public func create<T: Entity>() throws -> T {
        let instance: T = try self.new()
        try self.insert(instance)
        return instance
    }

    public func remove<T: Entity>(object: T) throws {
        return try self.remove([object])
    }
    
}
