//
//  NSManagedObject+Counters.swift
//  SugarRecord
//
//  Created by Pedro Piñera Buendía on 26/08/14.
//  Copyright (c) 2014 PPinera. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObject {
    /**
     Returns the count of items filtered using a passed context

     :param: context NSManagedObjectContext where the fetch request is going to be executed
     :param: filter NSPredicate with the filter

     :returns: Int with the count
     */
    class func count(var inContext context: NSManagedObjectContext?, filteredBy filter:NSPredicate?) -> (Int) {
        var error: NSError?
        if context == nil {
            context = NSManagedObjectContext.defaultContext()
        }
        let count: Int = context!.countForFetchRequest(request(inContext: context), error: &error)
        SugarRecord.handle(error)
        return count
    }
    
    /**
     Returns the count of items (using the default context)

     :returns: Int with the count
     */
    class func count() -> (Int) {
        return count(inContext: nil, filteredBy: nil)
    }
    
    /**
     Returns the count of items using a passed context

     :param: context NSManagedObjectContext where the fetch request is going to be executed

     :returns: Int with the count
     */
    class func count(inContext context: NSManagedObjectContext) -> (Int) {
        return count(inContext: context, filteredBy: nil)
    }
    
    /**
     Returns the count of items filtered

     :param: filter NSPredicate with the filter

     :returns: Int with the count
     */
    class func count(filteredBy filter: NSPredicate) -> (Int) {
        return count(inContext: nil, filteredBy: filter)
    }
    
    /**
     Returns if there is any object (using Default Context)

     :returns: Bool indicating if there is any object
     */
    class func any() -> (Bool) {
        return any(inContext: nil, filteredBy: nil)
    }
    
    /**
     Returns if there is any object using a given context

     :param: context NSManagedObjectContext where the fetch is going to be executed

     :returns: Bool indicating if there is any object
     */
    class func any(inContext context: NSManagedObjectContext) -> (Bool) {
        return any(inContext: context, filteredBy: nil)
    }
    
    /**
     Returns if there is any item using the passed context using the input filter

     :param: context NSManagedObjectContext where the fetch is going to be executed
     :param: filter  NSPredicate with the filter of the objects

     :returns: Bool indicating if there is any object
     */
    class func any(inContext context: NSManagedObjectContext?, filteredBy filter: NSPredicate?) -> (Bool) {
        return count(inContext: context, filteredBy: filter) == 0
    }
}