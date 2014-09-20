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
    public var name: String = "DefaultCoreDataStack"
    public var stackDescription: String = "Default core data stack with an efficient context management"
    private var databasePath: NSURL?
    private var automigrating: Bool
    public let defaultStoreName: String = "sugar.sqlite"
    private var persistentStoreCoordinator: NSPersistentStoreCoordinator?
    private var rootSavingContext: NSManagedObjectContext?
    private var mainContext: NSManagedObjectContext?
    private var persistentStore: NSPersistentStore?
    
    //MARK - Initializers
    
    init(databaseURL: NSURL, model: NSManagedObjectModel?, automigrating: Bool)
    {
        self.automigrating = automigrating
        self.databasePath = databaseURL
    }
    
    convenience public init(databaseName: String, automigrating: Bool)
    {
        self.init(databaseURL: DefaultCDStack.databasePathURLFromName(databaseName), automigrating: automigrating)
    }
    
    convenience public init(databasePath: String, automigrating: Bool)
    {
        self.init(databaseURL: NSURL(fileURLWithPath: databasePath), automigrating: automigrating)
    }
    
    convenience public init(databaseURL: NSURL, automigrating: Bool)
    {
        self.init(databaseURL: databaseURL, model: nil, automigrating: automigrating)
    }
    
    convenience public init(databaseName: String, model: NSManagedObjectModel, automigrating: Bool)
    {
        self.init(databaseURL: DefaultCDStack.databasePathURLFromName(databaseName), model: model, automigrating: automigrating)
    }
    
    convenience public init(databasePath: String, model: NSManagedObjectModel, automigrating: Bool)
    {
        self.init(databaseURL: NSURL(fileURLWithPath: databasePath), model: model, automigrating: automigrating)
    }

    public func initialize()
    {
        self.persistentStoreCoordinator = createPersistentStoreCoordinator()
        self.rootSavingContext = createRootSavingContext()
        self.rootSavingContext!.persistentStoreCoordinator = self.persistentStoreCoordinator!
        self.mainContext!.parentContext = self.rootSavingContext
    }
    
    public func cleanup()
    {
        // Nothing to do here
    }
    
    public func applicationWillResignActive()
    {
        saveChangesInRootSavingContext()
    }
    
    public func applicationWillTerminate()
    {
        saveChangesInRootSavingContext()
    }
    
    public func applicationWillEnterForeground()
    {
        // Nothing to do here
    }
    
    public func backgroundContext() -> SugarRecordContext
    {
        if self.rootSavingContext == nil {
            assert(true, "Fatal error. The private context is not initialized")
        }
        
        var context: NSManagedObjectContext = NSManagedObjectContext(concurrencyType: .ConfinementConcurrencyType)
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        context.parentContext = self.rootSavingContext!
        
        //TODO - Add KVO
        
        return SugarRecordCDContext(context: context)
    }
    
    public func mainThreadContext() -> SugarRecordContext
    {
        if self.mainContext == nil {
            assert(true, "Fatal error. The main context is not initialized")
        }
        return SugarRecordCDContext(context: self.mainContext!)
    }
    
    public func removeDatabase()
    {
        let documentsPath: String = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let databaseName: String = documentsPath.stringByAppendingPathComponent("default.realm")
        var error: NSError?
        NSFileManager.defaultManager().removeItemAtPath(databaseName, error: &error)
        SugarRecord.handle(error)
    }
    
    
    //MARK - Creation helper
    
    private func createMainContext() -> NSManagedObjectContext
    {
        
    }
    
    private func createRootSavingContext() -> NSManagedObjectContext
    {
        
    }
    
    private func createPersistentStoreCoordinator() -> NSPersistentStoreCoordinator
    {
        var model: NSManagedObjectModel = NSManagedObjectModel.mergedModelFromBundles(nil)
        var coordinator: NSPersistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        addDatabase()
        return coordinator
    }
    
    //MARK - Database helper
    
    public func addDatabase() {
        var error: NSError?
        createPathIfNecessary(forFilePath: self.databasePath!)
        var store: NSPersistentStore?
        if self.persistentStoreCoordinator == nil {
            SugarRecord.handle(NSError())
        }
        if self.automigrating {
            store = self.persistentStoreCoordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: self.databasePath!, options: DefaultCDStack.autoMigrateStoreOptions(), error: &error)!
        }
        else {
            store = self.persistentStoreCoordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: self.databasePath!, options: DefaultCDStack.defaultStoreOptions(), error: &error)!
        }
        
        let isMigratingError = error?.code == NSPersistentStoreIncompatibleVersionHashError || error?.code == NSMigrationMissingSourceModelError
        
        if (error?.domain == NSCocoaErrorDomain as String) && isMigratingError {
            var deleteError: NSError?
            let rawURL: String = self.databasePath!.absoluteString!
            let shmSidecar: NSURL = NSURL.URLWithString(rawURL.stringByAppendingString("-shm"))
            let walSidecar: NSURL = NSURL.URLWithString(rawURL.stringByAppendingString("-wal"))
            NSFileManager.defaultManager().removeItemAtURL(databasePath!, error: &deleteError)
            NSFileManager.defaultManager().removeItemAtURL(shmSidecar, error: &error)
            NSFileManager.defaultManager().removeItemAtURL(walSidecar, error: &error)
            
            SugarRecordLogger.logLevelWarm.log("Incompatible model version has been removed \(self.databasePath!.lastPathComponent)")
            
            if deleteError != nil {
                SugarRecordLogger.logLevelError.log("Could not delete store. Error: \(deleteError?.localizedDescription)")
            }
            else {
                SugarRecordLogger.logLevelInfo.log("Did delete store")
            }
            SugarRecordLogger.logLevelInfo.log("Will recreate store")
            self.persistentStoreCoordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: self.databasePath, options: DefaultCDStack.defaultStoreOptions(), error: &error)
            SugarRecordLogger.logLevelInfo.log("Did recreate store")
            error = nil
        }
        else {
            SugarRecord.handle(error)
        }
        
        self.persistentStore = store!
    }
    
    public func createPathIfNecessary(forFilePath filePath:NSURL) {
        let fileManager: NSFileManager = NSFileManager.defaultManager()
        let path: NSURL = filePath.URLByDeletingLastPathComponent!
        var error: NSError?
        var pathWasCreated: Bool = fileManager.createDirectoryAtPath(path.path!, withIntermediateDirectories: true, attributes: nil, error: &error)
        if !pathWasCreated {
            SugarRecord.handle(error!)
        }
    }
    
    private class func autoMigrateStoreOptions() -> [NSObject: AnyObject] {
        var sqliteOptions: [String: String] = [String: String] ()
        sqliteOptions["WAL"] = "journal_mode"
        var options: [NSObject: AnyObject] = [NSObject: AnyObject] ()
        options[NSMigratePersistentStoresAutomaticallyOption] = NSNumber(bool: true)
        options[NSInferMappingModelAutomaticallyOption] = NSNumber(bool: true)
        options[NSSQLitePragmasOption] = sqliteOptions
        return sqliteOptions
    }
    
    private class func defaultStoreOptions() -> [NSObject: AnyObject] {
        var sqliteOptions: [String: String] = [String: String] ()
        sqliteOptions["WAL"] = "journal_mode"
        var options: [NSObject: AnyObject] = [NSObject: AnyObject] ()
        options[NSSQLitePragmasOption] = sqliteOptions
        return sqliteOptions
    }
    
    
    //MARK - Saving helper
    
    
    private func saveChangesInRootSavingContext()
    {
        if self.rootSavingContext == nil {
            assert(true, "Fatal error. The private context is not initialized")
        }
        if self.rootSavingContext!.hasChanges {
            var error: NSError?
            self.rootSavingContext!.save(&error)
            if error != nil {
                let exception: NSException = NSException(name: "Context saving exception", reason: "Pending changes in the root savinv context couldn't be saved", userInfo: ["error": error!])
                SugarRecord.handle(NSException())
            }
            else {
                SugarRecordLogger.logLevelInfo.log("Existing changes persisted to the database")
            }
        }
    }
    
    
    //MARK - Helper
    
    private class func databasePathURLFromName(name: String) -> NSURL
    {
        let documentsPath: String = NSSearchPathForDirectoriesInDomains(.ApplicationSupportDirectory, .UserDomainMask, true)[0] as String
        let mainBundleInfo: [NSObject: AnyObject] = NSBundle.mainBundle().infoDictionary
        let applicationName: String = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleDisplayName") as String
        let applicationPath: String = documentsPath.stringByAppendingPathComponent(applicationName)
        
        let paths: [String] = [documentsPath, applicationPath]
        for path in paths {
            let databasePath: String = path.stringByAppendingPathComponent(name)
            if NSFileManager.defaultManager().fileExistsAtPath(databasePath) {
                return NSURL(fileURLWithPath: databasePath)
            }
        }
        
        let databasePath: String = applicationPath.stringByAppendingPathComponent(name)
        return NSURL(fileURLWithPath: databasePath)
    }
}