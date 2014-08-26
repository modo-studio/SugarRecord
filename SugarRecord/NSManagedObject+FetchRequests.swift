//
//  NSManagedObject+FetchRequests.swift
//  SugarRecord
//
//  Created by Pedro Piñera Buendía on 26/08/14.
//  Copyright (c) 2014 PPinera. All rights reserved.
//

import Foundation

extension NSManagedObject {
    

    class func request(var inContext context: NSManagedObjectContext?) -> (NSFetchRequest) {
        if context == nil {
            context = NSManagedObjectContext.defaultContext()
        }
        assert(context != nil, "SR-Assert: Fetch request can't be created without context. Ensure you've initialized Sugar Record")
        var request: NSFetchRequest = NSFetchRequest()
        request.entity = entityDescriptionInContext(context!)
        return request
    }
    
    class func request(fetchedObjects: FetchedObjects, inContext context: NSManagedObjectContext?, filteredBy filter: NSPredicate?, var sortedBy sortDescriptors: [NSSortDescriptor]?) -> (NSFetchRequest) {
        var fetchRequest: NSFetchRequest = self.request(inContext: context)
        
        // Order
        var revertOrder: Bool = false
        switch fetchedObjects {
        case let .first:
            fetchRequest.fetchBatchSize = 1
        case let .last:
            fetchRequest.fetchBatchSize = 1
            revertOrder = true
        case let .firsts(number):
            fetchRequest.fetchBatchSize = number
        case let .lasts(number):
            revertOrder = true
            fetchRequest.fetchBatchSize = number
        default:
            break
        }
        
        // Sort descriptors
        if revertOrder  && sortDescriptors != nil {
            var rootSortDescriptor: NSSortDescriptor = sortDescriptors![0]
            sortDescriptors![0] = NSSortDescriptor(key: rootSortDescriptor.key, ascending: !rootSortDescriptor.ascending)
        }
        fetchRequest.sortDescriptors = sortDescriptors
        
        // Predicate
        if filter != nil  {
            fetchRequest.predicate = filter
        }
        
        return fetchRequest
    }
    
    class func request(fetchedObjects: FetchedObjects, inContext context: NSManagedObjectContext?, filteredBy filter: NSPredicate?, sortedBy: String, ascending: Bool) -> (NSFetchRequest) {
        return request(fetchedObjects, inContext: context, filteredBy: filter, sortedBy: [NSSortDescriptor(key: sortedBy, ascending: ascending)])
    }
    
    class func request(fetchedObjects: FetchedObjects, inContext context: NSManagedObjectContext?, withAttribute attribute: String, andValue value:String, var sortedBy sortDescriptors: [NSSortDescriptor]?) -> (NSFetchRequest) {
        let predicate: NSPredicate = NSPredicate(format: "\(attribute) = \(value)", argumentArray: nil)
        return request(fetchedObjects, inContext: context, filteredBy: predicate, sortedBy: sortDescriptors)
    }
    
    class func request(fetchedObjects: FetchedObjects, inContext context: NSManagedObjectContext?, withAttribute attribute: String, andValue value:String, sortedBy: String, ascending: Bool) -> (NSFetchRequest) {
        let predicate: NSPredicate = NSPredicate(format: "\(attribute) = \(value)", argumentArray: nil)
        return request(fetchedObjects, inContext: context, filteredBy: predicate, sortedBy: [NSSortDescriptor(key: sortedBy, ascending: ascending)])
    }
    
}