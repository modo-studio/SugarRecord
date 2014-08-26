//
//  NSPersistentStoreCoordinator+Extras.swift
//  SugarRecord
//
//  Created by Pedro Piñera Buendía on 26/08/14.
//  Copyright (c) 2014 PPinera. All rights reserved.
//

import Foundation

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
    func autoMigrateDatabase (databaseName: String) -> (NSPersistentStore) {
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
    func addDatabase(databaseName: String, withOptions options: [NSObject: AnyObject]?) -> (NSPersistentStore){
        let url: NSURL = NSPersistentStore.storeUrl(forDatabaseName: databaseName)
        var error: NSError?
        createPathIfNecessary(forFilePath: url)
        let store: NSPersistentStore = addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: options, error: &error)
        if srsrShouldDeleteStoreOnModelMismatch {
                let isMigratingError = error?.code == NSPersistentStoreIncompatibleVersionHashError || error?.code == NSMigrationMissingSourceModelError
                if (error?.domain == NSCocoaErrorDomain as String) && isMigratingError {
                    NSNotificationCenter.defaultCenter().postNotificationName(srKVOWillDeleteDatabaseKey, object: nil)
                    var deleteError: NSError?
                    let rawURL: String = url.absoluteString!
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
                    SugarRecordLogger.logLevelInfo.log("Did recreate store")
                        NSNotificationCenter.defaultCenter().postNotificationName(srKVOPSCMismatchDidRecreateStore, object: nil)
                        error = nil
                }
            }
        return store
    }

    // Create path if necessary
    func createPathIfNecessary(forFilePath filePath:NSURL) {
        let fileManager: NSFileManager = NSFileManager.defaultManager()
        let path: NSURL = filePath.URLByDeletingLastPathComponent!
        var error: NSError?
        var pathWasCreated: Bool = fileManager.createDirectoryAtPath(path.path!, withIntermediateDirectories: true, attributes: nil, error: &error)
        if !pathWasCreated {
            SugarRecord.handle(error!)
        }
    }
    
    // Cleanup
    class func cleanUp () -> () {
        Static.dPSC = nil
    }
}
