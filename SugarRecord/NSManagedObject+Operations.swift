//
//  NSManagedObject+Operations.swift
//  SugarRecord
//
//  Created by Pedro Piñera Buendía on 26/08/14.
//  Copyright (c) 2014 PPinera. All rights reserved.
//

import Foundation

extension NSManagedObject {
    class func executeFetchRequest(fetchRequest: NSFetchRequest, var inContext context: NSManagedObjectContext?) -> ([NSManagedObject]) {
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
    
    class func create(inContext context: NSManagedObjectContext) -> (NSManagedObject?) {
        var entity: NSEntityDescription?
        entity = self.entityDescriptionInContext(context)
        if entity == nil {
            return nil
        }
        return NSManagedObject(entity: entity!, insertIntoManagedObjectContext: context)
    }
    
    func delete(var inContext context: NSManagedObjectContext?) -> (Bool) {
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
    
    class func deleteAll(predicate: NSPredicate?, inContext context: NSManagedObjectContext?) -> (Bool) {
        var request: NSFetchRequest = self.request(.all, inContext: context, filteredBy: predicate, sortedBy: nil)
        request.returnsObjectsAsFaults = true
        request.includesPendingChanges = false
        var objects: [NSManagedObject] = self.executeFetchRequest(request, inContext: context)
        for object in objects {
            object.delete(inContext: context)
        }
        return true
    }
    
    func to(context: NSManagedObjectContext) -> (NSManagedObject?) {
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