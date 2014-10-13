//
//  iCloudCDStack.swift
//  SugarRecord
//
//  Created by Pedro Piñera Buendía on 12/10/14.
//  Copyright (c) 2014 SugarRecord. All rights reserved.
//

import Foundation

public struct iCloudData
{
    let iCloudAppID: String!
    let iCloudDataDirectoryName: String?
    let iCloudLogsDirectory: String?
    
    public init (iCloudAppID: String, iCloudDataDirectoryName: String?, iCloudLogsDirectory: String?)
    {
        self.iCloudAppID = iCloudAppID
        self.iCloudDataDirectoryName = iCloudDataDirectoryName
        self.iCloudLogsDirectory = iCloudLogsDirectory
    }
}

public class iCloudCDStack: DefaultCDStack
{
    //MARK: - Properties
    private let icloudData: iCloudData?
    
    //MARK: - Constructors
    
    /**
    Initialize the CoreData stack
    
    :param: databaseURL   NSURL with the database path
    :param: model         NSManagedObjectModel with the database model
    :param: automigrating Bool Indicating if the migration has to be automatically executed
    :param: icloudData    iCloudData information
    
    :returns: iCloudCDStack object
    */
    public init(databaseURL: NSURL, model: NSManagedObjectModel?, automigrating: Bool, icloudData: iCloudData)
    {
        super.init(databaseURL: databaseURL, model: model, automigrating: automigrating)
        self.icloudData = icloudData
        self.automigrating = automigrating
        self.databasePath = databaseURL
        self.managedObjectModel = model
        self.migrationFailedClosure = {}
    }
    
    /**
    Initialize the CoreData default stack passing the database name and a flag indicating if the automigration has to be automatically executed
    
    :param: databaseName  String with the database name
    :param: icloudData iCloud Data struct
    
    :returns: DefaultCDStack object
    */
    convenience public init(databaseName: String, icloudData: iCloudData)
    {
        self.init(databaseURL: iCloudCDStack.databasePathURLFromName(databaseName), icloudData: icloudData)
    }
    
    /**
    Initialize the CoreData default stack passing the database path in String format and a flag indicating if the automigration has to be automatically executed
    
    :param: databasePath  String with the database path
    :param: icloudData iCloud Data struct
    
    :returns: DefaultCDStack object
    */
    convenience public init(databasePath: String, icloudData: iCloudData)
    {
        self.init(databaseURL: NSURL(fileURLWithPath: databasePath), icloudData: icloudData)
    }
    
    /**
    Initialize the CoreData default stack passing the database path URL and a flag indicating if the automigration has to be automatically executed
    
    :param: databaseURL   NSURL with the database path
    :param: icloudData iCloud Data struct

    :returns: DefaultCDStack object
    */
    convenience public init(databaseURL: NSURL, icloudData: iCloudData)
    {
        self.init(databaseURL: databaseURL, model: nil, automigrating: true,icloudData: icloudData)
    }
    
    /**
    Initialize the CoreData default stack passing the database name, the database model object and a flag indicating if the automigration has to be automatically executed
    
    :param: databaseName  String with the database name
    :param: model         NSManagedObjectModel with the database model
    :param: icloudData iCloud Data struct

    :returns: DefaultCDStack object
    */
    convenience public init(databaseName: String, model: NSManagedObjectModel, icloudData: iCloudData)
    {
        self.init(databaseURL: DefaultCDStack.databasePathURLFromName(databaseName), model: model, automigrating: true, icloudData: icloudData)
    }
    
    /**
    Initialize the CoreData default stack passing the database path in String format, the database model object and a flag indicating if the automigration has to be automatically executed
    
    :param: databasePath  String with the database path
    :param: model         NSManagedObjectModel with the database model
    :param: icloudData iCloud Data struct
    
    :returns: DefaultCDStack object
    */
    convenience public init(databasePath: String, model: NSManagedObjectModel, icloudData: iCloudData)
    {
        self.init(databaseURL: NSURL(fileURLWithPath: databasePath), model: model, automigrating: true, icloudData: icloudData)
    }
    
    
    //MARK: - Initializers
    
    /**
    Initialize the stacks components and the connections between them
    */
    public override func initialize()
    {
        createManagedObjecModelIfNeeded()
        persistentStoreCoordinator = createPersistentStoreCoordinator()
        addDatabase()
        rootSavingContext = createRootSavingContext(self.persistentStoreCoordinator)
        mainContext = createMainContext(self.rootSavingContext)
    }
    
    /**
    Add iCloud Database
    */
    internal func addiCloudDatabase()
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            
            
            
            
            
        })
        let icloudStoreURL: NSURL = NSURL();
        var options: [NSObject: AnyObject] = iCloudCDStack.autoMigrateStoreOptions()
        options[NSPersistentStoreUbiquitousContentNameKey] = "Content Name Key"
        options[NSPersistentStoreUbiquitousContentURLKey] = "Content URL Key"

    }
}


/*
dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
    NSURL *cloudURL = [NSPersistentStore MR_cloudURLForUbiqutiousContainer:containerID];
    if (subPathComponent)
    {
        cloudURL = [cloudURL URLByAppendingPathComponent:subPathComponent];
    }
    
    [MagicalRecord setICloudEnabled:cloudURL != nil];

    
    if ([self respondsToSelector:@selector(performBlockAndWait:)])
    {
        [self performSelector:@selector(performBlockAndWait:) withObject:^{
            [self MR_addSqliteStoreNamed:storeIdentifier withOptions:options];
        }];
    }
    else
    {
        [self lock];
        [self MR_addSqliteStoreNamed:storeIdentifier withOptions:options];
        [self unlock];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([NSPersistentStore MR_defaultPersistentStore] == nil)
        {
            [NSPersistentStore MR_setDefaultPersistentStore:[[self persistentStores] firstObject]];
        }
        if (completionBlock)
        {
            completionBlock();
        }
        NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
        [notificationCenter postNotificationName:kMagicalRecordPSCDidCompleteiCloudSetupNotification object:nil];
        });
    });*/