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

// Static variables - RELATED WITH OPTIONS ENABLED/DISABLED
var srShouldAutoCreateManagedObjectModel: Bool = true
var srShouldAutoCreateDefaultPersistentStoreCoordinator: Bool = false
var srsrShouldDeleteStoreOnModelMismatch: Bool = true


// Static variables - RELATED WITH KVO KEYS
var srKVOWillDeleteDatabaseKey: String = "srKVOWillDeleteDatabaseKey"
var srKVOPSCMismatchCouldNotDeleteStore: String = "srKVOPSCMismatchCouldNotDeleteStore"
var srKVOPSCMismatchDidDeleteStore: String = "srKVOPSCMismatchDidDeleteStore"
var srKVOPSCMismatchWillRecreateStore = "KVOPSCMismatchWillRecreateStore"
var srKVOPSCMismatchDidRecreateStore = "srKVOPSCMismatchDidRecreateStore"
var srKVOPSCMMismatchCouldNotRecreateStore = "srKVOPSCMMismatchCouldNotRecreateStore"

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
    
    // Shared singleton instance
    class var sharedInstance : SugarRecord {
        struct Static {
            static var onceToken : dispatch_once_t = 0
            static var instance : SugarRecord? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = SugarRecord()
        }
        return Static.instance!
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

    
    // CleanUp
    class func cleanUp () -> () {
        NSManagedObjectContext.cleanUp()
    }
    
    // Returns current stack information
    class func currentStack () -> (stack: String?) {
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
}

// MARK - Extension SugarRecord + Error Handling

extension SugarRecord {
    class func handle(error: NSError) {
        
    }
    class func handle(exception: NSException) {
        
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
        Static.rootSavingContext = context
    }
    
    // Default Context Getter
    class func defaultContext() -> (NSManagedObjectContext?) {
        return Static.defaultContext
    }
    
    // Default Context Setter
    class func setDefaultContext(context: NSManagedObjectContext?) {
        Static.defaultContext = context
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
        self.setRootSavingContext(rootSavingContext())
        var defaultContext: NSManagedObjectContext = self.newContext(rootContext, persistentStoreCoordinator: nil)
    }
    
    // CleanUp
    class func cleanUp(){
        self.setRootSavingContext(nil)
        self.setDefaultContext(nil)
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
    class func newCoordinator (databaseName: String, automigrating: Bool?) -> (NSPersistentStoreCoordinator?) {
        var model: NSManagedObjectModel = NSManagedObjectModel.defaultManagedObjectModel()
        var coordinator: NSPersistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        if automigrating != nil {
            coordinator.autoMigrateDatabase(databaseName)
        }
        return coordinator
    }
    
    class func newCoordinator(automigrating: Bool?) -> (NSPersistentStoreCoordinator?) {
        return newCoordinator(srDefaultDatabaseName, automigrating: automigrating)
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
}

// MARK - NSManagedObject - SUGARRECORD extension
extension NSManagedObject {
    class func entityName() -> (entityName: String) {
        var entityName: String?

        
        // Using class name as entity name
        if entityName?.isEmpty {
            entityName = NSStringFromClass(self)
        }
    }

}

/*

+ (NSString *) MR_entityName;
{
NSString *entityName;

if ([self respondsToSelector:@selector(entityName)])
{
entityName = [self performSelector:@selector(entityName)];
}

if ([entityName length] == 0) {
entityName = NSStringFromClass(self);
}

return entityName;
}*

/*
+ (NSEntityDescription *) MR_entityDescriptionInContext:(NSManagedObjectContext *)context
{
NSString *entityName = [self MR_entityName];
return [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
}*/


// MARK - NSManagedObject - REQUESTS extension
extension NSManagedObject {
    // Create and returns the fetch request
    class func fetchRequest(var inContext context: NSManagedObjectContext?) -> (fetchRequest: NSFetchRequest) {
        if context == nil {
            context = NSManagedObjectContext.defaultContext()
        }
        assert(context != nil, "Fetch request can't be created without context. Ensure you've initialized Sugar Record")
        var request: NSFetchRequest = NSFetchRequest()
        
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:[self MR_entityDescriptionInContext:context]];
        
    }
}
