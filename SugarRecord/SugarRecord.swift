//
//  SugarRecord.swift
//  SugarRecord
//
//  Created by Pedro Piñera Buendía on 03/08/14.
//  Copyright (c) 2014 PPinera. All rights reserved.
//

import Foundation
import CoreData

let srDefaultDatabaseName: String = "sugarRecordDatabase.sqlite"
let srSugarRecordVersion: String = "v0.0.1 - Alpha"
let srBackgroundQueueName: String = "sugarRecord.backgroundQueue"

// Static variables - RELATED WITH OPTIONS ENABLED/DISABLED
var srShouldAutoCreateManagedObjectModel: Bool = true
var srShouldAutoCreateDefaultPersistentStoreCoordinator: Bool = false
var srsrShouldDeleteStoreOnModelMismatch: Bool = true

// Static variables - DICTIONARY KEYS
var srContextWorkingNameKey = "srContextWorkingNameKey"

// Static variables - RELATED WITH KVO KEYS
var srKVOWillDeleteDatabaseKey: String = "srKVOWillDeleteDatabaseKey"
var srKVOPSCMismatchCouldNotDeleteStore: String = "srKVOPSCMismatchCouldNotDeleteStore"
var srKVOPSCMismatchDidDeleteStore: String = "srKVOPSCMismatchDidDeleteStore"
var srKVOPSCMismatchWillRecreateStore = "KVOPSCMismatchWillRecreateStore"
var srKVOPSCMismatchDidRecreateStore = "srKVOPSCMismatchDidRecreateStore"
var srKVOPSCMMismatchCouldNotRecreateStore = "srKVOPSCMMismatchCouldNotRecreateStore"
var srKVOCleanedUpNotification = "srKVOCleanedUpNotification"

// MARK - SugarRecordLogger
enum SugarRecordLogger: Int {
    static var currentLevel: SugarRecordLogger = .logLevelInfo
    case logLevelFatal, logLevelError, logLevelWarm, logLevelInfo, logLevelVerbose
    func log(let logMessage: String) -> () {
        switch self {
        case .logLevelFatal:
            print("SR-Fatal: \(logMessage) \n")
        case .logLevelError:
            if SugarRecordLogger.currentLevel == .logLevelFatal {
                return
            }
            print("SR-Error: \(logMessage) \n")
        case .logLevelWarm:
            if SugarRecordLogger.currentLevel == .logLevelFatal ||
                SugarRecordLogger.currentLevel == .logLevelError {
                    return
            }
            print("SR-Warm: \(logMessage) \n")
            
        case .logLevelInfo:
            if SugarRecordLogger.currentLevel == .logLevelFatal ||
                SugarRecordLogger.currentLevel == .logLevelError ||
                SugarRecordLogger.currentLevel == .logLevelWarm {
                    return
            }
            print("SR-Info: \(logMessage) \n")
        default:
            if SugarRecordLogger.currentLevel == .logLevelFatal ||
                SugarRecordLogger.currentLevel == .logLevelError ||
                SugarRecordLogger.currentLevel == .logLevelWarm ||
                SugarRecordLogger.currentLevel == .logLevelInfo{
                    return
            }
            print("SR-Verbose: \(logMessage) \n")
        }
    }
}


// MARK - SugarRecord Methods
class SugarRecord {
    
    // Static variables
    struct Static {
        static var onceToken : dispatch_once_t = 0
        static var instance : SugarRecord? = nil
        static var backgroundQueue : dispatch_queue_t? = nil
    }
    
    // Initialize Database
    class func setupCoreDataStack (automigrating: Bool?, databaseName: String?) -> () {
        // Checking the coordinator doesn't exist
        var psc: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator.defaultPersistentStoreCoordinator()
        if psc != nil {
            return
        }
        
        // Initializing persistentStoreCoordinator
        if databaseName != nil {
            psc = NSPersistentStoreCoordinator.newCoordinator(databaseName!, automigrating: automigrating)
        }
        else {
            psc = NSPersistentStoreCoordinator.newCoordinator(self.defaultDatabaseName(), automigrating: automigrating)
        }
        
        // Setting as default persistent store coordinator
        NSPersistentStoreCoordinator.setDefaultPersistentStoreCoordinator(psc!)
        
        // Initialize stack
        NSManagedObjectContext.initializeContextsStack(psc!)
    }
    
