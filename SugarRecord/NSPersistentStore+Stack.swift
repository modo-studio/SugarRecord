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
    class func defaultPersistentStore () -> (NSPersistentStore?) {
        return Static.dPS
    }
    class func setDefaultPersistentStore (ps: NSPersistentStore) {
        Static.dPS = ps
    }
    
    class func directory(directory: NSSearchPathDirectory) -> (String) {
        let documetsPath : AnyObject = NSSearchPathForDirectoriesInDomains(directory, .UserDomainMask, true)[0]
        return documetsPath as String
    }
    
    class func applicationDocumentsDirectory() -> (String) {
        return directory(.DocumentDirectory)
    }
    
    class func applicationStorageDirectory() -> (String) {
        var applicationName: String = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleName") as String
        return directory(.ApplicationSupportDirectory).stringByAppendingPathComponent(applicationName)
    }
    
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
    
    class func defaultStoreUrl() -> (NSURL) {
        return storeUrl(forDatabaseName: srDefaultDatabaseName)
    }
    
    // Cleanup
    class func cleanUp () -> () {
        Static.dPS = nil
    }
}
