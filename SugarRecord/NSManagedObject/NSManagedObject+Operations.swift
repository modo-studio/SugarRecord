//
//  NSManagedObject+Operations.swift
//  SugarRecord
//
//  Created by Pedro Piñera Buendía on 26/08/14.
//  Copyright (c) 2014 PPinera. All rights reserved.
//

import Foundation

extension NSManagedObject {
    /**
     Execute a fetchRequest in the given context

     :param: NSFetchRequest to be executed
     :param: context NSManagedObjectContext where the FetchRequest is going to be executed

     :returns: [NSManagedObject] with round objects
     */
    class func executeFetchRequest(fetchRequest: NSFetchRequest, var inContext context: NSManagedObjectContext?) -> [NSManagedObject] {
        var objects: [NSManagedObject] = [NSManagedObject]()
        if context == nil && NSManagedObjectContext.defaultContext() != nil {
            context = NSManagedObjectContext.defaultContext()!
        }
        else {
            assert(true, "Context should be passed or default should be set")
        }
        context!.performBlockAndWait { () -> Void in
            var error: NSError? = nil
            objects = context!.executeFetchRequest(fetchRequest, error: &error) as [NSManagedObject]
            if error != nil {
                SugarRecord.handle(error!)
            }
        }
        return objects
    }

    /**
     Create a new object in the given context

     :param: context NSManagedObjectContext where the object is going to be created

     :returns: NSManagedObject created
     */
    public class func create(inContext context: NSManagedObjectContext) -> NSManagedObject? {
        var entity: NSEntityDescription?
        entity = self.entityDescription(inContext: context)
        if entity == nil {
            return nil
        }
        return NSManagedObject(entity: entity!, insertIntoManagedObjectContext: context)
    }
    
    /**
     Delete a given object in the passed context (It doesn't matter if it's in a different context)

     :param: context   NSManagedObjectContext where the object is going to be deleted

     :returns: Bool if the deleton was successful
     */
    func delete(var inContext context: NSManagedObjectContext?) -> Bool {
        if context == nil && NSManagedObjectContext.defaultContext() != nil {
            context = NSManagedObjectContext.defaultContext()!
        }
        else {
            assert(true, "Context should be passed or default should be set")
        }
        var error: NSError?
        var objectInContext: NSManagedObject = context!.existingObjectWithID(self.objectID, error: &error)
        SugarRecord.handle(error)
        return true
    }
    
    /**
     Delete all the filtered objects in the context

     :param: predicate NSPredicate with the filter
     :param: context   NSManagedObjectContext where the objects are going to be deleted

     :returns: Bool if the deleton was successful
     */
    class func deleteAll(predicate: NSPredicate?, inContext context: NSManagedObjectContext?) -> Bool {
        var request: NSFetchRequest = self.request(.all, inContext: context, filteredBy: predicate, sortedBy: nil)
        request.returnsObjectsAsFaults = true
        request.includesPendingChanges = false
        var objects: [NSManagedObject] = self.executeFetchRequest(request, inContext: context)
        for object in objects {
            object.delete(inContext: context)
        }
        return true
    }
    
    /**
     Move the object to another contenxt

     :param: context NSManagedObjectContext where the object is going to be moved to

     :returns: NSManagedObject in the new context
     */
    func to(context: NSManagedObjectContext) -> NSManagedObject? {
        var error: NSError?
        if self.objectID.temporaryID {
            let objects: [AnyObject]! = [self]
            let success: Bool = self.managedObjectContext.obtainPermanentIDsForObjects(objects, error: &error)
            if !success {
                SugarRecord.handle(error)
                return nil
            }
        }
        error = nil
        let objectInContext: NSManagedObject = context.existingObjectWithID(self.objectID, error: &error)
        SugarRecord.handle(error)
        return objectInContext
    }
}