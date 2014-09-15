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
        let objectClass: RLMObject.Type = objectClass as RLMObject.Type
        return objectClass()
    }
    
    public func find(finder: SugarRecordFinder) -> [AnyObject]?
    {
        //TODO - Pending to translate the finder into a fetch to the context
        return nil
    }
    
    public func deleteObject(object: AnyObject) -> Bool
    {
        //TODO - Pending to set here how to delete a given object
        return true
    }
    
    public func deleteObjects(objects: [AnyObject]) -> Bool
    {
        var objectsDeleted: Int = 0
        for object in objects {
            let objectDeleted: Bool = deleteObject(object)
            if objectDeleted {
                objectsDeleted++
            }
        }
        SugarRecordLogger.logLevelInfo.log("Deleted \(objectsDeleted) of \(objects.count)")
        return objectsDeleted == objects.count
    }
}