    // Background queue
    class func backgroundQueue() -> (dispatch_queue_t) {
        if Static.backgroundQueue == nil {
            Static.backgroundQueue = dispatch_queue_create(srBackgroundQueueName, 0)
        }
        return Static.backgroundQueue!
    }

    
    // CleanUp
    class func cleanUp () -> () {
        self.cleanUpStack()
        NSNotificationCenter.defaultCenter().postNotificationName(srKVOCleanedUpNotification, object: nil)
    }
    class func cleanUpStack() {
        NSManagedObjectContext.cleanUp()
        NSManagedObjectModel.cleanUp()
        NSPersistentStoreCoordinator.cleanUp()
        NSPersistentStore.cleanUp()
    }
    
    
    // Returns current stack information
    class func currentStack () -> (stack: String?) {
        var status: String = "SugarRecord stack \n ------- \n"
        status += "Model:       \(NSManagedObjectModel.defaultManagedObjectModel())\n"
        status += "Coordinator:       \(NSPersistentStoreCoordinator.defaultPersistentStoreCoordinator())\n"
        status += "Store:       \(NSPersistentStore.defaultPersistentStore())\n"
        status += "Default context:       \(NSManagedObjectContext.defaultContext())\n"
        status += "Saving context:       \(NSManagedObjectContext.rootSavingContext())\n"
        return nil
    }
    
    // Returns current SugarRecord version
    class func currentVersion() -> (version: String) {
        return srSugarRecordVersion
    }
    
    // Returns the default Database name
    class func defaultDatabaseName () -> (databaseName: String){
        var databaseName: String
        let bundleName: AnyObject? = NSBundle.mainBundle().infoDictionary[kCFBundleNameKey]
        if let name = bundleName as? String {
            databaseName = name
        }
        else {
            databaseName = srDefaultDatabaseName
        }
        if !databaseName.hasSuffix("sqlite") {
            databaseName = databaseName.stringByAppendingPathExtension("sqlite")
        }
        return databaseName
    }
    
    
    // Threading //
    class func save(inBackground background: Bool, savingBlock: (context: NSManagedObjectContext) -> (), completion: (success: Bool, error: NSError?) -> ()) {
        dispatch_async(SugarRecord.backgroundQueue(), {
            self.save(true, savingBlock: savingBlock, completion: completion)
        })
    }
    

    class func save(synchronously: Bool, savingBlock: (context: NSManagedObjectContext) -> (), completion: (success: Bool, error: NSError?) -> ()) {
        // Generating context
        var privateContext: NSManagedObjectContext = NSManagedObjectContext.newContextWithParentContext(NSManagedObjectContext.rootSavingContext()!)
        
        // Executing block
        if synchronously {
            privateContext.performBlockAndWait({ () -> Void in
                savingBlock(context: privateContext)
                privateContext.save(true, savingParents: true, completion: completion)
            })
        }
        else {
            privateContext.performBlock({ () -> Void in
                savingBlock(context: privateContext)
                privateContext.save(false, savingParents: true, completion: completion)
            })
        }
    }
    
    class func background(block: (context: NSManagedObjectContext) -> ()) {
        dispatch_async(SugarRecord.backgroundQueue(), {
            var privateContext: NSManagedObjectContext = NSManagedObjectContext.newContextWithParentContext(NSManagedObjectContext.rootSavingContext()!)
            privateContext.performBlockAndWait({ () -> Void in
                block(context: privateContext)
            })
        })
    }
}

// MARK - Extension SugarRecord + Error Handling

extension SugarRecord {
    class func handle(error: NSError?) {
        
    }
    class func handle(exception: NSException?) {
        
    }
    
}


// MARK - NSManagedObjectContext Extension

extension NSManagedObjectContext {
    // Static variables
    struct Static {
        static var rootSavingContext: NSManagedObjectContext? = nil
        static var defaultContext: NSManagedObjectContext? = nil
    }
    
    // Root Saving Context Getter
    class func rootSavingContext() -> (NSManagedObjectContext?) {
        return Static.rootSavingContext
    }
    
    // Root Saving Context Setter
    class func setRootSavingContext(context: NSManagedObjectContext?) {
        if Static.rootSavingContext != nil  {
            NSNotificationCenter.defaultCenter().removeObserver(Static.rootSavingContext)
        }
        Static.rootSavingContext = context
        if Static.rootSavingContext == nil {
            return
        }
        Static.rootSavingContext!.addObserverToGetPermanentIDsBeforeSaving()
        Static.rootSavingContext!.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        Static.rootSavingContext!.setWorkingName("Root saving context")
        SugarRecordLogger.logLevelInfo.log("Changing root saving context")
    }
    
    
    // Default Context Getter
    class func defaultContext() -> (NSManagedObjectContext?) {
        return Static.defaultContext
    }
    
