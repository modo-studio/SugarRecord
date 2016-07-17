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
    func backgroundOperation<T>(operation: (context: Context, save: () -> Void) throws -> T, completion: ((error: ErrorType?) -> Void)?)
    func fetch<T: Entity>(request: Request<T>) throws -> [T]
    
}

// MARK: - Storage extension

public extension Storage {

    func fetch<T: Entity>(request: Request<T>) throws -> [T] {
        return try self.mainContext.fetch(request)
    }
    
    func backgroundOperation<T>(operation: (context: Context, save: () -> Void) throws -> T, completion: ((error: ErrorType?) -> Void)? = nil) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) { 
            do {
                try self.operation(operation)
                dispatch_async(dispatch_get_main_queue()) {
                    completion?(error: nil)
                }
            }
            catch {
                dispatch_async(dispatch_get_main_queue()) {
                    completion?(error: error)
                }
            }
        }
    }
    
}
