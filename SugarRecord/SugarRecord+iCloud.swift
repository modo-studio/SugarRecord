//
//  SugarRecord+iCloud.swift
//  SugarRecord
//
//  Created by Pedro Piñera Buendía on 27/08/14.
//  Copyright (c) 2014 PPinera. All rights reserved.
//

import Foundation

public extension SugarRecord {
    struct iCloudStatic {
        static var iCloudEnabled : Bool = false
    }

    /**
     Returns if iCloud is enabled

     :returns: Bool indicating if iCloud is enabled or not
     */
    class func iCloudEnabled() -> (Bool) {
        return iCloudStatic.iCloudEnabled
    }

    /**
     Set iCloud as enabled/disabled

     :param: iCloudEnabled Bool indicating if iCloud is enabled
     */
    class func setICloudEnabled(iCloudEnabled: Bool) {
        SugarRecordLogger.logLevelInfo.log("Setting iCloudEnabled: \(iCloudEnabled)")
        iCloudStatic.iCloudEnabled = iCloudEnabled
    }
    
    /**
     Setup the Core Data stack for iCloud

     :param: iCloudContainer String with the iCloud container name
     :param: localStoreName  String with the name of the local store
     */
    class func setupCoreDataStack(withiCloudContainer iCloudContainer: String, localStoreName: String) {
        let contentName: AnyObject? = NSBundle.mainBundle().infoDictionary[kCFBundleIdentifierKey]
        self.setupCoreDataStack(withiCloudContainer: iCloudContainer, contentNameKey: contentName! as String, localStoreName: localStoreName, cloudStorePath: "")
    }

    /**
     Setup the Core Data stack for iCloud

     :param: iCloudContainer String with the iCloud container name
     :param: contentNameKey  String to specify the content name (specially useful if you are managing multiple different iCloud stores
     :param: localStoreName  String with the name of the local store
     :param: cloudStorePath  String with the path if you don't want to use the root one
     */
    class func setupCoreDataStack(withiCloudContainer iCloudContainer: String, contentNameKey: String, localStoreName: String, cloudStorePath: String) {
        self.setupCoreDataStack(withiCloudContainer: iCloudContainer, contentNameKey: contentNameKey, localStoreName: localStoreName, cloudStorePath: cloudStorePath, completion: nil)
    }

    /**
     Setup the Core Data stack for iCloud

     :param: iCloudContainer String with the iCloud container name
     :param: contentNameKey  String to specify the content name (specially useful if you are managing multiple different iCloud stores
     :param: localStoreName  String with the name of the local store
     :param: cloudStorePath  String with the path if you don't want to use the root one
     :param: completion      Closure to be completed when setup is completed
     */
    class func setupCoreDataStack(withiCloudContainer iCloudContainer: String, contentNameKey: String, localStoreName: String, cloudStorePath: String,  completion: (()->())?) {
        let coordinator: NSPersistentStoreCoordinator = NSPersistentStoreCoordinator.coordinator(withiCloudContainer: iCloudContainer, contentNameKey: contentNameKey, localStoreNamed: localStoreName, cloudStorePath: cloudStorePath, completion: completion)
        NSPersistentStoreCoordinator.setDefaultPersistentStoreCoordinator(coordinator)
        NSManagedObjectContext.initializeContextsStack(coordinator)
    }
}
