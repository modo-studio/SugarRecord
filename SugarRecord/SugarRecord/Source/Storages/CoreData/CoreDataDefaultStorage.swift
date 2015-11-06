import Foundation
import CoreData

/// Default CoreData storage with an stack base on PSC <=> Private Context <=> Main Context <=> Private Context
/// High load operations are executed in private contexts without affecting the Main Context used from the main thread for UI data presentation
public class CoreDataDefaultStorage: Storage {
    
    // MARK: - Storage (Attributes)
    
    var mainContext: Context
    
    var saveContext: Context {
        get {
            //TODO
        }
    }
    
    var memoryContext: Context {
        get {
            //TODO
        }
    }
    
    
    // MARK: - Storage (methods)
    
    public func operation(queue: dispatch_queue_t, operation: (context: Context, save: () -> Void) -> Void) {
        
    }
    
    
    // MARK: - Init
    
    public init() {
        
    }
}