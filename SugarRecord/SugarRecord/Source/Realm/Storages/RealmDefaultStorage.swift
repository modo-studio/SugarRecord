import Foundation
import RealmSwift
import Result

class RealmDefaultStorage {
    
    // MARK: - Storage
    
    /// Storage name
    var name: String {
        get {
            return "RealmDefaultStorage"
        }
    }
    
    /// Storage type
    var type: StorageType {
        get {
            return .Realm
        }
    }
    
    /// Main context. This context is mostly used for querying operations
    var mainContext: Context {
        get {
            return try! Realm()
        }
    }
    
    /// Save context. This context is mostly used for save operations
    var saveContext: Context {
        get {
            return try! Realm()
        }
    }
    
    /// Memory context. This context is mostly used for testing (not persisted)
    var memoryContext: Context {
        get {
            return try! Realm(configuration: Realm.Configuration(inMemoryIdentifier: "MemoryRealm"))
        }
    }
}