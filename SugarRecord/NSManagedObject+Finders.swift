//
//  NSManagedObject+Finders.swift
//  SugarRecord
//
//  Created by Pedro Piñera Buendía on 26/08/14.
//  Copyright (c) 2014 PPinera. All rights reserved.
//

import Foundation

extension NSManagedObject {
    enum FetchedObjects {
        case first, last, all
        case firsts(Int)
        case lasts(Int)
    }
    

    ////// FINDERS //////
    class func find(fetchedObjects: FetchedObjects, var inContext context: NSManagedObjectContext?, filteredBy filter: NSPredicate?, var sortedBy sortDescriptors: [NSSortDescriptor]?) -> ([NSManagedObject]) {
        let fetchRequest: NSFetchRequest = request(fetchedObjects, inContext: context, filteredBy: filter, sortedBy: sortDescriptors)
        if context == nil && NSManagedObjectContext.defaultContext() != nil {
            context = NSManagedObjectContext.defaultContext()!
        }
        else {
            assert(true, "Context should be passed or default should be set")
        }
        return self.executeFetchRequest(fetchRequest, inContext: context!)
    }
    
    class func find(fetchedObjects: FetchedObjects, var inContext context: NSManagedObjectContext?, filteredBy filter: NSPredicate?, sortedBy: String, ascending: Bool) -> ([NSManagedObject]) {
        let fetchRequest: NSFetchRequest = request(fetchedObjects, inContext: context, filteredBy: filter, sortedBy: sortedBy, ascending: ascending)
        if context == nil && NSManagedObjectContext.defaultContext() != nil {
            context = NSManagedObjectContext.defaultContext()!
        }
        else {
            assert(true, "Context should be passed or default should be set")
        }
        return self.executeFetchRequest(fetchRequest, inContext: context!)
    }
    
    class func find(fetchedObjects: FetchedObjects, var inContext context: NSManagedObjectContext?, attribute: String, value: String, var sortedBy sortDescriptors: [NSSortDescriptor]?) -> ([NSManagedObject]) {
        let fetchRequest: NSFetchRequest = request(fetchedObjects, inContext: context, withAttribute: attribute, andValue: value, sortedBy: sortDescriptors)
        if context == nil && NSManagedObjectContext.defaultContext() != nil {
            context = NSManagedObjectContext.defaultContext()!
        }
        else {
            assert(true, "Context should be passed or default should be set")
        }
        return self.executeFetchRequest(fetchRequest, inContext: context!)
    }
    
    class func find(fetchedObjects: FetchedObjects, var inContext context: NSManagedObjectContext?, attribute: String, value: String, sortedBy: String, ascending: Bool) -> ([NSManagedObject]) {
        let fetchRequest: NSFetchRequest = request(fetchedObjects, inContext: context, withAttribute: attribute, andValue: value, sortedBy: sortedBy, ascending: ascending)
        if context == nil && NSManagedObjectContext.defaultContext() != nil {
            context = NSManagedObjectContext.defaultContext()!
        }
        else {
            assert(true, "Context should be passed or default should be set")
        }
        return self.executeFetchRequest(fetchRequest, inContext: context!)
    }
    
    class func findAndCreate(var inContext context: NSManagedObjectContext?, withAttribute attribute: String, andValue value:String) -> (NSManagedObject) {
        let fetchRequest: NSFetchRequest = request(.first, inContext: context, withAttribute: attribute, andValue: value, sortedBy: nil)
        if context == nil && NSManagedObjectContext.defaultContext() != nil {
            context = NSManagedObjectContext.defaultContext()!
        }
        else {
            assert(true, "Context should be passed or default should be set")
        }
        let objects:[NSManagedObject] = self.executeFetchRequest(fetchRequest, inContext: context!)
        // Returning if object exists
        if objects.count != 0 {
            return objects[0]
        }
        
        var object: NSManagedObject?
        object = self.create(inContext: context!)
        object?.setValue(value, forKey: attribute)
        return object!
    }
}