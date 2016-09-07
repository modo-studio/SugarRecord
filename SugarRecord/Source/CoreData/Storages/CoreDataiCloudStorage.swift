import Foundation
import CoreData

public class CoreDataiCloudStorage: Storage {
    
    // MARK: - Attributes
    
    internal let store: CoreData.Store
    internal var objectModel: NSManagedObjectModel! = nil
    internal var persistentStore: NSPersistentStore! = nil
    internal var persistentStoreCoordinator: NSPersistentStoreCoordinator! = nil
    internal var rootSavingContext: NSManagedObjectContext! = nil

    
    // MARK: - Storage
    
    public var description: String {
        get {
            return "CoreDataiCloudStorage"
        }
    }
    public var type: StorageType = .CoreData
    
    public var mainContext: Context!
    
    public var saveContext: Context! {
        get {
            let context = cdContext(withParent: .Context(self.rootSavingContext), concurrencyType: .PrivateQueueConcurrencyType, inMemory: false)
            context.observe(inMainThread: true) { [weak self] (notification) -> Void in
                (self?.mainContext as? NSManagedObjectContext)?.mergeChangesFromContextDidSaveNotification(notification)
            }
            return context
        }
    }
    
    public var memoryContext: Context! {
        get {
            let context =  cdContext(withParent: .Context(self.rootSavingContext), concurrencyType: .PrivateQueueConcurrencyType, inMemory: true)
            return context
        }
    }
    
    public func operation<T>(operation: (context: Context, save: () -> Void) throws -> T) throws -> T {
        let context: NSManagedObjectContext = (self.saveContext as? NSManagedObjectContext)!
        var _error: ErrorType!
        
        var returnedObject: T!
        
        context.performBlockAndWait {
            do {
                returnedObject = try operation(context: context, save: { () -> Void  in
                    do {
                        try context.save()
                    }
                    catch {
                        _error = error
                    }
                    if self.rootSavingContext.hasChanges {
                        self.rootSavingContext.performBlockAndWait {
                            do {
                                try self.rootSavingContext.save()
                            }
                            catch {
                                _error = error
                            }
                        }
                    }
                })
            }
            catch {
                _error = error
            }
        }
        if let error = _error {
            throw error
        }
        
        return returnedObject
    }
    
    public func removeStore() throws {
        try NSFileManager.defaultManager().removeItemAtURL(store.path())
    }
    
    
    // MARK: - Init
    
    public convenience init(model: CoreData.ObjectModel, iCloud: ICloudConfig) throws {
        try self.init(model: model, iCloud: iCloud, versionController: VersionController())
    }
    
    internal init(model: CoreData.ObjectModel, iCloud: ICloudConfig, versionController: VersionController) throws {
        self.objectModel = model.model()!
        self.persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: objectModel)
        (self.store, self.persistentStore) = try! cdiCloudInitializeStore(storeCoordinator: persistentStoreCoordinator, iCloud: iCloud)
        self.rootSavingContext = cdContext(withParent: .Coordinator(self.persistentStoreCoordinator), concurrencyType: .PrivateQueueConcurrencyType, inMemory: false)
        self.mainContext = cdContext(withParent: .Context(self.rootSavingContext), concurrencyType: .MainQueueConcurrencyType, inMemory: false)
        self.observeiCloudChangesInCoordinator()
        #if DEBUG
        versionController.check()
        #endif
    }
    
    
    // MARK: - Public

#if os(iOS) || os(tvOS) || os(watchOS)
    
    public func observable<T: NSManagedObject where T:Equatable>(request: Request<T>) -> RequestObservable<T> {
        return CoreDataObservable(request: request, context: self.mainContext as! NSManagedObjectContext)
    }
    
#endif
    
    // MARK: - Private
    
    private func observeiCloudChangesInCoordinator() {
        NSNotificationCenter
            .defaultCenter()
            .addObserverForName(NSPersistentStoreDidImportUbiquitousContentChangesNotification, object: self.persistentStoreCoordinator, queue: nil) { [weak self] (notification) -> Void in
                self?.rootSavingContext.performBlock {
                    self?.rootSavingContext.mergeChangesFromContextDidSaveNotification(notification)
                }
            }
    }
    
}

internal func cdiCloudInitializeStore(storeCoordinator storeCoordinator: NSPersistentStoreCoordinator, iCloud: ICloudConfig) throws -> (CoreData.Store, NSPersistentStore!) {
    let storeURL = NSFileManager.defaultManager()
        .URLForUbiquityContainerIdentifier(iCloud.ubiquitousContainerIdentifier)!
        .URLByAppendingPathComponent(iCloud.ubiquitousContentURL)
    var options = CoreData.Options.Migration.dict()
    options[NSPersistentStoreUbiquitousContentURLKey] = storeURL
    options[NSPersistentStoreUbiquitousContentNameKey] = iCloud.ubiquitousContentName
    let store = CoreData.Store.URL(storeURL!)
    return try (store, cdAddPersistentStore(store, storeCoordinator: storeCoordinator, options: options))
}
