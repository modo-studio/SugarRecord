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
    public let defaultStoreName: String = "sugar.sqlite"
    private var persistentStoreCoordinator: NSPersistentStoreCoordinator?
    private var rootSavingContext: NSManagedObjectContext?
    private var mainContext: NSManagedObjectContext?
    
    //MARK - Initializers
    
    init(databaseURL: NSURL, model: NSManagedObjectModel?)
    {
        self.databasePath = databaseURL
    }
    
    convenience public init(databaseName: String)
    {
        self.init(databaseURL: DefaultCDStack.databasePathURLFromName(databaseName))
    }
    
    convenience public init(databasePath: String)
    {
        self.init(databaseURL: NSURL(fileURLWithPath: databasePath))
    }
    
    convenience public init(databaseURL: NSURL)
    {
        self.init(databaseURL: databaseURL, model: nil)
    }
    
    convenience public init(databaseName: String, model: NSManagedObjectModel)
    {
        self.init(databaseURL: DefaultCDStack.databasePathURLFromName(databaseName), model: model)
    }
    
    convenience public init(databasePath: String, model: NSManagedObjectModel)
    {
        self.init(databaseURL: NSURL(fileURLWithPath: databasePath), model: model)
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
    
    
    //MARK - Helper
    
    public func createPersistentCoordinator
    
    private func createMainContext() -> NSManagedObjectContext
    {
        
    }
    
    private func createRootSavingContext() -> NSManagedObjectContext
    {
        
    }
    
    private func createPersistentStoreCoordinator() -> NSPersistentStoreCoordinator
    {
        
    }
    
    
    private func saveChangesInRootSavingContext()
    {
        if self.rootSavingContext == nil {
            assert(true, "Fatal error. The private context is not initialized")
        }
        if self.rootSavingContext!.hasChanges {
            var error: NSError?
            self.rootSavingContext!.save(&error)
            if error != nil {
                SugarRecord.handle(NSError(domain: "Root saving context couldn't save pending changes", code: SugarRecordErrorCodes.CoreDataError.toRaw(), userInfo: nil))
            }
            else {
                SugarRecordLogger.logLevelInfo.log("Existing changes persisted to the database")
            }
        }
    }
    
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