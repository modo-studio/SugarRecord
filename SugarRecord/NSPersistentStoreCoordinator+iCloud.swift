//
//  NSPersistentStoreCoordinator+iCloud.swift
//  SugarRecord
//
//  Created by Pedro Piñera Buendía on 29/08/14.
//  Copyright (c) 2014 PPinera. All rights reserved.
//

import Foundation

extension NSPersistentStoreCoordinator {
    class func coordinator(withiCloudContainer container: String, contentNameKey: String, localStoreNamed: String, cloudStorePath: String, completion: (() -> ())?) -> NSPersistentStoreCoordinator {
        let model: NSManagedObjectModel = NSManagedObjectModel.defaultManagedObjectModel()
        let psc: NSPersistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        psc.addiCloudContainer(container, contentNameKey: contentNameKey, localStoreNamed: localStoreNamed, cloudStorePath: cloudStorePath, completion: completion)
        return psc
    }

    class func coordinator(withiCloudContainer container: String, contentNameKey: String, localStoreNamed: String, cloudStorePath: String) -> NSPersistentStoreCoordinator {
        return coordinator(withiCloudContainer: container, contentNameKey: contentNameKey, localStoreNamed: localStoreNamed, cloudStorePath: cloudStorePath, completion: nil)
    }


    func addiCloudContainer(iCloudContainer: String, contentNameKey: String, localStoreNamed: String, cloudStorePath: String) {
        addiCloudContainer(iCloudContainer, contentNameKey: contentNameKey, localStoreNamed: localStoreNamed, cloudStorePath: cloudStorePath, completion: nil)
    }
    
    func addiCloudContainer(iCloudContainer: String, contentNameKey: String, localStoreNamed: String, cloudStorePath: String, completion: (() -> ())?) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            var cloudURL: NSURL = NSPersistentStore.cloudURLForUbiquitiousContainer(iCloudContainer)
            cloudURL = cloudURL.URLByAppendingPathComponent(cloudStorePath)
            SugarRecord.setICloudEnabled(true)
            var options: [NSObject: AnyObject] = NSPersistentStoreCoordinator.autoMigrateOptions()
            NSPersistentStoreCoordinator.addiCloudOptionsTo(options, contentNameKey: contentNameKey, cloudURL: cloudURL)
            self.lock()
            self.addDatabase(localStoreNamed, withOptions: options)
            self.unlock()
            dispatch_async(dispatch_get_main_queue(), {
                if NSPersistentStore.defaultPersistentStore() == nil {
                    NSPersistentStore.setDefaultPersistentStore(self.persistentStores.first as NSPersistentStore)
                }
                if completion != nil {
                    completion!()
                }
                NSNotificationCenter.defaultCenter().postNotificationName(srKVOPSCDidCompleteiCloudSetupNotification, object: nil)
            })
        })
    }

    class func addiCloudOptionsTo(var options: [NSObject: AnyObject], contentNameKey: String, cloudURL: NSURL) {
        // Adding iCloud options
        options[NSPersistentStoreUbiquitousContentNameKey] = contentNameKey
        options[NSPersistentStoreUbiquitousContentURLKey] = cloudURL
    }
}