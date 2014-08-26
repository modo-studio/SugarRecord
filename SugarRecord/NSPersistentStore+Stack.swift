//
//  NSPersistentStore+Stack.swift
//  SugarRecord
//
//  Created by Pedro Piñera Buendía on 26/08/14.
//  Copyright (c) 2014 PPinera. All rights reserved.
//

import Foundation

extension NSPersistentStore {

    struct Static {
        static var dPS: NSPersistentStore? = nil
    }

    /**
     Returns the default persistent store

     :returns: NSPersistentStore default
     */
    class func defaultPersistentStore () -> (NSPersistentStore?) {
        return Static.dPS
    }

    /**
     Set the default persistent store

     :param: ps NSPersistentStore to set as default one
     */
    class func setDefaultPersistentStore (ps: NSPersistentStore) {
        Static.dPS = ps
    }

    /**
     Returns a directory given a NSSearchPathDirectory

     :param: directory NSSearchPathDirectory with the type of directory

     :returns: String with the path
     */
    class func directory(directory: NSSearchPathDirectory) -> (String) {
        let documetsPath : AnyObject = NSSearchPathForDirectoriesInDomains(directory, .UserDomainMask, true)[0]
        return documetsPath as String
    }
    
    /**
     Returns the application documments directory

     :returns: String with the directory
     */
    class func applicationDocumentsDirectory() -> (String) {
        return directory(.DocumentDirectory)
    }
    
    /**
     Returns the application storage directory

     :returns: String with the application directory
     */
    class func applicationStorageDirectory() -> (String) {
        var applicationName: String = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleName") as String
        return directory(.ApplicationSupportDirectory).stringByAppendingPathComponent(applicationName)
    }
    
    /**
     Returns the local store path

     :param: dbName String with the database name

     :returns: NSURL with the path
     */
    class func storeUrl(forDatabaseName dbName: String) -> (NSURL) {
        let paths: [String] = [applicationDocumentsDirectory(), applicationStorageDirectory()]
        let fileManager: NSFileManager = NSFileManager()
        
        for path:String in paths {
            let filePath: String = path.stringByAppendingPathComponent(dbName)
            if fileManager.fileExistsAtPath(filePath) {
                return NSURL.fileURLWithPath(filePath)!
            }
        }
        return NSURL.fileURLWithPath(applicationStorageDirectory().stringByAppendingPathComponent(dbName))!
    }
    
    /**
     Returns the default store path

     :returns: NSURL with the default store path
     */
    class func defaultStoreUrl() -> (NSURL) {
        return storeUrl(forDatabaseName: srDefaultDatabaseName)
    }
    
    /**
     Clean up the default persistent store
     */
    class func cleanUp () -> () {
        Static.dPS = nil
    }
}
