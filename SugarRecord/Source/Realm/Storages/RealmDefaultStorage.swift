import Foundation
import RealmSwift
import Result

/// Default Realm storage. In this case the structure is much simpler (compared with CoreData) contexts are represented by Realm instances in the thread where they are requested.
public class RealmDefaultStorage: Storage {
    
    // MARK: - Storage conformance
    
    /// Storage description. This description property is defined in the CustomStringLiteralConvertible protocol
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
    
    /// Main context. This context is mostly used for querying operations.
    /// Note: Use this context with the main thread only
    public var mainContext: Context! {
        get {
            return try? Realm()
        }
    }
    
    /// Save context. This context is mostly used for save operations
    public var saveContext: Context! {
        get {
            return try? Realm()
        }
    }
    
    /// Memory context. This context is mostly used for testing (not persisted)
    public var memoryContext: Context! {
        get {
            return try? Realm(configuration: Realm.Configuration(inMemoryIdentifier: "MemoryRealm"))
        }
    }
    
    /**
     It removes the store. If you use this method the CoreData make sure you initialize everything again before starting using CoreData again
     
     - throws: NSError returned by NSFileManager when the removal operation fails
     */
    public func removeStore() throws {
        try NSFileManager.defaultManager().removeItemAtPath(Realm().path)
    }

    /**
     Executes the provided operation in a given queue
     
     - parameter queue:     Queue where the operation will be executed
     - parameter operation: Operation closure that will be executed. This operation receives a context that can be use for fetching/persisting/removing data. It also receives a save closure. When this closure is called the operations against the context are persisted. If this method is not called the context will be removed and the operations won't be persisted.
     - parameter completed: Closure that is called once the operation & saving finishes. It's called from the Queue where the operation was executed.
     */
    public func operation(queue queue: Queue, operation: (context: Context, save: () -> Void) -> Void, completed: (() -> Void)?) {
        dispatch_async(queue.gcd()) { () -> Void in
            let _context: Realm = self.saveContext as! Realm
            _context.beginWrite()
            var save: Bool = false
            operation(context: _context, save: { save = true })
            if (save) {
                _ = try? _context.commitWrite()
            }
            else {
                _context.cancelWrite()
            }
            completed?()
        }
    }
}