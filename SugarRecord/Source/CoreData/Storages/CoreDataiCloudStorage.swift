import Foundation
import CoreData

/// https://www.objc.io/issues/10-syncing-data/icloud-core-data/
public class CoreDataiCloudStorage: Storage {
    
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
            return "CoreDataiCloudStorage"
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
            let context = cdContext(withParent: .Context(self.rootSavingContext), concurrencyType: .PrivateQueueConcurrencyType, inMemory: false)
            context.observe(inMainThread: true) { [weak self] (notification) -> Void in
                (self?.mainContext as? NSManagedObjectContext)?.mergeChangesFromContextDidSaveNotification(notification)
            }
            return context
        }
    }
    
    /// Memory context. This context is mostly used for testing (not persisted)
    public var memoryContext: Context! {
        get {
            let context =  cdContext(withParent: .Context(self.rootSavingContext), concurrencyType: .PrivateQueueConcurrencyType, inMemory: true)
            return context
        }
    }
    
    /**
     Executes the provided operation.
     
     - parameter operation: Operation to be executed.
     */
    public func operation(operation: (context: Context, save: () -> Void) -> Void) {
        let context: NSManagedObjectContext = (self.saveContext as? NSManagedObjectContext)!
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
    
    - parameter model:   Entity that represetns the CoreData object model that contains the database schema
    - parameter iCloud:  iCloud configuration
    
    - returns: initialized CoreData default storage
    */
    public init(model: CoreData.ObjectModel, iCloud: iCloudConfig) throws {
        self.objectModel = model.model()!
        self.persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: objectModel)
        (self.store, self.persistentStore) = try! cdiCloudInitializeStore(storeCoordinator: persistentStoreCoordinator, iCloud: iCloud)
        self.rootSavingContext = cdContext(withParent: .Coordinator(self.persistentStoreCoordinator), concurrencyType: .PrivateQueueConcurrencyType, inMemory: false)
        self.mainContext = cdContext(withParent: .Context(self.rootSavingContext), concurrencyType: .MainQueueConcurrencyType, inMemory: false)
        self.observeiCloudChangesInCoordinator()
    }
    
    
    // MARK: - Private
    
    private func observeiCloudChangesInCoordinator() {
        NSNotificationCenter
            .defaultCenter()
            .addObserverForName(NSPersistentStoreDidImportUbiquitousContentChangesNotification, object: self.persistentStoreCoordinator, queue: nil) { [weak self] (notification) -> Void in
                self?.rootSavingContext.performBlock({ () -> Void in
                    self?.rootSavingContext.mergeChangesFromContextDidSaveNotification(notification)
                })
            }
    }
    
}

/**
 Initializes the CoreData store and returns it
 
 - parameter storeCoordinator: persistent store coordinator
 - parameter iCloud:           iCloud configuration
 
 - throws: error if the store cannot be initialized
 
 - returns: initialized persistent store
 */
internal func cdiCloudInitializeStore(storeCoordinator storeCoordinator: NSPersistentStoreCoordinator, iCloud: iCloudConfig) throws -> (CoreData.Store, NSPersistentStore!) {
    let storeURL = NSFileManager.defaultManager()
        .URLForUbiquityContainerIdentifier(iCloud.ubiquitousContainerIdentifier)!
        .URLByAppendingPathComponent(iCloud.ubiquitousContentURL)
    var options = CoreData.Options.Migration.dict()
    options[NSPersistentStoreUbiquitousContentURLKey] = storeURL
    options[NSPersistentStoreUbiquitousContentNameKey] = iCloud.ubiquitousContentName
    let store = CoreData.Store.URL(storeURL)
    return try (store, cdAddPersistentStore(store, storeCoordinator: storeCoordinator, options: options))
}
