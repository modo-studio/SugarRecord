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
        if let psc = NSPersistentStoreCoordinator.defaultPersistentStoreCoordinator(){}
        else {
            return
        }
        // Initializing persistentStoreCoordinator
        var psc: NSPersistentStoreCoordinator
        if let dbName = databaseName {
            psc = NSPersistentStoreCoordinator.newCoordinator(dbName, automigrating: automigrating)
        }
        else {
            psc = NSPersistentStoreCoordinator.newCoordinator(self.defaultDatabaseName(), automigrating: automigrating)
        }
        NSPersistentStoreCoordinator.setDefaultPersistentStoreCoordinator(psc)

        
    }

    
    // CleanUp
    class func cleanUp () -> () {
        
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


//MARK - NSManagedObjectContext Extension

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
    
    // Default Context Getter
    class func defaultContext() -> (NSManagedObjectContext?) {
        return Static.defaultContext
    }
    
    // Returns a new context with default context as parent
    class func newContext (parentContext: NSManagedObjectContext?) -> (NSManagedObjectContext) {
        var context: NSManagedObjectContext = NSManagedObjectContext()
        context.parentContext = self.defaultContext()!
        return context
    }
    
}


//MARK - NSManagedObject Extension

extension NSManagedObject {
    class func defaultManagedObject () -> (NSManagedObject?) {
        return nil;
    }
    
    class func filter (context: NSManagedObjectContext?, predicate: NSPredicate) -> (NSArray) {
        
    }
    
    
    /* Returns the count of NSManagedObjects
    *  @param NSManagedObjectContext Context where the fetch should be executed
    *  @param NSPredicate To filter fetch results
    *  @return Int with the count
    */
    class func count(context: NSManagedObjectContext?, predicate: NSPredicate) -> (count: Int) {
        return self.filter(context, predicate: predicate).count
    }
    
    
    
}


//MARK - PersistantStoreCoordinator Extension

extension NSPersistentStoreCoordinator {
    // Static variables
    struct Static {
        static var dPSC: NSPersistentStoreCoordinator? = nil
    }
    class func defaultPersistentStoreCoordinator () -> (NSPersistentStoreCoordinator?) {
        return Static.dPSC;
    }
    class func setDefaultPersistentStoreCoordinator (psc: NSPersistentStoreCoordinator) {
        Static.dPSC = psc
    }
    
    
    // Coordinator initializer
    class func newCoordinator (databaseName: String, automigrating: Bool?) -> (NSPersistentStoreCoordinator) {
        
    }
    
}


//MARK - PersistentStore Extension
extension NSPersistentStore {
    
    class func defaultPersistentStore () -> (NSPersistentStore?) {
        return nil;
    }
    
}
