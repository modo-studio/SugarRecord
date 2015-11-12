import Foundation
import CoreData

/// Default CoreData storage with an stack based on a private root context that is connected to the persistent store coordinator. A main context connected to that private root context is using for main thread operations such as data fetching, and then high load operations are executed in temporary private context that has the root context as parent context. Operations persisted in these contexts are automatically merged into the main context in order to reflect the changes in UI components.
public class CoreDataDefaultStorage: Storage {
    
    
    // MARK: - Attributes
    
    /// CoreData store
    private let store: CoreData.Store
    
    /// CoreData managed object model
    private var objectModel: NSManagedObjectModel! = nil
    
    /// CoreData persistent store
    private var persistentStore: NSPersistentStore! = nil
    
    /// CoreData persistent store coordinator
    private var persistentStoreCoordinator: NSPersistentStoreCoordinator! = nil
    
    /// CoreData root saving context
    private var rootSavingContext: NSManagedObjectContext! = nil
    
    // MARK: - Storage conformance
    
    /// Storage description. This description property is defined in the CustomStringLiteralConvertible protocol
    public var description: String {
        get {
            return "CoreDataDefaultStorage"
        }
    }
    
    /// Storage type
    public var type: StorageType = .CoreData
    
    /// Main context. This context is mostly used for querying operations.
    /// Note: Use this context with the main thread only
    public var mainContext: Context!

    /// Save context. This context is mostly used for save operations
    public var saveContext: Context! {
        get {
            let _context = context(withParent: .Context(self.rootSavingContext), concurrencyType: .PrivateQueueConcurrencyType)
            _context.observe(inMainThread: true) { [weak self] (notification) -> Void in
                (self?.mainContext as? NSManagedObjectContext)?.mergeChangesFromContextDidSaveNotification(notification)
            }
            return _context
        }
    }
    
    /// Memory context. This context is mostly used for testing (not persisted)
    public var memoryContext: Context! {
        get {
            let _context =  context(withParent: .Context(self.rootSavingContext), concurrencyType: .PrivateQueueConcurrencyType)
            return _context
        }
    }
    
    /**
    Executes the provided operation in a given queue
    
    - parameter queue:     Queue where the operation will be executed
    - parameter operation: Operation closure that will be executed. This operation receives a context that can be use for fetching/persisting/removing data. It also receives a save closure. When this closure is called the operations against the context are persisted. If this method is not called the context will be removed and the operations won't be persisted.
    - parameter completed: Closure that is called once the operation & saving finishes. It's called from the Queue where the operation was executed.
    */
    public func operation(queue queue: Queue, operation: (context: Context, save: () -> Void) -> Void, completed: (() -> Void)?) {
        dispatch_async(queue.gcd()) { () -> Void in
            let context: NSManagedObjectContext = self.saveContext as! NSManagedObjectContext
            context.performBlockAndWait {
                var save: Bool = false
                operation(context: context, save: { save = true })
                if save {
                    _ = try? context.save()
                    let mainContext = self.mainContext as! NSManagedObjectContext
                    if mainContext.hasChanges {
                        _ = try? mainContext.save()
                    }
                    completed?()
                }
                else {
                    completed?()
                }
            }
        }
    }
    
    /**
     It removes the store. If you use this method the CoreData make sure you initialize everything again before starting using CoreData again
     
     - throws: NSError returned by NSFileManager when the removal operation fails
     */
    public func removeStore() throws {
        try NSFileManager.defaultManager().removeItemAtURL(store.path())
    }
    
    
    // MARK: - Constructors
    
    /**
    Initializes the CoreDataDefaultStorage
    
    - parameter store:   Entity that represents a CoreData store
    - parameter model:   Entity that represetns the CoreData object model that contains the database schema
    - parameter migrate: True if the store has to be migrated when it's initialized
    
    - returns: initialized CoreData default storage
    */
    public init(store: CoreData.Store, model: CoreData.ObjectModel, migrate: Bool = true) throws {
        self.store   = store
        self.objectModel = model.model()!
        self.persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: objectModel)
        self.persistentStore = try initializeStore(store, storeCoordinator: persistentStoreCoordinator, migrate: migrate)
        self.rootSavingContext = context(withParent: .Coordinator(self.persistentStoreCoordinator), concurrencyType: .PrivateQueueConcurrencyType)
        self.mainContext = context(withParent: .Context(self.rootSavingContext), concurrencyType: .MainQueueConcurrencyType)
    }
}


