//
//  SugarRecord.swift
//  SugarRecord
//
//  Created by Pedro Piñera Buendía on 03/08/14.
//  Copyright (c) 2014 PPinera. All rights reserved.
//

import Foundation
import CoreData

// MARK: Library Constants
let srDefaultDatabaseName: String = "sugarRecordDatabase.sqlite"
let srSugarRecordVersion: String = "v0.0.1 - Alpha"
let srBackgroundQueueName: String = "sugarRecord.backgroundQueue"

// MARK: Options
var srShouldAutoCreateManagedObjectModel: Bool = true
var srShouldAutoCreateDefaultPersistentStoreCoordinator: Bool = false
var srsrShouldDeleteStoreOnModelMismatch: Bool = true

// MARK: Dictionary Keys
var srContextWorkingNameKey = "srContextWorkingNameKey"

// MARK: KVO Keys
let srKVOWillDeleteDatabaseKey = "srKVOWillDeleteDatabaseKey"
let srKVOPSCMismatchCouldNotDeleteStore = "srKVOPSCMismatchCouldNotDeleteStore"
let srKVOPSCMismatchDidDeleteStore = "srKVOPSCMismatchDidDeleteStore"
let srKVOPSCMismatchWillRecreateStore = "KVOPSCMismatchWillRecreateStore"
let srKVOPSCMismatchDidRecreateStore = "srKVOPSCMismatchDidRecreateStore"
let srKVOPSCMMismatchCouldNotRecreateStore = "srKVOPSCMMismatchCouldNotRecreateStore"
let srKVOCleanedUpNotification = "srKVOCleanedUpNotification"

// MARK: SugarRecord Initialization

/**
 *  Main Library class with some useful constants and methods
 */
class SugarRecord {
    struct Static {
        //static var onceToken : dispatch_once_t = 0
        //static var instance : SugarRecord? = nil
        
        // -- I've seen it is only used for the save operations
        // The queue itself is not guaranteed to run on any particular thread, 
        // it might run on the main queue if it's a context using main queue concurrency type
        static var backgroundQueue : dispatch_queue_t? = nil
    }
    
    /**
     Setup the contexts stack (including the persistent store coordinator)

     :param: automigrating Specifies if the old database should be auto migrated
     :param: databaseName  Database name. If not passed, default one will be used
     */
    class func setupCoreDataStack(#automigrating: Bool?, databaseName: String?) {
        var psc: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator.defaultPersistentStoreCoordinator()
        if psc != nil {
            return
        }
        if databaseName != nil {
            psc = NSPersistentStoreCoordinator.newCoordinator(databaseName!, automigrating: automigrating)
        }
        else {
            psc = NSPersistentStoreCoordinator.newCoordinator(SugarRecord.defaultDatabaseName(), automigrating: automigrating)
        }
        NSPersistentStoreCoordinator.setDefaultPersistentStoreCoordinator(psc!)
        NSManagedObjectContext.initializeContextsStack(psc!)
    }

    /**
     Removes the database with the given name

     :param: databaseName String of the database to be deleted
     */
    class func removeDatabaseNamed(databaseName: String) -> Bool {
        let url: NSURL = NSPersistentStore.storeUrl(forDatabaseName: databaseName)
        let fileManager: NSFileManager = NSFileManager.defaultManager()
        var error: NSError?
        fileManager.removeItemAtPath(url.absoluteString, error: &error)
        if error != nil {
            SugarRecordLogger.logLevelInfo.log("Data base deleted |\(databaseName)|")
        }
        return error != nil
    }
    
    /**
     Returns the background queue for background operations with SugarRecord

     :returns: Background Queue (lazy generated) queue
     */
    class func backgroundQueue() -> dispatch_queue_t {
        if Static.backgroundQueue == nil {
            Static.backgroundQueue = dispatch_queue_create(srBackgroundQueueName, nil)
        }
        return Static.backgroundQueue!
    }

    /**
     Clean up the stack and notifies it using key srKVOCleanedUpNotification
     */
    class func cleanUp() {
        SugarRecord.cleanUpStack()
        NSNotificationCenter.defaultCenter().postNotificationName(srKVOCleanedUpNotification, object: nil)
    }

    /**
     Clean the entire stack of SugarRecord Core Data components
     */
    class func cleanUpStack() {
        NSManagedObjectContext.cleanUp()
        NSManagedObjectModel.cleanUp()
        NSPersistentStoreCoordinator.cleanUp()
        NSPersistentStore.cleanUp()
    }

    /**
     Information about the current stack

     :returns: String with the stack information (Model, Coordinator, Store, ...)
     */
    class func currentStack() -> String {
        var status: String = "SugarRecord stack \n ------- \n"
        status += "Model:                   \(NSManagedObjectModel.defaultManagedObjectModel())\n"
        status += "Coordinator:             \(NSPersistentStoreCoordinator.defaultPersistentStoreCoordinator())\n"
        status += "Store:                   \(NSPersistentStore.defaultPersistentStore())\n"
        status += "Default context:         \(NSManagedObjectContext.defaultContext())\n"
        status += "Saving context:          \(NSManagedObjectContext.rootSavingContext())\n"
        return status
    }
    
    /**
     Returns the current version of SugarRecord

     :returns: String with the version value
     */
    class func currentVersion() -> String {
        return srSugarRecordVersion
    }
    
    /**
     Rerturns the default data base name
            
     :returns: String with the default name (ended in .sqlite)
     */
    class func defaultDatabaseName() -> String {
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

