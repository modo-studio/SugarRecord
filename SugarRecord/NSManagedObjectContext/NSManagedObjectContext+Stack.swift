//
//  NSManagedObjectContext+Stack.swift
//  SugarRecord
//
//  Created by Pedro Piñera Buendía on 26/08/14.
//  Copyright (c) 2014 PPinera. All rights reserved.
//

import Foundation

// MARK - NSManagedObjectContext Extension

extension NSManagedObjectContext {
    struct Static {
        static var rootSavingContext: NSManagedObjectContext? = nil
        static var defaultContext: NSManagedObjectContext? = nil
        static var ubiquitySetupNotificationObserver: AnyObject? = nil
    }

    /**
     Returns the root saving context

     :returns: NSManagedObjectContext with the default root saving context
     */
    class func rootSavingContext() -> NSManagedObjectContext? {
        return Static.rootSavingContext
    }

    /**
     Set the default context

     :param: context NSManagedObjectContext to be set as the default one
     */
    class func setRootSavingContext(context: NSManagedObjectContext?) {
        if Static.rootSavingContext != nil  {
            NSNotificationCenter.defaultCenter().removeObserver(Static.rootSavingContext!)
        }
        Static.rootSavingContext = context
        if Static.rootSavingContext == nil {
            return
        }
        Static.rootSavingContext!.addObserverToGetPermanentIDsBeforeSaving()
        Static.rootSavingContext!.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        Static.rootSavingContext!.setWorkingName("Root saving context")
        SugarRecordLogger.logLevelInfo.log("Changing root saving context")
    }
    
    /**
     Returns the default context

     :returns: NSManagedObjectContext with the default context
     */
    class func defaultContext() -> NSManagedObjectContext? {
        return Static.defaultContext
    }
    
    // Default Context Setter
    class func setDefaultContext(context: NSManagedObjectContext?) {

        let coordinator: NSPersistentStoreCoordinator = NSPersistentStoreCoordinator.defaultPersistentStoreCoordinator()!

        // Removing observer if existing defaultContext
        if Static.defaultContext != nil  {
            NSNotificationCenter.defaultCenter().removeObserver(Static.defaultContext!)
        }

        if Static.ubiquitySetupNotificationObserver != nil {
            NSNotificationCenter.defaultCenter().removeObserver(Static.ubiquitySetupNotificationObserver!)
            Static.ubiquitySetupNotificationObserver = nil
        }

        if SugarRecord.iCloudEnabled() && Static.defaultContext != nil{
            Static.defaultContext?.stopObservingiCloudChanges(inCoordinator: coordinator)
        }

        Static.defaultContext = context
        if Static.defaultContext == nil {
            return
        }
        Static.defaultContext!.setWorkingName("Default context")
        SugarRecordLogger.logLevelInfo.log("Changing default context. New context: \(defaultContext())")
        // Adding observer to listn changes in rootContext
        if rootSavingContext() != nil {
            NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("rootContextChanged:"), name: NSManagedObjectContextDidSaveNotification, object: rootSavingContext())
        }
        Static.defaultContext!.addObserverToGetPermanentIDsBeforeSaving()

        if SugarRecord.iCloudEnabled() {
            defaultContext()!.observeiCloudChanges(inCoordinator: coordinator)
        }
        else {
            Static.ubiquitySetupNotificationObserver = NSNotificationCenter.defaultCenter().addObserverForName(srKVOPSCDidCompleteiCloudSetupNotification, object: nil, queue: NSOperationQueue.mainQueue(), usingBlock: {(notification: NSNotification!) in
                    self.defaultContext()!.observeiCloudChanges(inCoordinator: coordinator)
                })
        }
    }


    /**
     Creates a new context with a passed psc as a persistant store coordinator

     :param: persistentStoreCoordinator NSPersistentStoreCoordinator of the returned context

     :returns: NSManagedObjectContext created
     */
    class func newContextWithPersistentStoreCoordinator(persistentStoreCoordinator: NSPersistentStoreCoordinator) -> NSManagedObjectContext {
        return NSManagedObjectContext.newContext(nil, persistentStoreCoordinator: persistentStoreCoordinator)
    }

    /**
     Creates a context and set the passed one as the parent

     :param: parentContext NSManagedObjectContext parent of the created one

     :returns: NSManagedObjectContext with the created context
     */
    class func newContextWithParentContext(parentContext: NSManagedObjectContext) -> NSManagedObjectContext {
        return NSManagedObjectContext.newContext(parentContext, persistentStoreCoordinator: nil)
    }

    /**
     Creates a new context and set the parentContext or the persistentStoreCoordinator depending on the passed values

     :param: parentContext              NSManagedObjectContext to be set as a parent
     :param: persistentStoreCoordinator NSPersistentStoreCoordinator to be set as the psc

     :returns: NSManagedObjectContext with the created context
     */
    class func newContext(parentContext: NSManagedObjectContext?, persistentStoreCoordinator: NSPersistentStoreCoordinator?) -> NSManagedObjectContext {
        var newContext: NSManagedObjectContext?
        if parentContext != nil {
            newContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
            newContext?.parentContext = parentContext
        }
        else if persistentStoreCoordinator != nil {
            newContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
            newContext?.persistentStoreCoordinator = persistentStoreCoordinator
        }
        else {
            SugarRecordLogger.logLevelFatal.log("Either parentContext or persistentStoreCoordinator has to be passed")
        }
        SugarRecordLogger.logLevelInfo.log("Created new context - \(newContext)")
        return newContext!
    }

    /**
     Initialize the SugarRecord contexts stack

     :param: persistentStoreCoordinator NSPersistentStoreCoordinator of the stack

     */
    class func initializeContextsStack(persistentStoreCoordinator: NSPersistentStoreCoordinator) {
        SugarRecordLogger.logLevelInfo.log("Creating contexts stack")
        var rootContext: NSManagedObjectContext = NSManagedObjectContext.newContext(nil, persistentStoreCoordinator: persistentStoreCoordinator)
        self.setRootSavingContext(rootContext)
        var defaultContext: NSManagedObjectContext = NSManagedObjectContext.newContext(rootContext, persistentStoreCoordinator: nil)
    }
    
    /**
     Reset the default context ensuring  this is executed in the mainThread
     */
    class func resetDefaultContext() {
        var defaultContext: NSManagedObjectContext? = NSManagedObjectContext.defaultContext()
        if defaultContext == nil {
            return
        }
        assert(defaultContext!.concurrencyType == .ConfinementConcurrencyType, "SR-Assert: Not call this method on a confinement context")
        if NSThread.isMainThread() == false {
            dispatch_async(dispatch_get_main_queue(), {
                NSManagedObjectContext.resetDefaultContext()
                });
            return
        }
        defaultContext!.reset()
    }

    /**
     Clean up the default context and the root saving context
     */
    class func cleanUp(){
        NSManagedObjectContext.setRootSavingContext(nil)
        NSManagedObjectContext.setDefaultContext(nil)
    }
}
