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
     Executes the provided operation in background
    
     - parameter operation: operation to be executed
     - parameter save:      closure to be called to persist the changes
     - parameter completed: closure called when the execution is completed
     */
    func operation(operation: (context: Context, save: Saver) -> Void, completed: (() -> Void)?)
    
    /**
     Executes the provided operation in a given queue
     Note: This method must be implemented by the Storage that conforms this protocol.
     Some storages require propagating these saves across the stack of contexts (e.g. CoreData)
     
     - parameter queue:     queue where the operation will be executed
     - parameter operation: operation to be executed
     - parameter save:      closure to be called to persist the changes
     - parameter completed: closure called when the execution is completed
     */
    func operation(queue queue: Queue, operation: (context: Context, save: Saver) -> Void, completed: (() -> Void)?)
}


// MARK: - Storage extension

public extension Storage {
    
    func operation(operation: (context: Context, save: Saver) -> Void, completed: (() -> Void)?) {
        self.operation(queue: Queue.Background, operation: operation, completed: completed)
    }
    
}