//
//  SugarRecordCDContext.swift
//  SugarRecord
//
//  Created by Pedro Piñera Buendía on 11/09/14.
//  Copyright (c) 2014 SugarRecord. All rights reserved.
//

import Foundation
import CoreData

public class SugarRecordCDContext: SugarRecordContext
{
    /// NSManagedObjectContext context
    let contextCD: NSManagedObjectContext
    
    /**
    SugarRecordCDContext initializer passing the CoreData context
    
    :param: context NSManagedObjectContext linked to this SugarRecord context
    
    :returns: Initialized SugarRecordCDContext
    */
    init (context: NSManagedObjectContext)
    {
        self.contextCD = context
    }
    
    /**
    Notifies the context that you're going to start an edition/removal/saving operation
    */
    public func beginWritting()
    {
       // CD begin writting does nothing
    }
    
    /**
    Notifies the context that you've finished an edition/removal/saving operation
    */
    public func endWritting()
    {
        var error: NSError?
        self.contextCD.save(&error)
        SugarRecord.handle(error)
        if error != nil {
            SugarRecordLogger.logLevelInfo.log("Context saved properly")
        }
    }
    
    /**
    Creates and object in the context (without saving)
    
    :param: objectClass Class of the created object
    
    :returns: The created object in the context
    */
    public func createObject(objectClass: AnyClass) -> AnyObject?
    {
        let managedObjectClass: NSManagedObject.Type = objectClass as NSManagedObject.Type
        var object: NSManagedObject = NSEntityDescription.insertNewObjectForEntityForName("", inManagedObjectContext: self.contextCD) as NSManagedObject
        return object
    }
    
    /**
    Insert an object in the context
    
    :param: object NSManagedObject to be inserted in the context
    */
    public func insertObject(object: AnyObject)
    {
        moveObject(object as NSManagedObject, inContext: self.contextCD)
    }
    
    /**
    Find NSManagedObject objects in the database using the passed finder
    
    :param: finder SugarRecordFinder usded for querying (filtering/sorting)
    
    :returns: Objects fetched
    */
    public func find(finder: SugarRecordFinder) -> [AnyObject]?
    {
        let objectClass: NSObject.Type = finder.objectClass!
        let managedObjectClass: NSManagedObject.Type = objectClass as NSManagedObject.Type
        let fetchRequest: NSFetchRequest = NSFetchRequest()
        fetchRequest.sortDescriptors = finder.sortDescriptors
        fetchRequest.predicate = finder.predicate
        var error: NSError?
        var objects: [AnyObject]? = self.contextCD.executeFetchRequest(fetchRequest, error: &error)
        
        if objects == nil {
            return objects
        }
        
        var finalArray: [AnyObject] = [AnyObject]()
        switch finder.elements {
        case .first:
            let object: AnyObject? = objects!.first
            if object != nil {
                finalArray.append(object!)
            }
        case .last:
            let object: AnyObject? = objects!.last
            if object != nil {
                finalArray.append(object!)
            }
        case .firsts(let number):
            var last: Int = number
            if number > objects!.count {
                last = objects!.count
            }
            for index in 0..<last {
                finalArray.append(objects![index])
            }
        case .lasts(let number):
            objects = objects!.reverse()
            var last: Int = number
            if number > objects!.count {
                last = objects!.count
            }
            for index in 0..<last {
                finalArray.append(objects![index])
            }
        case .all:
            finalArray = objects!
        }
        SugarRecordLogger.logLevelInfo.log("Found \(finalArray.count) objects in database")
        return finalArray
    }
    
    /**
    Deletes a given object
    
    :param: object NSManagedObject to be deleted
    
    :returns: If the object has been properly deleted
    */
    public func deleteObject(object: AnyObject) -> Bool
    {
        let managedObject: NSManagedObject? = object as? NSManagedObject
        let objectInContext: NSManagedObject? = moveObject(managedObject!, inContext: contextCD)
        if objectInContext == nil  {
            let error: NSError = NSError(domain: "Imposible to remove object", code: SugarRecordErrorCodes.UserError.toRaw(), userInfo: nil)
            SugarRecord.handle(error)
            return false
        }
        SugarRecordLogger.logLevelInfo.log("Object removed from database")
        self.contextCD.deleteObject(managedObject!)
        return true
    }
    
    /**
    Deletes NSManagedObject objecs from an array
    
    :param: objects NSManagedObject objects to be dleeted
    
    :returns: If the deletion has been successful
    */
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
    
    
    //MARK - HELPER METHODS
    
    /**
    Moves an NSManagedObject from one context to another
    
    :param: object  NSManagedObject to be moved
    :param: context NSManagedObjectContext where the object is going to be moved to
    
    :returns: NSManagedObject in the new context
    */
    func moveObject(object: NSManagedObject, inContext context: NSManagedObjectContext) -> NSManagedObject?
    {
        var error: NSError?
        let objectInContext: NSManagedObject? = context.existingObjectWithID(object.objectID, error: &error)?
        if error != nil {
            let error: NSError = NSError(domain: "", code: SugarRecordErrorCodes.UserError.toRaw(), userInfo: nil)
            SugarRecord.handle(error)
            return nil
        }
        else {
            return objectInContext
        }
    }
}