    // Default Context Setter
    class func setDefaultContext(context: NSManagedObjectContext?) {
        // Removing observer if existing defaultContext
        if Static.defaultContext != nil  {
            NSNotificationCenter.defaultCenter().removeObserver(Static.defaultContext)
        }
        Static.defaultContext = context
        if Static.defaultContext == nil {
            return
        }
        Static.defaultContext!.setWorkingName("Default context")
        SugarRecordLogger.logLevelInfo.log("Changing default context. New context: \(defaultContext())")
        // Adding observer to listn changes in rootContext
        if rootSavingContext() != nil {
            NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("rootContextChanged:"), name: NSManagedObjectContextDidSaveNotification, object: rootSavingContext())
        }
        Static.defaultContext!.addObserverToGetPermanentIDsBeforeSaving()

    }

    // Returns a new context with a given context as a parent
    class func newContextWithPersistentStoreCoordinator(persistentStoreCoordinator: NSPersistentStoreCoordinator) -> (NSManagedObjectContext){
        return self.newContext(nil, persistentStoreCoordinator: persistentStoreCoordinator)
    }

    // Returns a new context with a given context as a parent
    class func newContextWithParentContext(parentContext: NSManagedObjectContext) -> (NSManagedObjectContext){
        return self.newContext(parentContext, persistentStoreCoordinator: nil)
    }

    // Returns a new context with a parent context or persistentStoreCoordinator
    class func newContext (parentContext: NSManagedObjectContext?, persistentStoreCoordinator: NSPersistentStoreCoordinator?) -> (NSManagedObjectContext) {
        var newContext: NSManagedObjectContext?
        if parentContext != nil {
            newContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
            newContext?.parentContext = parentContext
        }
        else if persistentStoreCoordinator != nil {
            newContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
            newContext?.persistentStoreCoordinator = persistentStoreCoordinator
        }
        else {
            SugarRecordLogger.logLevelFatal.log("Either parentContext or persistentStoreCoordinator has to be passed")
        }
        SugarRecordLogger.logLevelInfo.log("Created new context - \(newContext)")
        return newContext!
    }

    // Initialize default contexts stack
    class func initializeContextsStack (persistentStoreCoordinator: NSPersistentStoreCoordinator)  {
        SugarRecordLogger.logLevelInfo.log("Creating contexts stack")
        var rootContext: NSManagedObjectContext = self.newContext(nil, persistentStoreCoordinator: persistentStoreCoordinator)
        self.setRootSavingContext(rootSavingContext()!)
        var defaultContext: NSManagedObjectContext = self.newContext(rootContext, persistentStoreCoordinator: nil)
    }
    
    // Debugging
    func setWorkingName(workingName: String) {
        self.userInfo.setObject(workingName, forKey: srContextWorkingNameKey)
    }
    func workingName() -> (String) {
        var workingName: String = self.userInfo.objectForKey(srContextWorkingNameKey) as String
        if workingName.isEmpty {
            workingName = "Unnamed context"
        }
        return workingName
    }
    func description() -> (String) {
        let onMainThread: String = NSThread.mainThread() ? "Main Thread" : "Background thread"
        return "<\(object_getClassName(self)) (\(self)): \(self.workingName()) on \(onMainThread)"
    }
    
    func parentChain () -> (String)
    {
        var familyTree: String = "\n"
        var currentContext: NSManagedObjectContext = self
        do {
            familyTree += " - \(currentContext.workingName()) (\(currentContext)) \n"
            familyTree += currentContext == self ? "(*)" : ""
            currentContext = currentContext.parentContext
        } while currentContext != nil
        return familyTree
    }
    
    class func resetDefaultContext() {
        var defaultContext: NSManagedObjectContext? = self.defaultContext()
        if defaultContext == nil {
            return
        }
        assert(defaultContext!.concurrencyType == .ConfinementConcurrencyType, "SR-Assert: Not call this method on a confinement context")
        if NSThread.isMainThread() == false {
            dispatch_async(dispatch_get_main_queue(), {
                self.resetDefaultContext()
                });
            return
        }
        defaultContext!.reset()
    }
    
    func delete(let objects: [NSManagedObject]) {
        for object in objects {
            self.deleteObject(object)
        }
    }
    
    // Saving
    func save(synchronously: Bool, savingParents: Bool, completion: (success: Bool, error: NSError?) -> ()) {
       var hasChanges: Bool = false
        if self.concurrencyType == .ConfinementConcurrencyType {
            hasChanges = self.hasChanges
        }
        else {
            self.performBlockAndWait({ () -> Void in
                hasChanges = self.hasChanges
            })
        }
        
        // If it doesn't have changes there's nothing to do
        if hasChanges {
            SugarRecordLogger.logLevelVerbose.log("No changes in context \(self.workingName()) - Not saving")
            if completion != nil {
                dispatch_async(dispatch_get_main_queue(), {
                        completion(success: false, error: nil)
                    })
            }
        }
        
        var saveBlock: () -> () = {
            var saveResult: Bool = false
            var error: NSError?
            saveResult = self.save(&error)
            if error != nil {
                SugarRecord.handle(error!)
            }
            if saveResult && savingParents && self.parentContext {
                self.parentContext.save(synchronously, savingParents: savingParents, completion: completion)
            }
            else {
                if saveResult {
                    SugarRecordLogger.logLevelVerbose.log("Finished saving \(self.description)")
                }
                if completion != nil {
                    dispatch_async(dispatch_get_main_queue(), {
                        if completion != nil {
                            completion(success: saveResult, error: error)
                        }
                    })
                }
            }
        }
        
        
        // Saving otherwise
        if synchronously {
            self.performBlockAndWait(saveBlock)
        }
        else {
            self.performBlock(saveBlock)
        }
    }
    
    // Observers
    func addObserverToGetPermanentIDsBeforeSaving() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("contextWillSave:"), name: NSManagedObjectContextWillSaveNotification, object: self)
    }
    
    func contextWillSave(notification: NSNotification) {
        let context: NSManagedObjectContext = notification.object as NSManagedObjectContext
        let insertedObjects: NSSet = context.insertedObjects
        if insertedObjects.count == 0{
            return
        }
        SugarRecordLogger.logLevelInfo.log("\(context.workingName()) is going to save: obtaining permanent IDs for \(insertedObjects.count) new inserted objects")
        var error: NSError?
        let saved: Bool = context.obtainPermanentIDsForObjects(insertedObjects.allObjects, error: &error)
        if !saved {
            SugarRecordLogger.logLevelError.log("Error moving temporary IDs into permanent ones - \(error)")
        }
        
    }
    
    class func rootContextChanged(notification: NSNotification) {
        if !NSThread.mainThread() {
            dispatch_async(dispatch_get_main_queue(), {
              self.rootContextChanged(notification)
            })
            return
        }
        self.defaultContext()?.mergeChangesFromContextDidSaveNotification(notification)
    }

    // Cleanup
    class func cleanUp(){
        self.setRootSavingContext(nil)
        self.setDefaultContext(nil)
    }
    
    // Contexts oberving
    func startObserving(context: NSManagedObjectContext, inMainThread mainThread: Bool) {
        if mainThread {
            NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("mergeChangesInMainThread:"), name: NSManagedObjectContextDidSaveNotification, object: context)
        }
        else {
            NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("mergeChanges:"), name: NSManagedObjectContextDidSaveNotification, object: context)
        }
    }
    func stopObserving(context: NSManagedObjectContext) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: NSManagedObjectContextDidSaveNotification, object: nil)
    }
    
    func mergeChanges(fromNotification notification: NSNotification) {
        SugarRecordLogger.logLevelInfo.log("Merging changes from context: \((notification.object as NSManagedObjectContext).workingName()) to context \(self.workingName())")
        self.mergeChangesFromContextDidSaveNotification(notification)
    }
    
    func mergeChangesInMainThread(fromNotification notification: NSNotification) {
        dispatch_async(dispatch_get_main_queue(), {
            self.mergeChanges(fromNotification: notification)
        })
    }
}


