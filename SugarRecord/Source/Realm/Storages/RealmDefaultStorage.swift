import Foundation
import RealmSwift

/// Default Realm storage. In this case the structure is much simpler (compared with CoreData) contexts are represented by Realm instances in the thread where they are requested.
public class RealmDefaultStorage: Storage {
    
    // MARK: - Attributes
    
    private let configuration: Realm.Configuration?
    
    
    ///  MARK: - Init
    
    public init(configuration: Realm.Configuration? = nil) {
        self.configuration = configuration
    }
    
    
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
            if let configuration = self.configuration {
                return try? Realm(configuration: configuration)
            }
            else {
                return try? Realm()
            }
        }
    }
    
    /// Save context. This context is mostly used for save operations
    public var saveContext: Context! {
        get {
            if let configuration = self.configuration {
                return try? Realm(configuration: configuration)
            }
            else {
                return try? Realm()
            }
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
     Executes the provided operation.
     
     - parameter operation: Operation to be executed.
     */
    public func operation(operation: (context: Context, save: () -> Void) -> Void) {
        let context: Realm = self.saveContext as! Realm
        context.beginWrite()
        var save: Bool = false
        operation(context: context, save: { save = true })
        if save {
            _ = try? context.commitWrite()
        }
        else {
            context.cancelWrite()
        }
    }
    
}
