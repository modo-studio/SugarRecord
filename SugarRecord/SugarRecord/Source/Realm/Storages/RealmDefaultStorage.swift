import Foundation
import RealmSwift
import Result

/// Realm default storage
public class RealmDefaultStorage: Storage {
    
    // MARK: - Storage
    
    /// Storage name
    public var description: String {
        get {
            return "RealmDefaultStorage"
        }
    }
    
    /// Storage type
    public var type: StorageType {
        get {
            return .Realm
        }
    }
    
    /// Main context. This context is mostly used for querying operations
    public var mainContext: Context {
        get {
            return try! Realm()
        }
    }
    
    /// Save context. This context is mostly used for save operations
    public var saveContext: Context {
        get {
            return try! Realm()
        }
    }
    
    /// Memory context. This context is mostly used for testing (not persisted)
    public var memoryContext: Context {
        get {
            return try! Realm(configuration: Realm.Configuration(inMemoryIdentifier: "MemoryRealm"))
        }
    }
    
    /**
     Removes the store
     
     - throws: error if the store cannot be removed
     */
    public func removeStore() throws {
        try NSFileManager.defaultManager().removeItemAtPath(Realm().path)
    }

    /**
     Executes the provided operation in a given queue
     Note: This method must be implemented by the Storage that conforms this protocol.
     Some storages require propagating these saves across the stack of contexts (e.g. CoreData)
     
     - parameter queue:     queue where the operation will be executed
     - parameter write: true if the context has to persist the changes
     - parameter operation: operation to be executed
     */
    public func operation(queue: dispatch_queue_t, write: Bool, operation: (context: Context) -> Void, completed: (() -> Void)?) {
        dispatch_async(queue) { () -> Void in
            let _context: Realm = self.saveContext as! Realm
            if (write) { _context.beginWrite() }
            operation(context: _context)
            if (write) { _ = try? _context.commitWrite() } // FIXME: Propagate the exception out of the scope
            completed?()
        }
    }
}