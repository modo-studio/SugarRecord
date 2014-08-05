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
        if psc == nil {
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
            newContext?.parentContext = self.defaultContext()!
        }
        else if persistentStoreCoordinator != nil {
            newContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
            newContext?.persistentStoreCoordinator = persistentStoreCoordinator
        }
        else {
            assert(true, "SUGAR-RECORD: Either parentContext or  persistentStoreCoordinator has to be passed")
        }
        println("SUGAR-RECORD: Created new context - \(newContext)")
        return newContext!
    }

    // Initialize default contexts stack
    class func initializeContextsStack (persistentStoreCoordinator: NSPersistentStoreCoordinator)  {
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

//MARK - NSManagedObject Extension

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
    }
    
    // Database Automigration
    func autoMigrateDatabase (databaseName: String) {
        
    }
    
    class func autoMigrateOptions() -> ([String: String]) {
        var sqliteOptions: [String: String] = [String: String] ()
        sqliteOptions["WAL"] = "journal_mode"
        var options: [String: NSNumber] = [String: NSNumber] ()
        options[NSMigratePersistentStoresAutomaticallyOption] = NSNumber(bool: true)
        options[NSInferMappingModelAutomaticallyOption] = NSNumber(bool: true)
        options[NSSQLitePragmasOption] = sqliteOptions
        return sqliteOptions
    }

    // Database creation
    func addDatabase(databaseName: String, withOptions options: [String: String]) {
        //TODO
    }
    
    /*
NSURL *url = [storeFileName isKindOfClass:[NSURL class]] ? storeFileName : [NSPersistentStore MR_urlForStoreName:storeFileName];
NSError *error = nil;

[self MR_createPathToStoreFileIfNeccessary:url];

NSPersistentStore *store = [self addPersistentStoreWithType:NSSQLiteStoreType
configuration:nil
URL:url
options:options
error:&error];

if (!store)
{
if ([MagicalRecord shouldDeleteStoreOnModelMismatch])
{
BOOL isMigrationError = (([error code] == NSPersistentStoreIncompatibleVersionHashError) || ([error code] == NSMigrationMissingSourceModelError));
if ([[error domain] isEqualToString:NSCocoaErrorDomain] && isMigrationError)
{
[[NSNotificationCenter defaultCenter] postNotificationName:kMagicalRecordPSCMismatchWillDeleteStore object:nil];

NSError * deleteStoreError;
// Could not open the database, so... kill it! (AND WAL bits)
NSString *rawURL = [url absoluteString];
NSURL *shmSidecar = [NSURL URLWithString:[rawURL stringByAppendingString:@"-shm"]];
NSURL *walSidecar = [NSURL URLWithString:[rawURL stringByAppendingString:@"-wal"]];
[[NSFileManager defaultManager] removeItemAtURL:url error:&deleteStoreError];
[[NSFileManager defaultManager] removeItemAtURL:shmSidecar error:nil];
[[NSFileManager defaultManager] removeItemAtURL:walSidecar error:nil];

MRLogWarn(@"Removed incompatible model version: %@", [url lastPathComponent]);
if(deleteStoreError) {
[[NSNotificationCenter defaultCenter] postNotificationName:kMagicalRecordPSCMismatchCouldNotDeleteStore object:nil userInfo:@{@"Error":deleteStoreError}];
}
else {
[[NSNotificationCenter defaultCenter] postNotificationName:kMagicalRecordPSCMismatchDidDeleteStore object:nil];
}

[[NSNotificationCenter defaultCenter] postNotificationName:kMagicalRecordPSCMismatchWillRecreateStore object:nil];
// Try one more time to create the store
store = [self addPersistentStoreWithType:NSSQLiteStoreType
configuration:nil
URL:url
options:options
error:&error];
if (store)
{
[[NSNotificationCenter defaultCenter] postNotificationName:kMagicalRecordPSCMismatchDidRecreateStore object:nil];
// If we successfully added a store, remove the error that was initially created
error = nil;
}
else {
[[NSNotificationCenter defaultCenter] postNotificationName:kMagicalRecordPSCMismatchCouldNotRecreateStore object:nil userInfo:@{@"Error":error}];
}
}
}
[MagicalRecord handleErrors:error];
}
return store;*/
}


//MARK - PersistentStore Extension
extension NSPersistentStore {

    class func defaultPersistentStore () -> (NSPersistentStore?) {
        return nil
    }

}
