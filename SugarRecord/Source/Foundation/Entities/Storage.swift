import Foundation


/**
 List of supported storage types
 
 - CoreData: CoreData
 - Realm:    Realm
 */
public enum StorageType {
    case CoreData
    case Realm
}

/**
 *  Protocol that identifies a persistence storage
 */
public protocol Storage: CustomStringConvertible, Requestable {
    
    typealias Saver = () -> Void
    
    /// Storage type
    var type: StorageType { get }
    
    /// Main context. This context is mostly used for querying operations
    var mainContext: Context! { get }
    
    /// Save context. This context is mostly used for save operations
    var saveContext: Context! { get }
    
    /// Memory context. This context is mostly used for testing (not persisted)
    var memoryContext: Context! { get }
    
    /**
     Removes the store     
     */
    func removeStore() throws
    
    /**
     Executes the provided operation.
     
     - parameter operation: Operation to be executed.
     */
    func operation(operation: (context: Context, save: Saver) -> Void)
    
    /**
     Fetches objects and returns them using the provided request.
     
     - parameter request: Request to fetch the objects.
     
     - throws: Throws an Error in case the object couldn't be fetched.
     
     - returns: Array with the results.
     */
    func fetch<T: Entity>(request: Request<T>) throws -> [T]
}

// MARK: - Storage extension (Fetching)
public extension Storage {
    
    /**
     Fetches objects and returns them using the provided request.
     
     - parameter request: Request to fetch the objects.
     
     - throws: Throws an Error in case the object couldn't be fetched.
     
     - returns: Array with the results.
     */
    func fetch<T: Entity>(request: Request<T>) throws -> [T] {
        return try self.mainContext.fetch(request)
    }
    
}
