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
        let store: RKManagedObjectStore = RKManagedObjectStore(managedObjectModel: self.managedObjectModel!)
        var error: NSError?
        store.addSQLitePersistentStoreAtPath(self.databasePath!.absoluteString, fromSeedDatabaseAtPath: nil, withConfiguration: nil, options: nil, error: &error)
        if error != nil {
            SugarRecord.handle(error)
        }
        store.createManagedObjectContexts()
        self.persistentStoreCoordinator = store.persistentStoreCoordinator
        self.rootSavingContext = store.persistentStoreManagedObjectContext
        self.mainContext = store.mainQueueManagedObjectContext
    }
}