//
//  DefaultREALMStack.swift
//  SugarRecord
//
//  Created by Pedro Piñera Buendía on 15/09/14.
//  Copyright (c) 2014 SugarRecord. All rights reserved.
//

import Foundation
import Realm

public class DefaultREALMStack: SugarRecordStackProtocol
{
    public var name: String
    public var stackDescription: String
    
    required public init(stackName:String, stackDescription: String) {
        self.name = stackName
        self.stackDescription = stackDescription
    }
    
    public func initialize()
    {
        // Nothing to do here
    }
    
    public func cleanup()
    {
        // Nothing to do here
    }
    
    public func applicationWillResignActive()
    {
        // Nothing to do here
    }
    
    public func applicationWillTerminate()
    {
        // Nothing to do here
    }
    
    public func applicationWillEnterForeground()
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
}