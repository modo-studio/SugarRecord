//
//  NSManagedObjectContext+iCloud.swift
//  SugarRecord
//
//  Created by Pedro Piñera Buendía on 29/08/14.
//  Copyright (c) 2014 PPinera. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObjectContext {
    func stopObservingiCloudChanges(inCoordinator coordinator: NSPersistentStoreCoordinator) {
        if !SugarRecord.iCloudEnabled() { return }
        NSNotificationCenter.defaultCenter().removeObserver(self, name: NSPersistentStoreDidImportUbiquitousContentChangesNotification, object: coordinator)
    }
    
    func observeiCloudChanges(inCoordinator coordinator: NSPersistentStoreCoordinator) {
        if !SugarRecord.iCloudEnabled() { return }
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("mergeChangesFromiCloud"), name: NSPersistentStoreDidImportUbiquitousContentChangesNotification, object: coordinator)
    }

    func mergeChangesFromiCloud(#notification: NSNotification) {
        self.performBlock() {
            SugarRecordLogger.logLevelVerbose.log("Merging changes from iCloud into context \(self.workingName()) in MainThread: \(NSThread.isMainThread())")
            self.mergeChangesFromContextDidSaveNotification(notification)
            NSNotificationCenter.defaultCenter().postNotificationName(srKVODidMergeChangesFromiCloudNotification, object: self, userInfo: notification.userInfo)
        }
    }
}