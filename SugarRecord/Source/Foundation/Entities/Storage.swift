import Foundation

public enum StorageType {
    case coreData
    case realm
}

typealias StorageOperation = ((context: Context, save: () -> Void) throws -> Void) throws -> Void

public protocol Storage: CustomStringConvertible, Requestable {
        
    var type: StorageType { get }
    var mainContext: Context! { get }
    var saveContext: Context! { get }
    var memoryContext: Context! { get }
    func removeStore() throws
    func operation<T>(_ operation: (context: Context, save: () -> Void) throws -> T) throws -> T
    func fetch<T: Entity>(_ request: Request<T>) throws -> [T]
    
}

// MARK: - Storage extension (Fetching)

public extension Storage {

    func fetch<T: Entity>(_ request: Request<T>) throws -> [T] {
        return try self.mainContext.fetch(request)
    }
    
}
