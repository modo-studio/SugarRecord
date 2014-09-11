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
    let contextCD: NSManagedObjectContext
    
    init (context: NSManagedObjectContext)
    {
        self.contextCD = context
    }
    
    public func beginWritting()
    {
       // CD begin writting does nothing
    }
    
    public func endWritting()
    {
        var error: NSError?
        self.contextCD.save(&error)
        SugarRecord.handle(error)
    }
    
    public func insertObject(objectClass: NSObject.Type) -> AnyObject?
    {
        if (objectClass.isSubclassOfClass(NSManagedObject.Type)) {
            SugarRecordLogger.logLevelError.log("Trying to insert object in context of invalid type (\(objectClass)) but has to be (NSManagedObject))")
            return nil
        }
        let managedObjectClass: NSManagedObject.Type = objectClass as NSManagedObject.Type
        var object: NSManagedObject = NSEntityDescription.insertNewObjectForEntityForName("", inManagedObjectContext: self.contextCD) as NSManagedObject
        return object
    }
    
    public func find(finder: SugarRecordFinder) -> [AnyObject]?
    {
        //TODO - Pending to translate the finder into a fetch to the context
        return nil
    }
}