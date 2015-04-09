//
//  DefaultCDStack.swift
//  SugarRecord
//
//  Created by Pedro Piñera Buendía on 15/09/14.
//  Copyright (c) 2014 SugarRecord. All rights reserved.
//

import Foundation
import CoreData

public class DefaultCDStack: SugarRecordStackProtocol
{
    
    //MARK: - Class properties
    public var name: String = "DefaultCoreDataStack"
    public var stackDescription: String = "Default core data stack with an efficient context management"
    public var defaultStoreName: String = "sugar.sqlite"
    public let stackType: SugarRecordEngine = SugarRecordEngine.SugarRecordEngineCoreData
    public var migrationFailedClosure: () -> ()
    public var stackInitialized: Bool = false
    public var autoSaving: Bool = false
    internal var managedObjectModel: NSManagedObjectModel?
    internal var databasePath: NSURL?
    internal var automigrating: Bool
    internal var persistentStoreCoordinator: NSPersistentStoreCoordinator?
    internal var rootSavingContext: NSManagedObjectContext?
    internal var mainContext: NSManagedObjectContext?
    internal var persistentStore: NSPersistentStore?
    
    //MARK: - Initializers
    
    /**
    Initialize the CoreData default stack passing the database path URL and a flag indicating if the automigration has to be automatically executed
    
    :param: databaseURL   NSURL with the database path
    :param: model         NSManagedObjectModel with the database model
    :param: automigrating Bool Indicating if the migration has to be automatically executed
    
    :returns: DefaultCDStack object
    */
    public init(databaseURL: NSURL, model: NSManagedObjectModel?, automigrating: Bool)
    {
        self.automigrating = automigrating
        self.databasePath = databaseURL
        self.managedObjectModel = model
        self.migrationFailedClosure = {}
        self.addObservers()
    }
    
    /**
    Initialize the CoreData default stack passing the database name and a flag indicating if the automigration has to be automatically executed
    
    :param: databaseName  String with the database name
    :param: automigrating Bool Indicating if the migration has to be automatically executed
    
    :returns: DefaultCDStack object
    */
    convenience public init(databaseName: String, automigrating: Bool)
    {
        self.init(databaseURL: DefaultCDStack.databasePathURLFromName(databaseName), automigrating: automigrating)
    }
    
    /**
    Initialize the CoreData default stack passing the database path in String format and a flag indicating if the automigration has to be automatically executed
    
    :param: databasePath  String with the database path
    :param: automigrating Bool Indicating if the migration has to be automatically executed
    
    :returns: DefaultCDStack object
    */
    convenience public init(databasePath: String, automigrating: Bool)
    {
        self.init(databaseURL: NSURL(fileURLWithPath: databasePath)!, automigrating: automigrating)
    }
    
    /**
    Initialize the CoreData default stack passing the database path URL and a flag indicating if the automigration has to be automatically executed
    
    :param: databaseURL   NSURL with the database path
    :param: automigrating Bool Indicating if the migration has to be automatically executed
    
    :returns: DefaultCDStack object
    */
    convenience public init(databaseURL: NSURL, automigrating: Bool)
    {
        self.init(databaseURL: databaseURL, model: nil, automigrating: automigrating)
    }
    
    /**
    Initialize the CoreData default stack passing the database name, the database model object and a flag indicating if the automigration has to be automatically executed
    
    :param: databaseName  String with the database name
    :param: model         NSManagedObjectModel with the database model
    :param: automigrating Bool indicating if the migration has to be automatically executed
    
    :returns: DefaultCDStack object
    */
    convenience public init(databaseName: String, model: NSManagedObjectModel, automigrating: Bool)
    {
        self.init(databaseURL: DefaultCDStack.databasePathURLFromName(databaseName), model: model, automigrating: automigrating)
    }
    
    /**
    Initialize the CoreData default stack passing the database path in String format, the database model object and a flag indicating if the automigration has to be automatically executed
    
    :param: databasePath  String with the database path
    :param: model         NSManagedObjectModel with the database model
    :param: automigrating Bool indicating if the migration has to be automatically executed
    
    :returns: DefaultCDStack object
    */
    convenience public init(databasePath: String, model: NSManagedObjectModel, automigrating: Bool)
    {
        self.init(databaseURL: NSURL(fileURLWithPath: databasePath)!, model: model, automigrating: automigrating)
    }

