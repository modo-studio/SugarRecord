//
//  iCloudCDStack.swift
//  SugarRecord
//
//  Created by Pedro Piñera Buendía on 12/10/14.
//  Copyright (c) 2014 SugarRecord. All rights reserved.
//

import Foundation
import CoreData

/**
*  Struct with the needed information to initialize the iCloud stack
*/
public struct iCloudData
{
    /// Is the full AppID (including the Team Prefix). It's needed to change tihs to match the Team Prefix found in the iOS Provisioning profile
    internal let iCloudAppID: String
    /// Is the name of the directory where the database will be stored in. It should always end with .nosync
    internal var iCloudDataDirectoryName: String = "Data.nosync"
    /// Is the name of the directory where the database change logs will be stored in
    internal var iCloudLogsDirectory: String = "Logs"
    
    /**
    Note:
    iCloudData = iCloud + DataDirectory
    iCloudLogs = iCloud + LogsDirectory
    */
    
    /**
    Initializer for the struct
    
    :param: iCloudAppID             iCloud app identifier
    :param: iCloudDataDirectoryName Directory of the database
    :param: iCloudLogsDirectory     Directory of the database logs
    
    :returns: Initialized struct
    */
    public init (iCloudAppID: String, iCloudDataDirectoryName: String?, iCloudLogsDirectory: String?)
    {
        self.iCloudAppID = iCloudAppID
        if (iCloudDataDirectoryName != nil) {self.iCloudDataDirectoryName = iCloudDataDirectoryName!}
        if (iCloudLogsDirectory != nil) {self.iCloudLogsDirectory = iCloudLogsDirectory!}
    }
}

/**
*  iCloud stack for SugarRecord
*/
public class iCloudCDStack: DefaultCDStack
{
    //MARK: - Class properties
    public var loadCompletedClosure: ()->() = {}
    
    //MARK: - Properties
    
    /// iCloud Data struct with the information
    private var icloudData: iCloudData?
    
    /// Notification center used for iCloud Notifications
    lazy var notificationCenter: NSNotificationCenter = NSNotificationCenter.defaultCenter()
    
    /**
    Initialize the CoreData stack
    
    :param: databaseURL   NSURL with the database path
    :param: model         NSManagedObjectModel with the database model
    :param: automigrating Bool Indicating if the migration has to be automatically executed
    :param: icloudData    iCloudData information
    :param: completion Closure to be executed when iCloud stack finishes initializing
    
    :returns: iCloudCDStack object
    */
    public init(databaseURL: NSURL, model: NSManagedObjectModel?, automigrating: Bool, icloudData: iCloudData, completion: ()->())
    {
        super.init(databaseURL: databaseURL, model: model, automigrating: automigrating)
        self.loadCompletedClosure = completion
        self.icloudData = icloudData
        self.automigrating = automigrating
        self.databasePath = databaseURL
        self.managedObjectModel = model
        self.migrationFailedClosure = {}
        self.name = "iCloudCoreDataStack"
        self.stackDescription = "Stack to connect your local storage with iCloud"
    }
    
    /**
    Initialize the CoreData default stack passing the database name and a flag indicating if the automigration has to be automatically executed
    
    :param: databaseName  String with the database name
    :param: icloudData iCloud Data struct
    :param: completion Closure to be executed when iCloud stack finishes initializing
    
    :returns: DefaultCDStack object
    */
    convenience public init(databaseName: String, icloudData: iCloudData, completion: ()->())
    {
        self.init(databaseURL: iCloudCDStack.databasePathURLFromName(databaseName), icloudData: icloudData, completion: completion)
    }
    
    /**
    Initialize the CoreData default stack passing the database path in String format and a flag indicating if the automigration has to be automatically executed
    
    :param: databasePath  String with the database path
    :param: icloudData iCloud Data struct
    :param: completion Closure to be executed when iCloud stack finishes initializing
    
    :returns: DefaultCDStack object
    */
    convenience public init(databasePath: String, icloudData: iCloudData, completion: ()->())
    {
        self.init(databaseURL: NSURL(fileURLWithPath: databasePath)!, icloudData: icloudData, completion: completion)
    }
    
    /**
    Initialize the CoreData default stack passing the database path URL and a flag indicating if the automigration has to be automatically executed
    
    :param: databaseURL   NSURL with the database path
    :param: icloudData iCloud Data struct
    :param: completion Closure to be executed when iCloud stack finishes initializing

    :returns: DefaultCDStack object
    */
    convenience public init(databaseURL: NSURL, icloudData: iCloudData, completion: ()->())
    {
        self.init(databaseURL: databaseURL, model: nil, automigrating: true,icloudData: icloudData, completion: completion)
    }
    
