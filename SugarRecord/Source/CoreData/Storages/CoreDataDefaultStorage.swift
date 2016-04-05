import Foundation
import CoreData

public class CoreDataDefaultStorage: Storage {
    
    // MARK: - Attributes
    
    internal let store: CoreData.Store
    internal var objectModel: NSManagedObjectModel! = nil
    internal var persistentStore: NSPersistentStore! = nil
    internal var persistentStoreCoordinator: NSPersistentStoreCoordinator! = nil
    internal var rootSavingContext: NSManagedObjectContext! = nil
    
    
    // MARK: - Storage conformance
    
    public var description: String {
        get {
            return "CoreDataDefaultStorage"
        }
    }
    
    public var type: StorageType = .CoreData
    public var mainContext: Context!
    private var _saveContext: Context!
    public var saveContext: Context! {
        if let context = self._saveContext {
            return context
        }
        let _context = cdContext(withParent: .Context(self.rootSavingContext), concurrencyType: .PrivateQueueConcurrencyType, inMemory: false)
        _context.observe(inMainThread: true) { [weak self] (notification) -> Void in
            (self?.mainContext as? NSManagedObjectContext)?.mergeChangesFromContextDidSaveNotification(notification)
        }
        self._saveContext = _context
        return _context
    }
    public var memoryContext: Context! {
        let _context =  cdContext(withParent: .Context(self.rootSavingContext), concurrencyType: .PrivateQueueConcurrencyType, inMemory: true)
        return _context
    }
    
    public func operation(operation: (context: Context, save: () -> Void) throws -> Void) throws {
        let context: NSManagedObjectContext = self.saveContext as! NSManagedObjectContext
        var _error: ErrorType!
        context.performBlockAndWait {
            do {
                try operation(context: context, save: { () -> Void  in
                    do {
                        try context.save()
                    }
                    catch {
                        _error = error
                    }
                    if self.rootSavingContext.hasChanges {
                        self.rootSavingContext.performBlockAndWait({
                            do {
                                try self.rootSavingContext.save()
                            }
                            catch {
                                _error = error
                            }
                        })
                    }
                })
            } catch {
                _error = error
            }
        }
        if let error = _error {
            throw error
        }
    }

    public func removeStore() throws {
        try NSFileManager.defaultManager().removeItemAtURL(store.path())
    }
    
    
    // MARK: - Init
    
    public init(store: CoreData.Store, model: CoreData.ObjectModel, migrate: Bool = true) throws {
        self.store   = store
        self.objectModel = model.model()!
        self.persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: objectModel)
        self.persistentStore = try cdInitializeStore(store, storeCoordinator: persistentStoreCoordinator, migrate: migrate)
        self.rootSavingContext = cdContext(withParent: .Coordinator(self.persistentStoreCoordinator), concurrencyType: .PrivateQueueConcurrencyType, inMemory: false)
        self.mainContext = cdContext(withParent: .Context(self.rootSavingContext), concurrencyType: .MainQueueConcurrencyType, inMemory: false)
    }
    
}


// MARK: - Internal

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

internal func cdInitializeStore(store: CoreData.Store, storeCoordinator: NSPersistentStoreCoordinator, migrate: Bool) throws -> NSPersistentStore {
    try cdCreateStoreParentPathIfNeeded(store)
    let options = migrate ? CoreData.Options.Migration : CoreData.Options.Default
    return try cdAddPersistentStore(store, storeCoordinator: storeCoordinator, options: options.dict())
}

internal func cdCreateStoreParentPathIfNeeded(store: CoreData.Store) throws {
    if let databaseParentPath = store.path().URLByDeletingLastPathComponent  {
        try NSFileManager.defaultManager().createDirectoryAtURL(databaseParentPath, withIntermediateDirectories: true, attributes: nil)
    }
}

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

internal func cdCleanStoreFilesAfterFailedMigration(store store: CoreData.Store) throws {
    let rawUrl: String = store.path().absoluteString
    let shmSidecar: NSURL = NSURL(string: rawUrl.stringByAppendingString("-shm"))!
    let walSidecar: NSURL = NSURL(string: rawUrl.stringByAppendingString("-wal"))!
    try NSFileManager.defaultManager().removeItemAtURL(store.path())
    try NSFileManager.defaultManager().removeItemAtURL(shmSidecar)
    try NSFileManager.defaultManager().removeItemAtURL(walSidecar)
}