    /**
    Initialize the stacks components and the connections between them
    */
    public func initialize()
    {
        SugarRecordLogger.logLevelInfo.log("Initializing the stack: \(name)")
        createManagedObjecModelIfNeeded()
        persistentStoreCoordinator = createPersistentStoreCoordinator()
        addDatabase(dataBaseAddedClosure())
    }
    
    /**
    Returns the closure to be execute once the database has been created
    */
    public func dataBaseAddedClosure() -> CompletionClosure {
        return { [weak self] (error) -> () in
            if self == nil {
                SugarRecordLogger.logLevelFatal.log("The stack was released whil trying to initialize it")
                return
            }
            else if error != nil {
                SugarRecordLogger.logLevelFatal.log("Something went wrong adding the database")
                return
            }
            self!.rootSavingContext = self!.createRootSavingContext(self!.persistentStoreCoordinator)
            self!.mainContext = self!.createMainContext(self!.rootSavingContext)
            self!.stackInitialized = true
        }
    }
    
    /**
    Clean up the stack an all its components
    */
    public func cleanup()
    {
        // Nothing to do here
    }
    
    /**
    Call received when the application will resign active
    Note: In case of overriding it ensure you call super.applicationWillResignActive()
    */
    public func applicationWillResignActive()
    {
        saveChanges()
    }
    
    /**
    Call received when the application will terminate
    Note: In case of overriding it ensure you call super.applicationWillTerminate()
    */
    public func applicationWillTerminate()
    {
        saveChanges()
    }
    
    /**
    Call received when the application will enter foreground
    Note: In case of overriding it ensure you call super.applicationWillEnterForeground()
    */
    public func applicationWillEnterForeground()
    {
        // Nothing to do here
    }
    
    /**
    Creates a background saving context and returns a SugarRecord CoreData context with it
    
    :returns: SugarRecordCDContext with the background context
    */
    public func backgroundContext() -> SugarRecordContext?
    {
        if self.rootSavingContext == nil {
            return nil
        }
        var context: NSManagedObjectContext = NSManagedObjectContext(concurrencyType: .ConfinementConcurrencyType)
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        context.parentContext = self.rootSavingContext!
        if self.mainContext != nil {
            self.mainContext?.startObserving(context, inMainThread: true)
        }
        return SugarRecordCDContext(context: context)
    }
    
    /**
    Returns a SugarRecordCDContext with the main stack context to be used in the main thread
    
    :returns: SugarRecordCDContext with the main context
    */
    public func mainThreadContext() -> SugarRecordContext?
    {
        if self.mainContext == nil {
            return nil
        }
        return SugarRecordCDContext(context: self.mainContext!)
    }
    
    /**
    Removes the local database
    */
    public func removeDatabase()
    {
        SugarRecordLogger.logLevelVerbose.log("Removing database")
        var error: NSError?
        if databasePath == nil {
            SugarRecord.handle(NSException(name: "CoreData database deletion error", reason: "Couldn't delete the database because the path was nil", userInfo: nil))
            return
        }
        if NSFileManager.defaultManager().fileExistsAtPath(databasePath!.path!) {
            NSFileManager.defaultManager().removeItemAtURL(databasePath!, error: &error)
            SugarRecord.handle(error)
        }
    }
    
    
    //MARK: - Observers
    
    /**
    Add observers to listen events in the stack
    */
    internal func addObservers() {}
    
    /**
    Returns the notification center that is going to be used to listen events
    d
    :returns: NSNotification center used by the stack
    */
    internal func notificationCenter() -> NSNotificationCenter
    {
        return NSNotificationCenter.defaultCenter()
    }
    
    /**
    Closure for AutoSaving changes
    */
    internal func autoSavingClosure() -> () -> ()
    {
        return { [weak self] (notification) -> Void in
            if (self != nil  && self!.autoSaving) {
                _ = self!.saveChanges()
            }
        }
    }
    
    
    //MARK: - Creation helper
    