    /**
    Initialize the CoreData default stack passing the database name, the database model object and a flag indicating if the automigration has to be automatically executed
    
    :param: databaseName  String with the database name
    :param: model         NSManagedObjectModel with the database model
    :param: icloudData iCloud Data struct
    :param: completion Closure to be executed when iCloud stack finishes initializing

    :returns: DefaultCDStack object
    */
    convenience public init(databaseName: String, model: NSManagedObjectModel, icloudData: iCloudData, completion: ()->())
    {
        self.init(databaseURL: DefaultCDStack.databasePathURLFromName(databaseName), model: model, automigrating: true, icloudData: icloudData, completion: completion)
    }
    
    /**
    Initialize the CoreData default stack passing the database path in String format, the database model object and a flag indicating if the automigration has to be automatically executed
    
    :param: databasePath  String with the database path
    :param: model         NSManagedObjectModel with the database model
    :param: icloudData iCloud Data struct
    :param: completion Closure to be executed when iCloud stack finishes initializing
    
    :returns: DefaultCDStack object
    */
    convenience public init(databasePath: String, model: NSManagedObjectModel, icloudData: iCloudData, completion: ()->())
    {
        self.init(databaseURL: NSURL(fileURLWithPath: databasePath)!, model: model, automigrating: true, icloudData: icloudData, completion: completion)
    }
    
    /**
    Initialize the stacks components and the connections between them
    */
    public override func initialize()
    {
        SugarRecordLogger.logLevelInfo.log("Initializing the stack: \(self.stackDescription)")
        createManagedObjecModelIfNeeded()
        persistentStoreCoordinator = createPersistentStoreCoordinator()
        addDatabase(foriCloud: true, completionClosure: self.dataBaseAddedClosure())
    }
    
    /**
    Returns the closure to be execute once the database has been created
    */
    override public func dataBaseAddedClosure() -> CompletionClosure {
        return { [weak self] (error) -> () in
            if self == nil {
                SugarRecordLogger.logLevelFatal.log("The stack was released while trying to initialize it")
                return
            }
            else if error != nil {
                SugarRecordLogger.logLevelFatal.log("Something went wrong adding the database")
                return
            }
            self!.rootSavingContext = self!.createRootSavingContext(self!.persistentStoreCoordinator)
            self!.mainContext = self!.createMainContext(self!.rootSavingContext)
            self!.addObservers()
            self!.stackInitialized = true
            
            self!.loadCompletedClosure()
        }
    }
    
    
    //MARK: - Contexts
    
    /**
    Creates a temporary root saving context to be used in background operations
    Note: This overriding is due to the fact that in this case the merge policy is different
    
    :param: persistentStoreCoordinator NSPersistentStoreCoordinator to be set as the persistent store coordinator of the created context
    
    :returns: Private NSManageObjectContext
    */
    override internal func createRootSavingContext(persistentStoreCoordinator: NSPersistentStoreCoordinator?) -> NSManagedObjectContext
    {
        SugarRecordLogger.logLevelVerbose.log("Creating Root Saving context")
        var context: NSManagedObjectContext?
        if persistentStoreCoordinator == nil {
            SugarRecord.handle(NSError(domain: "The persistent store coordinator is not initialized", code: SugarRecordErrorCodes.CoreDataError.rawValue, userInfo: nil))
        }
        context = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        context!.persistentStoreCoordinator = persistentStoreCoordinator!
        context!.addObserverToGetPermanentIDsBeforeSaving()
        context!.name = "Root saving context"
        context!.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        SugarRecordLogger.logLevelVerbose.log("Created MAIN context")
        return context!
    }
    
    
    //MARK: - Database
    