//MARK - NSManagedObjectModel Extension

extension NSManagedObjectModel {
    // Static variables
    struct Static {
        static var defaultManagedObjectModel: NSManagedObjectModel? = nil
    }
    
    class func setDefaultManagedObjectModel(objectModel: NSManagedObjectModel) {
        Static.defaultManagedObjectModel = objectModel
    }
    class func defaultManagedObjectModel() -> (defaultManagedObjectModel: NSManagedObjectModel) {
        var currentModel: NSManagedObjectModel? = Static.defaultManagedObjectModel
        if currentModel == nil {
            currentModel = self.mergedModelFromBundles(nil)
            self.setDefaultManagedObjectModel(currentModel!)
        }
        return currentModel!
    }
    
    class func mergedModelFromMainBundle() -> (managedObjectModel: NSManagedObjectModel) {
        return mergedModelFromBundles(nil)
    }
    
    class func newModel(modelName: String, var inBundle bundle: NSBundle?) -> (managedObjectModel: NSManagedObjectModel) {
        if bundle == nil {
            bundle = NSBundle.mainBundle()
        }
        assert(modelName.pathExtension == nil, "SR - Invalid managedObjectModel name, did you forget the extension?")
        let path: String = bundle!.pathForResource(modelName.stringByDeletingPathExtension, ofType: modelName.pathExtension)
        let modelURL: NSURL = NSURL.fileURLWithPath(path)
        let mom: NSManagedObjectModel = NSManagedObjectModel(contentsOfURL: modelURL)
        return mom
    }
    
    // Cleanup
    class func cleanUp () -> () {
        Static.defaultManagedObjectModel = nil
    }
}


//MARK - PersistantStoreCoordinator Extension

extension NSPersistentStoreCoordinator {
    struct Static {
        static var dPSC: NSPersistentStoreCoordinator? = nil
    }
    class func defaultPersistentStoreCoordinator () -> (NSPersistentStoreCoordinator?) {
        return Static.dPSC
    }
    class func setDefaultPersistentStoreCoordinator (psc: NSPersistentStoreCoordinator) {
        Static.dPSC = psc
    }
    
