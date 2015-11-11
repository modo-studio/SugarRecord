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
public protocol Storage: CustomStringConvertible {
    
    /// Storage type
    var type: StorageType { get }
    
    /// Main context. This context is mostly used for querying operations
    var mainContext: Context { get }
    
    /// Save context. This context is mostly used for save operations
    var saveContext: Context { get }
    
    /// Memory context. This context is mostly used for testing (not persisted)
    var memoryContext: Context { get }
    
    /**
     Removes the store     
     */
    func removeStore() throws
    
    /**
     Executes the provided operation in background
    
     - parameter write: true if the context has to persist the changes
     - parameter operation: operation to be executed
     - parameter completed: closure called when the execution is completed
     */
    func operation(write: Bool, operation: (context: Context) -> Void, completed: (() -> Void))
    
    /**
     Executes the provided operation in a given queue
     Note: This method must be implemented by the Storage that conforms this protocol.
     Some storages require propagating these saves across the stack of contexts (e.g. CoreData)
     
     - parameter queue:     queue where the operation will be executed
     - parameter write: true if the context has to persist the changes
     - parameter operation: operation to be executed
     - parameter completed: closure called when the execution is completed
     */
    func operation(queue: dispatch_queue_t, write: Bool, operation: (context: Context) -> Void, completed: (() -> Void)?)
}


// MARK: - Storage extension

public extension Storage {
    
    func operation(write: Bool, operation: (context: Context) -> Void, completed: (() -> Void)) {
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)
        self.operation(queue, write: write, operation: operation, completed: completed)
    }
    
}