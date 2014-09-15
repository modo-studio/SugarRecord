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
        return objectClass.createInRealm(self.realmContext, withObject: nil)
    }
    
    public func find(finder: SugarRecordFinder) -> [AnyObject]?
    {
        let objectClass: RLMObject.Type = finder.objectClass as RLMObject.Type
        var filteredObjects: RLMArray? = nil
        if finder.predicate != nil {
            filteredObjects = objectClass.objectsWithPredicate(finder.predicate)
        }
        else {
            filteredObjects = objectClass.allObjectsInRealm(self.realmContext)
        }
        var sortedObjects: RLMArray = filteredObjects!
        for sorter in finder.sortDescriptors {
            sortedObjects = sortedObjects.arraySortedByProperty(sorter.key, ascending: sorter.ascending)
        }
        
        //TODO - Convert RLMArray to List ( is it possible )
        //TODO - Check elements to know what we have to return
        
        return nil
    }
    
    public func deleteObject(object: AnyObject) -> Bool
    {
        // TODO - Pending
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