    // Coordinator initializer
    class func newCoordinator (var databaseName: String?, automigrating: Bool?) -> (NSPersistentStoreCoordinator?) {
        var model: NSManagedObjectModel = NSManagedObjectModel.defaultManagedObjectModel()
        var coordinator: NSPersistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        if automigrating != nil {
            if databaseName == nil {
                databaseName = srDefaultDatabaseName
            }
            coordinator.autoMigrateDatabase(databaseName!)
        }
        return coordinator
    }
    
    // Database Automigration
    func autoMigrateDatabase (databaseName: String) -> (persistentStore: NSPersistentStore) {
        return addDatabase(databaseName, withOptions: NSPersistentStoreCoordinator.autoMigrateOptions())
    }
    
    class func autoMigrateOptions() -> ([NSObject: AnyObject]) {
        var sqliteOptions: [String: String] = [String: String] ()
        sqliteOptions["WAL"] = "journal_mode"
        var options: [NSObject: AnyObject] = [NSObject: AnyObject] ()
        options[NSMigratePersistentStoresAutomaticallyOption] = NSNumber(bool: true)
        options[NSInferMappingModelAutomaticallyOption] = NSNumber(bool: true)
        options[NSSQLitePragmasOption] = sqliteOptions
        return sqliteOptions
    }

    // Database creation
    func addDatabase(databaseName: String, withOptions options: [NSObject: AnyObject]?) -> (persistentStore: NSPersistentStore){
        let url: NSURL = NSPersistentStore.storeUrl(forDatabaseName: databaseName)
        var error: NSError?
        createPathIfNecessary(forFilePath: url)
        let store: NSPersistentStore = addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: options, error: &error)
        if store == nil {
            if srsrShouldDeleteStoreOnModelMismatch {
                let isMigratingError = error?.code == NSPersistentStoreIncompatibleVersionHashError || error?.code == NSMigrationMissingSourceModelError
                if (error?.domain == NSCocoaErrorDomain as String) && isMigratingError {
                    NSNotificationCenter.defaultCenter().postNotificationName(srKVOWillDeleteDatabaseKey, object: nil)
                    var deleteError: NSError?
                    let rawURL: String = url.absoluteString
                    let shmSidecar: NSURL = NSURL.URLWithString(rawURL.stringByAppendingString("-shm"))
                    let walSidecar: NSURL = NSURL.URLWithString(rawURL.stringByAppendingString("-wal"))
                    NSFileManager.defaultManager().removeItemAtURL(url, error: &deleteError)
                    NSFileManager.defaultManager().removeItemAtURL(shmSidecar, error: &error)
                    NSFileManager.defaultManager().removeItemAtURL(walSidecar, error: &error)
                    
                    SugarRecordLogger.logLevelWarm.log("Incompatible model version has been removed \(url.lastPathComponent)")
                    
                    if deleteError != nil {
                        SugarRecordLogger.logLevelError.log("Could not delete store. Error: \(deleteError?.localizedDescription)")
                       NSNotificationCenter.defaultCenter().postNotificationName(srKVOPSCMismatchCouldNotDeleteStore, object: nil, userInfo: ["Error" : deleteError as AnyObject])
                    }
                    else {
                        SugarRecordLogger.logLevelInfo.log("Did delete store")
                        NSNotificationCenter.defaultCenter().postNotificationName(srKVOPSCMismatchDidDeleteStore, object: nil)
                    }
                    SugarRecordLogger.logLevelInfo.log("Will recreate store")
                    NSNotificationCenter.defaultCenter().postNotificationName(srKVOPSCMismatchWillRecreateStore, object: nil)
                    
                    self.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: options, error: &error)
                    if store != nil {
                        SugarRecordLogger.logLevelInfo.log("Did recreate store")
                        NSNotificationCenter.defaultCenter().postNotificationName(srKVOPSCMismatchDidRecreateStore, object: nil)
                        error = nil
                    }
                    else {
                        SugarRecordLogger.logLevelError.log("Could not recreate store")
                        NSNotificationCenter.defaultCenter().postNotificationName(srKVOPSCMismatchCouldNotDeleteStore, object: nil, userInfo: ["Error": error as AnyObject])
                    }
                }
            }
        }
        return store
    }

    // Create path if necessary
    func createPathIfNecessary(forFilePath filePath:NSURL) {
        let fileManager: NSFileManager = NSFileManager.defaultManager()
        let path: NSURL = filePath.URLByDeletingLastPathComponent
        var error: NSError?
        var pathWasCreated: Bool = fileManager.createDirectoryAtPath(path.path, withIntermediateDirectories: true, attributes: nil, error: &error)
        if !pathWasCreated {
            SugarRecord.handle(error!)
        }
    }
    
    // Cleanup
    class func cleanUp () -> () {
        Static.dPSC = nil
    }
}


//MARK - PersistentStore Extension
extension NSPersistentStore {

