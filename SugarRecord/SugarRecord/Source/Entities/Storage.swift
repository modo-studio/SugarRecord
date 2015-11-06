import Foundation

/**
 *  Protocol that identifies a persistence storage
 */
public protocol Storage {
    
    /// Main context. This context is mostly used for querying operations
    var mainContext: Context { get }
    
    /// Save context. This context is mostly used for save operations
    var saveContext: Context { get }
    
    /// Memory context. This context is mostly used for testing (not persisted)
    var memoryContext: Context { get }
    
    /**
     Executes the provided operation in background
     
     - parameter operation: operation to be executed
     - parameter save:      save closure that must be called to persist the changes
     */
    func operation(operation: (context: Context, save: () -> Void) -> Void)
    
    /**
     Executes the provided operation in a given queue
     Note: This method must be implemented by the Storage that conforms this protocol.
     Some storages require propagating these saves across the stack of contexts (e.g. CoreData)
     
     - parameter queue:     queue where the operation will be executed
     - parameter operation: operation to be executed
     - parameter save:      save closure that must be called to persist the changes
     */
    func operation(queue: dispatch_queue_t, operation: (context: Context, save: () -> Void) -> Void)
}


// MARK: - Storage extension

public extension Storage {
    
    func operation(operation: (context: Context, save: () -> Void) -> Void) {
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)
        self.operation(queue, operation: operation)
    }
    
}