import Foundation

public enum StorageType {
    case CoreData
    case Realm
}

typealias StorageOperation = ((context: Context, save: () -> Void) throws -> Void) throws -> Void

public protocol Storage: CustomStringConvertible, Requestable {
        
    var type: StorageType { get }
    var mainContext: Context! { get }
    var saveContext: Context! { get }
    var memoryContext: Context! { get }
    func removeStore() throws
    func operation<T>(operation: (context: Context, save: () -> Void) throws -> T) throws -> T
    func fetch<T: Entity>(request: Request<T>) throws -> [T]
    
}

// MARK: - Storage extension (Fetching)

public extension Storage {

    func fetch<T: Entity>(request: Request<T>) throws -> [T] {
        return try self.mainContext.fetch(request)
    }
    
}
