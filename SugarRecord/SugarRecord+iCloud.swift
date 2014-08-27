//
//  SugarRecord+iCloud.swift
//  SugarRecord
//
//  Created by Pedro Piñera Buendía on 27/08/14.
//  Copyright (c) 2014 PPinera. All rights reserved.
//

import Foundation

extension SugarRecord {
    struct iCloudStatic {
        static var iCloudEnabled : Bool = false
    }

    class func iCloudEnabled() -> (Bool) {
        return iCloudStatic.iCloudEnabled
    }

    class func setICloudEnabled(iCloudEnabled: Bool) {
        iCloudStatic.iCloudEnabled = iCloudEnabled
    }
    
    class func setupCoreDataStack(withiCloudContainer iCloudContainer: String, localStoreName: String) {
        let contentName: String = NSBundle.mainBundle().infoDictionary[kCFBundleIdentifierKey] as String
        self.setupCoreDataStack(withiCloudContainer: iCloudContainer, contentNameKey: contentName, localStoreName: localStoreName, cloudStorePath: nil)
    }

    class func setupCoreDataStack(withiCloudContainer iCloudContainer: String, contentNameKey: String, localStoreName: String, cloudStorePath: String?) {
        self.setupCoreDataStack(iCloudContainer, contentNameKey: contentNameKey, localStoreName: localStoreName, cloudStorePath: cloudStorePath, completion: nil)
    }

    class func setupCoreDataStack(withiCloudContainer iCloudContainer: String, contentNameKey: String, localStoreName: String, cloudStorePath: String?,  completion: (()->())?) {
        //TODO: Create the persistent store coordinator for iCloud (MR_coordinatorWithiCloudContainerID:containerID)
        let coordinator: NSPersistentStoreCoordinator? = coordinator
        NSPersistentStoreCoordinator.setDefaultPersistentStoreCoordinator(coordinator)
        NSManagedObjectContext.initializeContextsStack(coordinator)
    }
}
