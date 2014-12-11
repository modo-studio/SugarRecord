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
    //[RLMRealm migrateDefaultRealmWithBlock:^NSUInteger(RLMMigration *migration, NSUInteger oldSchemaVersion) {
    
    /// RLMRealm context
    let realmContext: RLMRealm
    
    /**
    SugarRecordRLMContext initializer passing a RLMRealm object
    
    :param: realmContext RLMRealm context linked to this SugarRecord context
    
    :returns: Initialized SugarRecordRLMContext
    */
    init (realmContext: RLMRealm)
    {
        self.realmContext = realmContext
    }
    
    /**
    Notifies the context that you're going to start an edition/removal/saving operation
    */
    public func beginWriting()
    {
        self.realmContext.beginWriteTransaction()
    }
    
    /**
    Notifies the context that you've finished an edition/removal/saving operation
    */
    public func endWriting()
    {
        self.realmContext.commitWriteTransaction()
    }
    
    /**
    *  Asks the context for writing cancellation
    */
    public func cancelWriting()
    {
        self.realmContext.cancelWriteTransaction()
    }
    
    /**
    Creates an object in the context
    
    :param: objectClass ObectClass of the created object
    
    :returns: The created object in the context
    */
    public func createObject(objectClass: AnyClass) -> AnyObject?
    {
        let objectClass: RLMObject.Type = objectClass as RLMObject.Type
        return objectClass()
    }
    
    /**
    Insert an object in the context
    
    :param: object Realm object to be inserted
    */
    public func insertObject(object: AnyObject)
    {
        self.realmContext.addObject(object as RLMObject)
    }
    
    /**
    Find Realm objects in the database using the passed finder
    
    :param: finder SugarRecordFinder used for querying (filtering/sorting)
    
    :returns: Objects fetched
    */
    public func find(finder: SugarRecordFinder) -> [AnyObject]
    {
        let objectClass: RLMObject.Type = finder.objectClass as RLMObject.Type
        var filteredObjects: RLMResults? = nil
        if finder.predicate != nil {
            filteredObjects = objectClass.objectsWithPredicate(finder.predicate)
        }
        else {
            filteredObjects = objectClass.allObjectsInRealm(self.realmContext)
        }
        var sortedObjects: RLMResults = filteredObjects!
        for sorter in finder.sortDescriptors {
            sortedObjects = sortedObjects.sortedResultsUsingProperty(sorter.key, ascending: sorter.ascending)
        }
        
        var objectsArray: [RLMObject] = [RLMObject]()
        for index in 0..<sortedObjects.count {
            objectsArray.append(sortedObjects.objectAtIndex(index) as RLMObject)
        }
        
        var finalArray: [RLMObject] = [RLMObject]()
        switch finder.elements {
        case .first:
            let object: RLMObject? = objectsArray.first
            if object != nil {
                finalArray.append(object!)
            }
        case .last:
            let object: RLMObject? = objectsArray.last
            if object != nil {
                finalArray.append(object!)
            }
        case .firsts(let number):
            var last: Int = number
            if number > objectsArray.count {
                last = objectsArray.count
            }
            for index in 0..<last {
                finalArray.append(objectsArray[index])
            }
        case .lasts(let number):
            objectsArray = objectsArray.reverse()
            var last: Int = number
            if number > objectsArray.count {
                last = objectsArray.count
            }
            for index in 0..<last {
                finalArray.append(objectsArray[index])
            }
        case .all:
            finalArray = objectsArray
        }
        SugarRecordLogger.logLevelInfo.log("Found \(finalArray.count) objects in database")
        return finalArray
    }
    
    /**
    Deletes a given object
    
    :param: object Realm object to be deleted
    
    :returns: If the object has been properly deleted
    */
    public func deleteObject(object: AnyObject) -> SugarRecordContext
    {
        self.realmContext.deleteObject(object as RLMObject)
        return self
    }
    
    /**
    Deletes Realm objects from an array
    
    :param: objects Realm objects to be deleted
    
    :returns: If the delection has been successful
    */
    public func deleteObjects(objects: [AnyObject]) -> ()
    {
        var objectsDeleted: Int = 0
        for object in objects {
            let _ = deleteObject(object)
        }
        SugarRecordLogger.logLevelInfo.log("Deleted \(objects.count) objects")
    }
}