    /**
    Add iCloud Database
    */
    internal func addDatabase(foriCloud icloud: Bool, completionClosure: CompletionClosure)
    {
        /**
        *  In case of not for iCloud
        */
        if !icloud {
            self.addDatabase(completionClosure)
            return
        }
        /**
        *  Database creation is an asynchronous process
        */
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { [weak self] () -> Void in
            
            // Ensuring that the stack hasn't been released
            if self == nil {
                SugarRecordLogger.logLevelFatal.log("The stack was initialized while trying to add the database")
                return
            }
            
            // Checking that the PSC exists before adding the store
            if self!.persistentStoreCoordinator == nil {
                SugarRecord.handle(NSError())
            }
            
            // Logging some data
            let fileManager: NSFileManager = NSFileManager()
            SugarRecordLogger.logLevelVerbose.log("Initializing iCloud with:")
            SugarRecordLogger.logLevelVerbose.log("iCloud App ID: \(self!.icloudData?.iCloudAppID)")
            SugarRecordLogger.logLevelVerbose.log("iCloud Data Directory: \(self!.icloudData?.iCloudDataDirectoryName)")
            SugarRecordLogger.logLevelVerbose.log("iCloud Logs Directory: \(self!.icloudData?.iCloudLogsDirectory)")
            
            //Getting the root path for iCloud
            let iCloudRootPath: NSURL? = fileManager.URLForUbiquityContainerIdentifier(self!.icloudData?.iCloudAppID)

            /**
            *  If iCloud if accesible keep creating the PSC
            */
            if iCloudRootPath != nil {
                let iCloudLogsPath: NSURL = NSURL(fileURLWithPath: iCloudRootPath!.path!.stringByAppendingPathComponent(self!.icloudData!.iCloudLogsDirectory))!
                let iCloudDataPath: NSURL = NSURL(fileURLWithPath: iCloudRootPath!.path!.stringByAppendingPathComponent(self!.icloudData!.iCloudDataDirectoryName))!

                // Creating data path in case of doesn't existing
                var error: NSError?
                if !fileManager.fileExistsAtPath(iCloudDataPath.path!) {
                    fileManager.createDirectoryAtPath(iCloudDataPath.path!, withIntermediateDirectories: true, attributes: nil, error: &error)
                }
                if error != nil {
                    completionClosure(error: error!)
                    return
                }
                
                /// Getting the database path
                /// iCloudPath + iCloudDataPath + DatabaseName
                let path: String? = iCloudRootPath?.path?.stringByAppendingPathComponent((self?.icloudData?.iCloudDataDirectoryName)!).stringByAppendingPathComponent((self?.databasePath?.lastPathComponent)!)
                self!.databasePath = NSURL(fileURLWithPath: path!)
                
                // Adding store
                self!.persistentStoreCoordinator!.lock()
                error = nil
                var store: NSPersistentStore? = self!.persistentStoreCoordinator?.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: self!.databasePath, options: iCloudCDStack.icloudStoreOptions(contentNameKey: self!.icloudData!.iCloudAppID, contentURLKey: iCloudLogsPath), error: &error)
                self!.persistentStoreCoordinator!.unlock()
                self!.persistentStore = store!

                // Calling completion closure
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completionClosure(error: nil)
                })
            }
            /**
            *  Otherwise use the local store
            */
            else {
                self!.addDatabase(foriCloud: false, completionClosure: completionClosure)
            }
        })
    }
    
    
    //MARK: - Database Helpers
    
    /**
    Returns the iCloud options to be used when the NSPersistentStore is initialized
    
    :returns: [NSObject: AnyObject] with the options
    */
    internal class func icloudStoreOptions(#contentNameKey: String, contentURLKey: NSURL) -> [NSObject: AnyObject]
    {
        var options: [NSObject: AnyObject] = [NSObject: AnyObject] ()
        options[NSMigratePersistentStoresAutomaticallyOption] = NSNumber(bool: true)
        options[NSInferMappingModelAutomaticallyOption] = NSNumber(bool: true)
        options[NSPersistentStoreUbiquitousContentNameKey] = contentNameKey
        options[NSPersistentStoreUbiquitousContentURLKey] = contentURLKey
        return options
    }
    
    
    //MARK: - Observers
    
    /**
    Add required observers to detect changes in psc's or contexts
    */
    internal override func addObservers()
    {
        super.addObservers()

        SugarRecordLogger.logLevelVerbose.log("Adding observers to detect changes on iCloud")
        
        // Store will change
        notificationCenter.addObserver(self, selector: Selector("storesWillChange:"), name: NSPersistentStoreCoordinatorStoresWillChangeNotification, object: nil)
        
        // Store did change
        notificationCenter.addObserver(self, selector: Selector("storeDidChange:"), name: NSPersistentStoreCoordinatorStoresDidChangeNotification, object: nil)

        // Did import Ubiquituous Content
        notificationCenter.addObserver(self, selector: Selector("persistentStoreDidImportUbiquitousContentChanges:"), name: NSPersistentStoreDidImportUbiquitousContentChangesNotification, object: nil)
    }

    /**
    Detects changes in the Ubiquituous Container (iCloud) and bring them to the stack contexts
    
    :param: notification Notification with these changes
    */
    dynamic internal func persistentStoreDidImportUbiquitousContentChanges(notification: NSNotification)
    {
        SugarRecordLogger.logLevelVerbose.log("Changes detected from iCloud. Merging them into the current CoreData stack")
        self.rootSavingContext!.performBlock { [weak self] () -> Void in
            if self == nil {
                SugarRecordLogger.logLevelWarn.log("The stack was released while trying to bring changes from the iCloud Container")
                return
            }
            self!.rootSavingContext!.mergeChangesFromContextDidSaveNotification(notification)
            self!.mainContext!.performBlock({ () -> Void in
                self!.mainContext!.mergeChangesFromContextDidSaveNotification(notification)
            })
        }
    }
    
    /**
    Posted before the list of open persistent stores changes.
    
    :param: notification Notification with these changes
    */
    dynamic internal func storesWillChange(notification: NSNotification)
    {
        SugarRecordLogger.logLevelVerbose.log("Stores will change, saving pending changes before changing store")
        self.saveChanges()
    }
    
    
    /**
    Called when the store did change from the persistent store coordinator
    
    :param: notification Notification with the information
    */
    dynamic internal func storeDidChange(notification: NSNotification)
    {
        SugarRecordLogger.logLevelVerbose.log("The persistent store of the psc did change")
        // Nothing to do here
    }
}