    struct Static {
        static var dPS: NSPersistentStore? = nil
    }
    class func defaultPersistentStore () -> (NSPersistentStore?) {
        return Static.dPS
    }
    class func setDefaultPersistentStore (ps: NSPersistentStore) {
        Static.dPS = ps
    }
    
    class func directory(directory: NSSearchPathDirectory) -> (String) {
        let documetsPath : AnyObject = NSSearchPathForDirectoriesInDomains(directory, .UserDomainMask, true)[0]
        return documetsPath as String
    }
    
    class func applicationDocumentsDirectory() -> (String) {
        return directory(.DocumentDirectory)
    }
    
    class func applicationStorageDirectory() -> (String) {
        var applicationName: String = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleName") as String
        return directory(.ApplicationSupportDirectory).stringByAppendingPathComponent(applicationName)
    }
    
    class func storeUrl(forDatabaseName dbName: String) -> (url: NSURL) {
        let paths: [String] = [applicationDocumentsDirectory(), applicationStorageDirectory()]
        let fileManager: NSFileManager = NSFileManager()
        
        for path:String in paths {
            let filePath: String = path.stringByAppendingPathComponent(dbName)
            if fileManager.fileExistsAtPath(filePath) {
                return NSURL.fileURLWithPath(filePath)
            }
        }
        return NSURL.fileURLWithPath(applicationStorageDirectory().stringByAppendingPathComponent(dbName))
    }
    
    class func defaultStoreUrl() -> (url: NSURL) {
        return storeUrl(forDatabaseName: srDefaultDatabaseName)
    }
    
    // Cleanup
    class func cleanUp () -> () {
        Static.dPS = nil
    }
}

// MARK - NSManagedObject - SUGARRECORD extension
extension NSManagedObject {
    class func entityName() -> (entityName: String) {
        var entityName: String?
        
        if (self.respondsToSelector(Selector("entityName"))) {
            entityName = self.entityName()
        }
        
        // Using class name as entity name
        if entityName == nil {
            entityName = NSStringFromClass(self)
        }
        return entityName!
    }
    
    class func entityDescriptionInContext(context: NSManagedObjectContext) -> (entityDescription: NSEntityDescription) {
        var entityName: String = self.entityName()
        return NSEntityDescription.entityForName(entityName, inManagedObjectContext: context)
    }
}


// MARK - NSManagedObject - REQUESTS extension
extension NSManagedObject {
    enum FetchedObjects {
        case first, last, all
        case firsts(Int)
        case lasts(Int)
    }
    
    ////// FINDERS //////
    
    class func find(fetchedObjects: FetchedObjects, var inContext context: NSManagedObjectContext?, filteredBy filter: NSPredicate?, var sortedBy sortDescriptors: [NSSortDescriptor]?) -> (objects: [NSManagedObject]) {
        let fetchRequest: NSFetchRequest = request(fetchedObjects, inContext: context, filteredBy: filter, sortedBy: sortDescriptors)
        if context == nil && NSManagedObjectContext.defaultContext() != nil {
            context = NSManagedObjectContext.defaultContext()!
        }
        else {
            assert(true, "Context should be passed or default should be set")
        }
        return self.executeFetchRequest(fetchRequest, inContext: context!)
    }
    
    class func find(fetchedObjects: FetchedObjects, var inContext context: NSManagedObjectContext?, filteredBy filter: NSPredicate?, sortedBy: String, ascending: Bool) -> (objects: [NSManagedObject]) {
        let fetchRequest: NSFetchRequest = request(fetchedObjects, inContext: context, filteredBy: filter, sortedBy: sortedBy, ascending: ascending)
        if context == nil && NSManagedObjectContext.defaultContext() != nil {
            context = NSManagedObjectContext.defaultContext()!
        }
        else {
            assert(true, "Context should be passed or default should be set")
        }
        return self.executeFetchRequest(fetchRequest, inContext: context!)
    }
    
    class func find(fetchedObjects: FetchedObjects, var inContext context: NSManagedObjectContext?, attribute: String, value: String, var sortedBy sortDescriptors: [NSSortDescriptor]?) -> (objects: [NSManagedObject]) {
        let fetchRequest: NSFetchRequest = request(fetchedObjects, inContext: context, withAttribute: attribute, andValue: value, sortedBy: sortDescriptors)
        if context == nil && NSManagedObjectContext.defaultContext() != nil {
            context = NSManagedObjectContext.defaultContext()!
        }
        else {
            assert(true, "Context should be passed or default should be set")
        }
        return self.executeFetchRequest(fetchRequest, inContext: context!)
    }
    
    class func find(fetchedObjects: FetchedObjects, var inContext context: NSManagedObjectContext?, attribute: String, value: String, sortedBy: String, ascending: Bool) -> (objects: [NSManagedObject]) {
        let fetchRequest: NSFetchRequest = request(fetchedObjects, inContext: context, withAttribute: attribute, andValue: value, sortedBy: sortedBy, ascending: ascending)
        if context == nil && NSManagedObjectContext.defaultContext() != nil {
            context = NSManagedObjectContext.defaultContext()!
        }
        else {
            assert(true, "Context should be passed or default should be set")
        }
        return self.executeFetchRequest(fetchRequest, inContext: context!)
    }
    
