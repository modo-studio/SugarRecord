//
//  RestkitCDStack.swift
//  SugarRecord
//
//  Created by Pedro Piñera Buendía on 28/09/14.
//  Copyright (c) 2014 SugarRecord. All rights reserved.
//

import Foundation

public class RestkitCDStack: DefaultCDStack
{
    override public func initialize() {
        createPathIfNecessary(forFilePath: self.databasePath!)
        createManagedObjecModelIfNeeded()
        let store = createRKManagedObjectStore()
        var error: NSError?
        let storePath: String = RKApplicationDataDirectory().stringByAppendingPathComponent("RestKit")
        store.addSQLitePersistentStoreAtPath(storePath, fromSeedDatabaseAtPath: nil, withConfiguration: nil, options: nil, error: &error)
        if error != nil {
            SugarRecord.handle(error)
        }
        store.createManagedObjectContexts()
        self.persistentStoreCoordinator = store.persistentStoreCoordinator
        self.rootSavingContext = store.persistentStoreManagedObjectContext
        self.mainContext = store.mainQueueManagedObjectContext
    }
    
    internal func createRKManagedObjectStore() -> RKManagedObjectStore
    {
        return RKManagedObjectStore(managedObjectModel: self.managedObjectModel!)
    }
}