    /**
    Creates the main stack context
    
    :param: parentContext NSManagedObjectContext to be set as the parent of the main context
    
    :returns: Main NSManageObjectContext
    */
    internal func createMainContext(parentContext: NSManagedObjectContext?) -> NSManagedObjectContext
    {
        SugarRecordLogger.logLevelVerbose.log("Creating Main context")
        var context: NSManagedObjectContext?
        if parentContext == nil {
            SugarRecord.handle(NSError(domain: "The root saving context is not initialized", code: SugarRecordErrorCodes.CoreDataError.rawValue, userInfo: nil))
        }
        context = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        context!.parentContext = parentContext!
        context!.addObserverToGetPermanentIDsBeforeSaving()
        if context!.respondsToSelector(Selector("name")) {
            context!.name = "Main context"
        }
        SugarRecordLogger.logLevelVerbose.log("Created MAIN context")
        return context!
    }
    
    /**
    Creates a temporary root saving context to be used in background operations
    
    :param: persistentStoreCoordinator NSPersistentStoreCoordinator to be set as the persistent store coordinator of the created context
    
    :returns: Private NSManageObjectContext
    */
    internal func createRootSavingContext(persistentStoreCoordinator: NSPersistentStoreCoordinator?) -> NSManagedObjectContext
    {
        SugarRecordLogger.logLevelVerbose.log("Creating Root Saving context")
        var context: NSManagedObjectContext?
        if persistentStoreCoordinator == nil {
            SugarRecord.handle(NSError(domain: "The persistent store coordinator is not initialized", code: SugarRecordErrorCodes.CoreDataError.rawValue, userInfo: nil))
        }
        context = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        context!.persistentStoreCoordinator = persistentStoreCoordinator!
        context!.addObserverToGetPermanentIDsBeforeSaving()
        context!.addObserverWhenObjectsChanged { [weak self] () -> () in
            let closure = self?.autoSavingClosure()
            closure?()
        }
        if context!.respondsToSelector(Selector("name")) {
            context!.name = "Root saving context"
        }
        SugarRecordLogger.logLevelVerbose.log("Created Root Saving context")
        return context!
    }
    
    /**
    Creates the ManagedObject model if it's needed
    */
    internal func createManagedObjecModelIfNeeded()
    {
        if managedObjectModel == nil {
            managedObjectModel = NSManagedObjectModel.mergedModelFromBundles(nil)
        }
    }
    