    class func findAndCreate(var inContext context: NSManagedObjectContext?, withAttribute attribute: String, andValue value:String) -> (object: NSManagedObject) {
        let fetchRequest: NSFetchRequest = request(.first, inContext: context, withAttribute: attribute, andValue: value, sortedBy: nil)
        if context == nil && NSManagedObjectContext.defaultContext() != nil {
            context = NSManagedObjectContext.defaultContext()!
        }
        else {
            assert(true, "Context should be passed or default should be set")
        }
        let objects:[NSManagedObject] = self.executeFetchRequest(fetchRequest, inContext: context!)
        // Returning if object exists
        if objects.count != 0 {
            return objects[0]
        }
        
        var object: NSManagedObject?
        object = self.create(inContext: context!)
        object?.setValue(value, forKey: attribute)
        return object!
    }
    
    ////// AGGREGATION //////

    class func count(var inContext context: NSManagedObjectContext?, filteredBy filter:NSPredicate?) -> (Int) {
        var error: NSError?
        if context == nil {
            context = NSManagedObjectContext.defaultContext()
        }
        let count: Int = context!.countForFetchRequest(fetchRequest(inContext: context), error: &error)
        SugarRecord.handle(error)
        return count
    }
    
    class func count() -> (Int) {
        return count(inContext: nil, filteredBy: nil)
    }
    
    class func count(inContext context: NSManagedObjectContext) -> (Int) {
        return count(inContext: context, filteredBy: nil)
    }
    
    class func count(filteredBy filter: NSPredicate) -> (Int) {
        return count(inContext: nil, filteredBy: filter)
    }
    
    class func any() -> (Bool) {
        return any(inContext: nil, filteredBy: nil)
    }
    
    class func any(inContext context: NSManagedObjectContext) -> (Bool) {
        return any(inContext: context, filteredBy: nil)
    }
    
    class func any(inContext context: NSManagedObjectContext?, filteredBy filter: NSPredicate?) -> (Bool) {
        return count(inContext: context, filteredBy: filter) == 0
    }
    
    enum PropertyType {
        case max(String)
        case min(String)
    }
    
    ////// REQUESTS //////
    
    // Create and returns the fetch request
    class func fetchRequest(var inContext context: NSManagedObjectContext?) -> (fetchRequest: NSFetchRequest) {
        if context == nil {
            context = NSManagedObjectContext.defaultContext()
        }
        assert(context != nil, "SR-Assert: Fetch request can't be created without context. Ensure you've initialized Sugar Record")
        var request: NSFetchRequest = NSFetchRequest()
        request.entity = entityDescriptionInContext(context!)
        return request
    }
    
    class func request(fetchedObjects: FetchedObjects, inContext context: NSManagedObjectContext?, filteredBy filter: NSPredicate?, var sortedBy sortDescriptors: [NSSortDescriptor]?) -> (fetchRequest: NSFetchRequest) {
        var fetchRequest: NSFetchRequest = self.fetchRequest(inContext: context)
        
        // Order
        var revertOrder: Bool = false
        switch fetchedObjects {
        case let .first:
            fetchRequest.fetchBatchSize = 1
        case let .last:
            fetchRequest.fetchBatchSize = 1
            revertOrder = true
        case let .firsts(number):
            fetchRequest.fetchBatchSize = number
        case let .lasts(number):
            revertOrder = true
            fetchRequest.fetchBatchSize = number
        default:
            break
        }
        
        // Sort descriptors
        if revertOrder  && sortDescriptors != nil {
            var rootSortDescriptor: NSSortDescriptor = sortDescriptors![0]
            sortDescriptors![0] = NSSortDescriptor(key: rootSortDescriptor.key, ascending: !rootSortDescriptor.ascending)
        }
        fetchRequest.sortDescriptors = sortDescriptors
        
        // Predicate
        if filter != nil  {
            fetchRequest.predicate = filter
        }
        
        return fetchRequest
    }
    
    class func request(fetchedObjects: FetchedObjects, inContext context: NSManagedObjectContext?, filteredBy filter: NSPredicate?, sortedBy: String, ascending: Bool) -> (fetchRequest: NSFetchRequest) {
        return request(fetchedObjects, inContext: context, filteredBy: filter, sortedBy: [NSSortDescriptor(key: sortedBy, ascending: ascending)])
    }
    
    class func request(fetchedObjects: FetchedObjects, inContext context: NSManagedObjectContext?, withAttribute attribute: String, andValue value:String, var sortedBy sortDescriptors: [NSSortDescriptor]?) -> (fetchRequest: NSFetchRequest) {
        let predicate: NSPredicate = NSPredicate(format: "\(attribute) = \(value)", argumentArray: nil)
        return request(fetchedObjects, inContext: context, filteredBy: predicate, sortedBy: sortDescriptors)
    }
    