/**
 It creates and returnsn a context with the given concurrency type and parent
 
 - parameter parent:          context parent
 - parameter concurrencyType: context concurrency type
 
 - returns: initialized managed object context
 */
private func context(withParent parent: CoreData.ContextParent?, concurrencyType: NSManagedObjectContextConcurrencyType) -> NSManagedObjectContext {
    let context: NSManagedObjectContext = NSManagedObjectContext(concurrencyType: concurrencyType)
    if let parent = parent {
        switch parent {
        case .Context(let parentContext):
            context.parentContext = parentContext
        case .Coordinator(let storeCoordinator):
            context.persistentStoreCoordinator = storeCoordinator
        }
    }
    context.observeToGetPermanentIDsBeforeSaving()
    return context
}


/**
 Initializes the CoreData store and returns it
 
 - parameter store:            store information
 - parameter storeCoordinator: persistent store coordinator
 - parameter migrate:          true if the schema has to be migrated
 
 - throws: error if the store cannot be initialized
 
 - returns: initialized persistent store
 */
private func initializeStore(store: CoreData.Store, storeCoordinator: NSPersistentStoreCoordinator, migrate: Bool) throws -> NSPersistentStore {
    try createStoreParentPathIfNeeded(store)
    let options = migrate ? CoreData.Options.Migration : CoreData.Options.Default
    return try addPersistentStore(store, storeCoordinator: storeCoordinator, options: options.dict())
}


/**
 It creates the parent directory for the store if needed
 
 - parameter store: store
 
 - throws: error if something went wrong
 */
private func createStoreParentPathIfNeeded(store: CoreData.Store) throws {
    if let databaseParentPath = store.path().URLByDeletingLastPathComponent  {
        try NSFileManager.defaultManager().createDirectoryAtURL(databaseParentPath, withIntermediateDirectories: true, attributes: nil)
    }
}

/**
 Creates a NSpersistentStore
 
 - parameter store:            store information
 - parameter storeCoordinator: persistent store coordinator
 - parameter options:          store options
 
 - throws: an error if the store cannot be added co the coordinator
 
 - returns: persistent store
 */
private func addPersistentStore(store: CoreData.Store, storeCoordinator: NSPersistentStoreCoordinator, options: [NSObject: AnyObject]) throws -> NSPersistentStore {
    
    var addStore: ((store: CoreData.Store,  storeCoordinator: NSPersistentStoreCoordinator, options: [NSObject: AnyObject], cleanAndRetryIfMigrationFails: Bool) throws -> NSPersistentStore)?
    addStore = { (store: CoreData.Store, coordinator: NSPersistentStoreCoordinator, options: [NSObject: AnyObject], retry: Bool) throws -> NSPersistentStore in
        var persistentStore: NSPersistentStore?
        var error: NSError?
        coordinator.performBlockAndWait({ () -> Void in
            do {
                persistentStore = try storeCoordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: store.path(), options: options)
            }
            catch let _error as NSError {
                error = _error
            }
        })
        if let error = error {
            let isMigrationError = error.code == NSPersistentStoreIncompatibleVersionHashError || error.code == NSMigrationMissingSourceModelError
            if isMigrationError && retry {
                _ = try? cleanStoreFilesAfterFailedMigration(store: store)
                try addStore!(store: store, storeCoordinator: coordinator, options: options, cleanAndRetryIfMigrationFails: false)
            }
            else {
                throw error
            }
        }
        else if let persistentStore = persistentStore {
            return persistentStore
        }
        throw CoreData.Error.PersistenceStoreInitialization
    }
    return try addStore!(store: store, storeCoordinator: storeCoordinator, options: options, cleanAndRetryIfMigrationFails: true)
}

/**
 Cleans store files if the migration fails (shm, wal, database)
 
 - parameter store: store information
 
 - throws: error if the files cannot be removed
 */
private func cleanStoreFilesAfterFailedMigration(store store: CoreData.Store) throws {
    let rawUrl: String = store.path().absoluteString
    let shmSidecar: NSURL = NSURL(string: rawUrl.stringByAppendingString("-shm"))!
    let walSidecar: NSURL = NSURL(string: rawUrl.stringByAppendingString("-wal"))!
    try NSFileManager.defaultManager().removeItemAtURL(store.path())
    try NSFileManager.defaultManager().removeItemAtURL(shmSidecar)
    try NSFileManager.defaultManager().removeItemAtURL(walSidecar)
}