    /**
    Creates the stack's persistent store coordinator
    
    :returns: NSPersistentStoreCoordinator of the stack
    */
    internal func createPersistentStoreCoordinator() -> NSPersistentStoreCoordinator
    {
        var coordinator: NSPersistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel!)
        return coordinator
    }
    
    //MARK: - Database helper
    
    /**
    Check if the database exists (if not it creates it), then it initializes the persistent store and executes the migration in case of needed
    */
    internal func addDatabase(completionClosure: CompletionClosure)
    {
        var error: NSError?
        self.createPathIfNecessary(forFilePath: self.databasePath!)
        var store: NSPersistentStore?
        
        // Checking that the PSC exists before adding the store
        if self.persistentStoreCoordinator == nil {
            SugarRecord.handle(NSError(domain: "Trying to initialize the store without persistent store coordinator", code: SugarRecordErrorCodes.LibraryError.rawValue, userInfo: nil))
        }
        
        // Adding the store
        self.persistentStoreCoordinator!.lock()
        if self.automigrating {
            store = self.persistentStoreCoordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: self.databasePath!, options: DefaultCDStack.autoMigrateStoreOptions(), error: &error)
        }
        else {
            store = self.persistentStoreCoordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: self.databasePath!, options: DefaultCDStack.defaultStoreOptions(), error: &error)
        }
        self.persistentStoreCoordinator!.unlock()
        
        // Executing forced migration in case of that something went wrong
        let isMigratingError = error?.code == NSPersistentStoreIncompatibleVersionHashError || error?.code == NSMigrationMissingSourceModelError
        if (error?.domain == NSCocoaErrorDomain as String) && isMigratingError {
            var deleteError: NSError?
            let rawURL: String = self.databasePath!.absoluteString!
            let shmSidecar: NSURL = NSURL(string: rawURL.stringByAppendingString("-shm"))!
            let walSidecar: NSURL = NSURL(string: rawURL.stringByAppendingString("-wal"))!
            NSFileManager.defaultManager().removeItemAtURL(self.databasePath!, error: &deleteError)
            NSFileManager.defaultManager().removeItemAtURL(shmSidecar, error: &error)
            NSFileManager.defaultManager().removeItemAtURL(walSidecar, error: &error)
            SugarRecordLogger.logLevelWarn.log("Incompatible model version has been removed \(self.databasePath!.lastPathComponent)")
            if deleteError != nil {
                SugarRecordLogger.logLevelError.log("Could not delete store. Error: \(deleteError?.localizedDescription)")
            }
            else {
                SugarRecordLogger.logLevelInfo.log("Did delete store")
            }
            SugarRecordLogger.logLevelInfo.log("Will recreate store")
            self.persistentStoreCoordinator!.lock()
            store = self.persistentStoreCoordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: self.databasePath, options: DefaultCDStack.defaultStoreOptions(), error: &error)
            SugarRecordLogger.logLevelInfo.log("Did recreate store")
            self.migrationFailedClosure()
            self.persistentStoreCoordinator!.unlock()
            error = nil
        }
        else {
            SugarRecord.handle(error)
        }
        self.persistentStore = store!
        
        // Calling completion closure
        completionClosure(error: nil)
    }
    
    /**
    Creates a path if necessary in a given route
    
    :param: filePath NSURL with the whose folder is going to be created
    */
    public func createPathIfNecessary(forFilePath filePath:NSURL)
    {
        let fileManager: NSFileManager = NSFileManager.defaultManager()
        let path: NSURL = filePath.URLByDeletingLastPathComponent!
        var error: NSError?
        var pathWasCreated: Bool = fileManager.createDirectoryAtPath(path.path!, withIntermediateDirectories: true, attributes: nil, error: &error)
        if !pathWasCreated {
            SugarRecord.handle(error!)
        }
    }
    
    /**
    Returns the automigration options to be used when the NSPersistentStore is initialized
    
    :returns: [NSObject: AnyObject] with the options
    */
    internal class func autoMigrateStoreOptions() -> [NSObject: AnyObject]
    {
        var sqliteOptions: [String: String] = [String: String] ()
        sqliteOptions["WAL"] = "journal_mode"
        var options: [NSObject: AnyObject] = [NSObject: AnyObject] ()
        options[NSMigratePersistentStoresAutomaticallyOption] = NSNumber(bool: true)
        options[NSInferMappingModelAutomaticallyOption] = NSNumber(bool: true)
        options[NSSQLitePragmasOption] = sqliteOptions
        return options
    }
    
    /**
    Returns the default options to be used when the NSPersistentStore is initialized
    
    :returns: [NSObject: AnyObject] with the options
    */
    internal class func defaultStoreOptions() -> [NSObject: AnyObject]
    {
        var sqliteOptions: [String: String] = [String: String] ()
        sqliteOptions["WAL"] = "journal_mode"
        var options: [NSObject: AnyObject] = [NSObject: AnyObject] ()
        options[NSMigratePersistentStoresAutomaticallyOption] = NSNumber(bool: true)
        options[NSInferMappingModelAutomaticallyOption] = NSNumber(bool: false)
        options[NSSQLitePragmasOption] = sqliteOptions
        return options
    }
    
    /**
    Returns the database path URL for a given name
    
    :param: name String with the database name
    
    :returns: NSURL with the path
    */
    internal class func databasePathURLFromName(name: String) -> NSURL
    {
        let documentsPath: String = NSSearchPathForDirectoriesInDomains(.ApplicationSupportDirectory, .UserDomainMask, true)[0] as! String
        let mainBundleInfo: [NSObject: AnyObject] = NSBundle.mainBundle().infoDictionary!
        let applicationPath: String = documentsPath.stringByAppendingPathComponent("store")
        
        let paths: [String] = [documentsPath, applicationPath]
        for path in paths {
            let databasePath: String = path.stringByAppendingPathComponent(name)
            if NSFileManager.defaultManager().fileExistsAtPath(databasePath) {
                return NSURL(fileURLWithPath: databasePath)!
            }
        }
        let databasePath: String = applicationPath.stringByAppendingPathComponent(name)
        return NSURL(fileURLWithPath: databasePath)!
    }
    
    
    //MARK: - Saving helper
    
    /**
    Apply the changes of the context to be persisted in the database
    */
    internal func saveChanges ()
    {
        if self.rootSavingContext == nil {
            assert(true, "Fatal error. The private context is not initialized")
        }
        else if self.mainContext == nil {
            assert(true, "Fatal error. The main context is not initialized")
        }
        
        // Defining saving closure
        typealias SavingClosure = (context: NSManagedObjectContext) -> ()
        let save: SavingClosure = { (context: NSManagedObjectContext) in
            var error: NSError?
            context.save(&error)
            if error != nil {
                let exception: NSException = NSException(name: "Context saving exception", reason: "Pending changes in the root savinv context couldn't be saved", userInfo: ["error": error!])
                SugarRecord.handle(exception)
            }
            else {
                SugarRecordLogger.logLevelInfo.log("Existing changes persisted to the database")
            }
            context.reset()
        }
        
        // Saving ROOT SAVING CONTEXT
        self.rootSavingContext!.performBlockAndWait({ () -> Void in
            if self.rootSavingContext!.hasChanges {
                save(context: self.rootSavingContext!)
            }
        })
    }
}