    class func request(fetchedObjects: FetchedObjects, inContext context: NSManagedObjectContext?, withAttribute attribute: String, andValue value:String, sortedBy: String, ascending: Bool) -> (fetchRequest: NSFetchRequest) {
        let predicate: NSPredicate = NSPredicate(format: "\(attribute) = \(value)", argumentArray: nil)
        return request(fetchedObjects, inContext: context, filteredBy: predicate, sortedBy: [NSSortDescriptor(key: sortedBy, ascending: ascending)])
    }
    
    
    ////// CREATION / DELETION /EDITION OF ENTITIES ////
    
    class func executeFetchRequest(fetchRequest: NSFetchRequest, var inContext context: NSManagedObjectContext?) -> ([NSManagedObject]) {
        var objects: [NSManagedObject] = [NSManagedObject]()
        if context == nil && NSManagedObjectContext.defaultContext() != nil {
            context = NSManagedObjectContext.defaultContext()!
        }
        else {
            assert(true, "Context should be passed or default should be set")
        }
        context!.performBlockAndWait { () -> Void in
            var error: NSError? = nil
            objects = context!.executeFetchRequest(fetchRequest, error: &error) as [NSManagedObject]
            if objects == nil && error != nil {
                SugarRecord.handle(error!)
            }
        }
        return objects
    }
    
    class func create(inContext context: NSManagedObjectContext) -> (NSManagedObject?) {
        var entity: NSEntityDescription?
        entity = self.entityDescriptionInContext(context)
        if entity == nil {
            return nil
        }
        return NSManagedObject(entity: entity!, insertIntoManagedObjectContext: context)
    }
    
    func delete(var inContext context: NSManagedObjectContext?) -> (Bool) {
        if context == nil && NSManagedObjectContext.defaultContext() != nil {
            context = NSManagedObjectContext.defaultContext()!
        }
        else {
            assert(true, "Context should be passed or default should be set")
        }
        var error: NSError?
        var objectInContext: NSManagedObject = context!.existingObjectWithID(self.objectID, error: &error)
        SugarRecord.handle(error)
        return true
    }
    
    class func deleteAll(predicate: NSPredicate?, inContext context: NSManagedObjectContext?) -> (Bool) {
        var request: NSFetchRequest = self.request(.all, inContext: context, filteredBy: predicate, sortedBy: nil)
        request.returnsObjectsAsFaults = true
        request.includesPendingChanges = false
        var objects: [NSManagedObject] = self.executeFetchRequest(request, inContext: context)
        for object in objects {
            object.delete(inContext: context)
        }
        return true
    }
    
    func to(context: NSManagedObjectContext) -> (NSManagedObject?) {
        var error: NSError?
        if self.objectID.temporaryID {
            let objects: [AnyObject]! = [self]
            let success: Bool = self.managedObjectContext.obtainPermanentIDsForObjects(objects, error: &error)
            if !success {
                SugarRecord.handle(error)
                return nil
            }
        }
        error = nil
        let objectInContext: NSManagedObject = context.existingObjectWithID(self.objectID, error: &error)
        SugarRecord.handle(error)
        return objectInContext
    }

    class func entityDescription(inContext context: NSManagedObjectContext?) -> (NSEntityDescription) {
        let entityName: String = self.entityName()
        return NSEntityDescription.entityForName(entityName, inManagedObjectContext: context!)
    }
    
    class func sortDescriptors(attributes: [String]) -> ([NSSortDescriptor]) {
        return sortDescriptors(attributes, ascending: true)
    }
    
    class func sortDescriptors(attributes: [String], ascending: Bool) -> ([NSSortDescriptor]) {
        var sortDescriptors: [NSSortDescriptor] = [NSSortDescriptor]()
        for attribute in attributes {
            sortDescriptors.append(NSSortDescriptor(key: attribute, ascending: ascending))
        }
        return sortDescriptors
    }
    
    class func properties(named: [String], inContext context: NSManagedObjectContext?) -> ([String: NSPropertyDescription]) {
        let description: NSEntityDescription = self.entityDescription(inContext: context)
        var propertiesWanted: [String: NSPropertyDescription] = [String: NSPropertyDescription]()
        if named.count == 0 {
            return propertiesWanted
        }
        var propDict: [String: NSPropertyDescription] = description.propertiesByName as [String: NSPropertyDescription]!
        for propertyName in named {
            let property: NSPropertyDescription? = propDict[propertyName]
            if property != nil {
                
            }
            else {
                SugarRecordLogger.logLevelVerbose.log("Property \(propertyName) not found for \(object_getClassName(self))")
            }
        }
        return propDict
    }
    
}


