//
//  DefaultCDStack.swift
//  SugarRecord
//
//  Created by Pedro Piñera Buendía on 15/09/14.
//  Copyright (c) 2014 SugarRecord. All rights reserved.
//

import Foundation
import CoreData

public class DefaultCDStack: SugarRecordStackProtocol
{
    public var name: String = "DefaultcdStack"
    public var stackDescription: String = "Default core data stack with an efficient context management"
    public var databasePath: NSURL?
    public let defaultStoreName: String = "sugar.sqlite"
    
    //MARK - Initializers
    
    
    required convenience public init(databaseName: String)
    {
        self.init(databaseURL: databasePathURLFromName(databaseName))
    }
    
    required convenience public init(databasePath: String)
    {
        self.init(databaseURL: NSURL(fileURLWithPath: databasePath))
    }
    
    required convenience public init(databaseURL: NSURL)
    {
        self.init(databaseURL: databaseURL, model: nil)
    }
    
    required convenience public init(databaseName: String, model: NSManagedObjectModel)
    {
        self.init(databasePath: databasePathURLFromName(databaseName), model: model)
    }
    
    required convenience public init(databasePath: String, model: NSManagedObjectModel)
    {
        
    }
    
    required convenience public init(databaseURL: String, model: NSManagedObjectModel?)
    {
        
    }
    
    
    public func initialize()
    {
        // Nothing to do here
    }
    
    public func cleanup()
    {
        // Nothing to do here
    }
    
    public func toBackground()
    {
        // Nothing to do here
    }
    
    public func toForeground()
    {
        // Nothing to do here
    }
    
    public func backgroundContext() -> SugarRecordContext
    {
        return SugarRecordRLMContext(realmContext: RLMRealm.defaultRealm())
    }
    
    public func mainThreadContext() -> SugarRecordContext
    {
        return SugarRecordRLMContext(realmContext: RLMRealm.defaultRealm())
    }
    
    public func removeDatabase()
    {
        let documentsPath: String = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let databaseName: String = documentsPath.stringByAppendingPathComponent("default.realm")
        var error: NSError?
        NSFileManager.defaultManager().removeItemAtPath(databaseName, error: &error)
        SugarRecord.handle(error)
    }
    
    
    //MARK - Helper
    
    public func databasePathURLFromName(name: String) -> NSURL
    {
        let documentsPath: String = NSSearchPathForDirectoriesInDomains(.ApplicationSupportDirectory, .UserDomainMask, true)[0] as String
        let mainBundleInfo: [NSObject: AnyObject] = NSBundle.mainBundle().infoDictionary
        let applicationName: String = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleDisplayName") as String
        let applicationPath: String = documentsPath.stringByAppendingPathComponent(applicationName)
        
        let paths: [String] = [documentsPath, applicationPath]
        for path in paths {
            let databasePath: String = path.stringByAppendingPathComponent(name)
            if NSFileManager.defaultManager().fileExistsAtPath(databasePath) {
                return NSURL(fileURLWithPath: databasePath)
            }
        }
        
        let databasePath: String = applicationPath.stringByAppendingPathComponent(name)
        return NSURL(fileURLWithPath: databasePath)
    }
}