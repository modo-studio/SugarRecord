//
//  NSManagedObjectContext+Observing.swift
//  SugarRecord
//
//  Created by Pedro Piñera Buendía on 26/08/14.
//  Copyright (c) 2014 PPinera. All rights reserved.
//

import Foundation

extension NSManagedObjectContext {
    /**
     Add observer of self to check when is going to save to ensure items are saved with permanent IDs
     */
    func addObserverToGetPermanentIDsBeforeSaving() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("contextWillSave:"), name: NSManagedObjectContextWillSaveNotification, object: self)
    }
    
    /**
     Method executed before saving that convert temporary IDs into permanet ones

     :param: notification Notification that fired this method
     */
    func contextWillSave(notification: NSNotification) {
        let context: NSManagedObjectContext = notification.object as NSManagedObjectContext
        let insertedObjects: NSSet = context.insertedObjects
        if insertedObjects.count == 0{
            return
        }
        SugarRecordLogger.logLevelInfo.log("\(context.workingName()) is going to save: obtaining permanent IDs for \(insertedObjects.count) new inserted objects")
        var error: NSError?
        let saved: Bool = context.obtainPermanentIDsForObjects(insertedObjects.allObjects, error: &error)
        if !saved {
            SugarRecordLogger.logLevelError.log("Error moving temporary IDs into permanent ones - \(error)")
        }
        
    }
    
    /**
     KVO Fired method executed when something changed in the root saving context

     :param: notification Notification that fired this method
     */
    class func rootContextChanged(notification: NSNotification) {
        if (!NSThread.isMainThread()) {
            dispatch_async(dispatch_get_main_queue(), {
              self.rootContextChanged(notification)
            })
            return
        }
        self.defaultContext()?.mergeChangesFromContextDidSaveNotification(notification)
    }

    /**
     Add observer of other context

     :param: context    NSManagedObjectContext to be observed
     :param: mainThread Bool indicating if it's the main thread
     */
    func startObserving(context: NSManagedObjectContext, inMainThread mainThread: Bool) {
        if mainThread {
            NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("mergeChangesInMainThread:"), name: NSManagedObjectContextDidSaveNotification, object: context)
        }
        else {
            NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("mergeChanges:"), name: NSManagedObjectContextDidSaveNotification, object: context)
        }
    }

    /**
     Stop observing changes from other contexts

     :param: context NSManagedObjectContext that is going to stop observing to
     */
    func stopObserving(context: NSManagedObjectContext) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: NSManagedObjectContextDidSaveNotification, object: nil)
    }
    
    /**
     Method to merge changes from other contexts (fired by KVO)

     :param: notification Notification that fired this method call
     */
    func mergeChanges(fromNotification notification: NSNotification) {
        SugarRecordLogger.logLevelInfo.log("Merging changes from context: \((notification.object as NSManagedObjectContext).workingName()) to context \(self.workingName())")
        self.mergeChangesFromContextDidSaveNotification(notification)
    }
    
    /**
     Method to merge changes from other contexts (in the main thread)

     :param: notification Notification that fired this method call
     */
    func mergeChangesInMainThread(fromNotification notification: NSNotification) {
        dispatch_async(dispatch_get_main_queue(), {
            self.mergeChanges(fromNotification: notification)
        })
    }
}