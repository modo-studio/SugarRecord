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
    
    /**
     Find objects in database

     :param: fetchedObjects Enum value with the items that have to be fetched
     :param: context        Context where the fetchRequest is going to be executed
     :param: filter         NSPredicate with the filter of results
     :param: sortedBy       Array with sort descriptors

     :returns: [NSManagedObject] with the objects found
     */
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
    
    /**
     Find objects in database

     :param: fetchedObjects Enum value with the items that have to be fetched
     :param: context        Context where the fetchRequest is going to be executed
     :param: filter         NSPredicate with the filter of results
     :param: sortedBy       String with the sortering key
     :param: ascending      Bool if the sortering is ascending

     :returns: [NSManagedObject] with the objects found
     */
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
    
    /**
     Find objects in database

     :param: fetchedObjects Enum value with the items that have to be fetched
     :param: context        Context where the fetchRequest is going to be executed
     :param: attribute      String with the filtering attribute
     :param: value          String with the filtering attribute value
     :param: sortedBy       Array with sort descriptors

     :returns: [NSManagedObject] with the objects found
     */
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

    /**
     Find objects in database

     :param: fetchedObjects Enum value with the items that have to be fetched
     :param: context        Context where the fetchRequest is going to be executed
     :param: attribute      String with the filtering attribute
     :param: value          String with the filtering attribute value
     :param: sortedBy       String with the sortering key
     :param: ascending      Bool if the sortering is ascending

     :returns: [NSManagedObject] with the objects found
     */
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

    /**
     Find an object and create if it doesn't exist

     :param: context        Context where the fetchRequest is going to be executed
     :param: attribute      String with the filtering attribute
     :param: value          String with the filtering attribute value

     :returns: NSManagedObject with the objects found or created
     */
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