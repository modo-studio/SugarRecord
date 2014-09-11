//
//  SugarRecordRLMContext.swift
//  SugarRecord
//
//  Created by Pedro Piñera Buendía on 11/09/14.
//  Copyright (c) 2014 SugarRecord. All rights reserved.
//

import Foundation
import Realm

public class SugarRecordRLMContext: SugarRecordContext
{
    let realmContext: RLMRealm
    
    init (realmContext: RLMRealm)
    {
        self.realmContext = realmContext
    }
    
    public func beginWritting()
    {
        self.realmContext.beginWriteTransaction()
    }
    
    public func endWritting()
    {
        self.realmContext.commitWriteTransaction()
    }
    
    public func insertObject(objectClass: NSObject.Type) -> AnyObject?
    {
        if (objectClass.isSubclassOfClass(RLMObject.Type)) {
            SugarRecordLogger.logLevelError.log("Trying to insert object in context of invalid type (\(objectClass)) but has to be (RLMObject))")
            return nil
        }
        let managedObjectClass: RLMObject.Type = objectClass as RLMObject.Type
        return managedObjectClass()
    }
    
    public func find(finder: SugarRecordFinder) -> [AnyObject]?
    {
        //TODO - Pending to translate the finder into a fetch to the context
        return nil
    }
}