//
//  RestkitCDStack.swift
//  SugarRecord
//
//  Created by Pedro Piñera Buendía on 28/09/14.
//  Copyright (c) 2014 SugarRecord. All rights reserved.
//

import Foundation
import CoreData

public class RestkitCDStack: DefaultCDStack
{
    override public func initialize() {
        createPathIfNecessary(forFilePath: self.databasePath!)
        createManagedObjecModelIfNeeded()
        let store = createRKManagedObjectStore()
        var error: NSError?
        let storePath: String = RKApplicationDataDirectory().stringByAppendingPathComponent("RestKit")
        do {
            try store.addSQLitePersistentStoreAtPath(storePath, fromSeedDatabaseAtPath: nil, withConfiguration: nil, options: nil)
        } catch let error1 as NSError {
            error = error1
        }
        if error != nil {
            SugarRecord.handle(error)
        }
        store.createManagedObjectContexts()
        self.persistentStoreCoordinator = store.persistentStoreCoordinator
        self.rootSavingContext = store.persistentStoreManagedObjectContext
        self.mainContext = store.mainQueueManagedObjectContext
        self.stackInitialized = true
    }
    
    internal func createRKManagedObjectStore() -> RKManagedObjectStore
    {
        return RKManagedObjectStore(managedObjectModel: self.managedObjectModel!)
    }
}