/**
*  Extension to add some extra methods related with KVO like:
*   - Observing when the context is going to be saved to get permanent IDs before saving
*   - Observing when the another context changes and then bring these changes
*/
public extension NSManagedObjectContext
{
    /**
    Add observer of self to check when is going to save to ensure items are saved with permanent IDs
    */
    func addObserverToGetPermanentIDsBeforeSaving() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("contextWillSave:"), name: NSManagedObjectContextWillSaveNotification, object: self)
    }
    
    /**
    Adds an observer when the context's objects have changed
    
    :param: closure Closure to be executed then objects have changed
    */
    func addObserverWhenObjectsChanged(closure: () -> ()) {
        NSNotificationCenter.defaultCenter().addObserverForName(NSManagedObjectContextObjectsDidChangeNotification, object: self, queue: nil) { (notification) -> Void in
            _ = closure()
        }
    }
    
    /**
    Method executed before saving that convert temporary IDs into permanet ones
    
    :param: notification Notification that fired this method
    */
    func contextWillSave(notification: NSNotification) {
        let context: NSManagedObjectContext = notification.object as! NSManagedObjectContext
        let insertedObjects: NSSet = context.insertedObjects
        if insertedObjects.count == 0{
            return
        }
        SugarRecordLogger.logLevelInfo.log("Saving: obtaining permanent IDs for \(insertedObjects.count) new inserted objects")
        var error: NSError?
        let saved: Bool = context.obtainPermanentIDsForObjects(insertedObjects.allObjects, error: &error)
        if !saved {
            SugarRecordLogger.logLevelError.log("Error moving temporary IDs into permanent ones - \(error)")
        }
    }
    
    /**
    Add observer of other context
    
    :param: context    NSManagedObjectContext to be observed
    :param: mainThread Bool indicating if it's the main thread
    */
    func startObserving(context: NSManagedObjectContext, inMainThread mainThread: Bool) {
        SugarRecordLogger.logLevelVerbose.log("\(self) context now observing the context \(context)")
        if mainThread {
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "mergeChangesInMainThread:", name: NSManagedObjectContextDidSaveNotification, object: context)
        }
        else {
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "mergeChanges:", name: NSManagedObjectContextDidSaveNotification, object: context)
        }
    }
    
    /**
    Stop observing changes from other contexts
    
    :param: context NSManagedObjectContext that is going to stop observing to
    */
    func stopObserving(context: NSManagedObjectContext) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: NSManagedObjectContextDidSaveNotification, object: nil)
    }
    
    /**
    Method to merge changes from other contexts (fired by KVO)
    
    :param: notification Notification that fired this method call
    */
    func mergeChanges(notification: NSNotification) {
        SugarRecordLogger.logLevelInfo.log("Merging changes to context \(self)")
        self.mergeChangesFromContextDidSaveNotification(notification)
    }
    
    /**
    Method to merge changes from other contexts (in the main thread)
    
    :param: notification Notification that fired this method call
    */
    func mergeChangesInMainThread(notification: NSNotification) {
        dispatch_async(dispatch_get_main_queue(), {
            self.mergeChanges(notification)
        })
    }
}
