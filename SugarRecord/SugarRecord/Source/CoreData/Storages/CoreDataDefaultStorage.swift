//import Foundation
//import CoreData
//
///// Default CoreData storage with an stack base on PSC <=> Private Context <=> Main Context <=> Private Context
///// High load operations are executed in private contexts without affecting the Main Context used from the main thread for UI data presentation
//public class CoreDataDefaultStorage {
//    
//    
//    // MARK: - Attributes
//    
//    private let objectModel: NSManagedObjectModel
//    private let persistentStore: NSPersistentStore
//    private let persistentStoreCoordinator: NSPersistentStoreCoordinator
//    
//    
//    // MARK: - Storage (Attributes)
//    
////    var mainContext: Context
////    
////    var saveContext: Context {
////        get {
////            //TODO
////        }
////    }
////    
////    var memoryContext: Context {
////        get {
////            //TODO
////        }
////    }
//    
//    
//    // MARK: - Storage (methods)
//    
//    public func operation(queue: dispatch_queue_t, operation: (context: Context, save: () -> Void) -> Void) {
//        //TODO
//    }
//    
//    public func remove() {
//        //TODO
//    }
//    
//    
//    // MARK: - Init
//    
//    public init(store: CoreData.Store, model: CoreData.ObjectModel, migrate: Bool = true) throws {
//        guard let objectModel = model.model() else { throw CoreData.Error.InvalidModel(model) }
//        self.objectModel = objectModel
//        self.persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: objectModel)
//        self.persistentStore = try initializeStore(store, storeCoordinator: persistentStoreCoordinator, migrate: migrate)
//    }
//    
//    
//    // MARK: - Private
//    
//}
//
//
//private func initializeStore(store: CoreData.Store, storeCoordinator: NSPersistentStoreCoordinator, migrate: Bool) throws -> NSPersistentStore {
//    try createStoreParentPathIfNeeded(store)
//    let options = migrate ? CoreData.Options.Migration : CoreData.Options.Default
//    let store: NSPersistentStore = try addPersistentStore(store, storeCoordinator: storeCoordinator, options: options.dict())
//    
//}
//
//
//private func createStoreParentPathIfNeeded(store: CoreData.Store) throws {
//    if let databaseParentPath = store.path().URLByDeletingLastPathComponent  {
//        try NSFileManager.defaultManager().createDirectoryAtURL(databaseParentPath, withIntermediateDirectories: true, attributes: nil)
//    }
//}
//
///**
// Creates a NSpersistentStore
// 
// - parameter store:            store information
// - parameter storeCoordinator: persistent store coordinator
// - parameter options:          store options
// 
// - throws: an error if the store cannot be added co the coordinator
// 
// - returns: persistent store
// */
//private func addPersistentStore(store: CoreData.Store, storeCoordinator: NSPersistentStoreCoordinator, options: [NSObject: AnyObject]) throws -> NSPersistentStore {
//    var persistentStore: NSPersistentStore?
//    storeCoordinator.performBlockAndWait { () -> Void in
//        persistentStore = try! storeCoordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: store.path(), options: options)
//    }
//    return persistentStore!
//}
