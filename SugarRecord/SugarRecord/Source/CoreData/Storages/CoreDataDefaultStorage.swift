import Foundation
import CoreData

/// Default CoreData storage with an stack base on PSC <=> Private Context <=> Main Context <=> Private Context
/// High load operations are executed in private contexts without affecting the Main Context used from the main thread for UI data presentation
public class CoreDataDefaultStorage: Storage {
    
    
    // MARK: - Attributes
    
    private let store: CoreData.Store
    private var objectModel: NSManagedObjectModel! = nil
    private var persistentStore: NSPersistentStore! = nil
    private var persistentStoreCoordinator: NSPersistentStoreCoordinator! = nil
    private var rootSavingContext: NSManagedObjectContext! = nil
    
    // MARK: - Storage (Attributes)
    
    /// Storage name
    public var description: String {
        get {
            return "CoreDataDefaultStorage"
        }
    }
    
    /// Storage type
    public var type: StorageType = .CoreData
    
    /// Main context. This context is mostly used for querying operations
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
    
    
    // MARK: - Storage (methods)
    
    /**
    Executes the provided operation in a given queue
    
    - parameter queue:     queue where the operation will be executed
    - parameter save:      closure to be called to persist the changes
    - parameter operation: operation to be executed
    */
    public func operation(queue: dispatch_queue_t, operation: (context: Context, save: () -> Void) -> Void, completed: (() -> Void)?) {
        dispatch_async(queue) { () -> Void in
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
                }
            }
        }
    }
    
    /**
     It removes the store. If you use this method the CoreData make sure you initialize everything again before stargint using CoreData again
     
     - throws: error if the store cannot be deleted
     */
    public func removeStore() throws {
        try NSFileManager.defaultManager().removeItemAtURL(store.path())
    }
    
    
    // MARK: - Init
    
    /**
    Initializes the default CoreData storage
    
    - parameter store:   store information
    - parameter model:   object model
    - parameter migrate: true if the database has to be migrated in case the schema changed
    
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
