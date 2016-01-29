import Foundation
import CoreData

/// Default CoreData storage with an stack based on a private root context that is connected to the persistent store coordinator. A main context connected to that private root context is using for main thread operations such as data fetching, and then high load operations are executed in temporary private context that has the root context as parent context. Operations persisted in these contexts are automatically merged into the main context in order to reflect the changes in UI components.
public class CoreDataDefaultStorage: Storage {
    
    
    // MARK: - Attributes
    
    /// CoreData store
    internal let store: CoreData.Store
    
    /// CoreData managed object model
    internal var objectModel: NSManagedObjectModel! = nil
    
    /// CoreData persistent store
    internal var persistentStore: NSPersistentStore! = nil
    
    /// CoreData persistent store coordinator
    internal var persistentStoreCoordinator: NSPersistentStoreCoordinator! = nil
    
    /// CoreData root saving context
    internal var rootSavingContext: NSManagedObjectContext! = nil
    
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
            let _context = cdContext(withParent: .Context(self.rootSavingContext), concurrencyType: .PrivateQueueConcurrencyType, inMemory: false)
            _context.observe(inMainThread: true) { [weak self] (notification) -> Void in
                (self?.mainContext as? NSManagedObjectContext)?.mergeChangesFromContextDidSaveNotification(notification)
            }
            return _context
        }
    }
    
    /// Memory context. This context is mostly used for testing (not persisted)
    public var memoryContext: Context! {
        get {
            let _context =  cdContext(withParent: .Context(self.rootSavingContext), concurrencyType: .PrivateQueueConcurrencyType, inMemory: true)
            return _context
        }
    }
    
    /**
     Executes the provided operation.
     
     - parameter operation: Operation to be executed.
     */
    public func operation(operation: (context: Context, save: () -> Void) -> Void) {
        let context: NSManagedObjectContext = self.saveContext as! NSManagedObjectContext
        context.performBlockAndWait {
            var save: Bool = false
            operation(context: context, save: { save = true })
            if save {
                _ = try? context.save()
                if self.rootSavingContext.hasChanges {
                    _ = try? self.rootSavingContext.save()
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
        self.persistentStore = try cdInitializeStore(store, storeCoordinator: persistentStoreCoordinator, migrate: migrate)
        self.rootSavingContext = cdContext(withParent: .Coordinator(self.persistentStoreCoordinator), concurrencyType: .PrivateQueueConcurrencyType, inMemory: false)
        self.mainContext = cdContext(withParent: .Context(self.rootSavingContext), concurrencyType: .MainQueueConcurrencyType, inMemory: false)
    }
}


/**
 It creates and returns a context with the given concurrency type and parent
 
 - parameter parent:          context parent
 - parameter concurrencyType: context concurrency type
 
 - returns: initialized managed object context
 */
internal func cdContext(withParent parent: CoreData.ContextParent?, concurrencyType: NSManagedObjectContextConcurrencyType, inMemory: Bool) -> NSManagedObjectContext {
    var context: NSManagedObjectContext?
    if inMemory {
        context = NSManagedObjectMemoryContext(concurrencyType: concurrencyType)
    }
    else {
        context = NSManagedObjectContext(concurrencyType: concurrencyType)
    }
    if let parent = parent {
        switch parent {
        case .Context(let parentContext):
            context!.parentContext = parentContext
        case .Coordinator(let storeCoordinator):
            context!.persistentStoreCoordinator = storeCoordinator
        }
    }
    context!.observeToGetPermanentIDsBeforeSaving()
    return context!
}


/**
 Initializes the CoreData store and returns it
 
 - parameter store:            store information
 - parameter storeCoordinator: persistent store coordinator
 - parameter migrate:          true if the schema has to be migrated
 
 - throws: error if the store cannot be initialized
 
 - returns: initialized persistent store
 */
internal func cdInitializeStore(store: CoreData.Store, storeCoordinator: NSPersistentStoreCoordinator, migrate: Bool) throws -> NSPersistentStore {
    try cdCreateStoreParentPathIfNeeded(store)
    let options = migrate ? CoreData.Options.Migration : CoreData.Options.Default
    return try cdAddPersistentStore(store, storeCoordinator: storeCoordinator, options: options.dict())
}


/**
 It creates the parent directory for the store if needed

 - parameter store: store
 
 - throws: error if something went wrong
 */
internal func cdCreateStoreParentPathIfNeeded(store: CoreData.Store) throws {
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
internal func cdAddPersistentStore(store: CoreData.Store, storeCoordinator: NSPersistentStoreCoordinator, options: [NSObject: AnyObject]) throws -> NSPersistentStore {
    
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
                _ = try? cdCleanStoreFilesAfterFailedMigration(store: store)
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
internal func cdCleanStoreFilesAfterFailedMigration(store store: CoreData.Store) throws {
    let rawUrl: String = store.path().absoluteString
    let shmSidecar: NSURL = NSURL(string: rawUrl.stringByAppendingString("-shm"))!
    let walSidecar: NSURL = NSURL(string: rawUrl.stringByAppendingString("-wal"))!
    try NSFileManager.defaultManager().removeItemAtURL(store.path())
    try NSFileManager.defaultManager().removeItemAtURL(shmSidecar)
    try NSFileManager.defaultManager().removeItemAtURL(walSidecar)
}
