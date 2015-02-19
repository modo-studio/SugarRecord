//
//  SugarRecordFinder+FetchedResultsController.swift
//  SugarRecord
//
//  Created by Pedro Piñera Buendía on 06/10/14.
//  Copyright (c) 2014 SugarRecord. All rights reserved.
//

import Foundation
import CoreData

// MARK: Fetched Results Controller

extension SugarRecordFinder
{
    /**
    Returns a NSFetchedResultsController with the Finder criteria
    
    :param: section Section sorting key name
    
    :returns: Created NSFetchedResultsController
    */
    public func fetchedResultsController(section: String?) -> NSFetchedResultsController
    {
        return fetchedResultsController(section, cacheName: nil)
    }
    
    /**
    Returns a NSFetchedResultsController with the Finder criteria passing the cache name too
    
    :param: section   Section sortking key name
    :param: cacheName Cache name
    
    :returns: Created NSFetchedResultsController
    */
    public func fetchedResultsController(section: String?, cacheName: String?) -> NSFetchedResultsController
    {
        let fetchRequest: NSFetchRequest = SugarRecordCDContext.fetchRequest(fromFinder: self)
        var coredataContext: SugarRecordCDContext?
        SugarRecord.operation(SugarRecordEngine.SugarRecordEngineCoreData, closure: {(context) -> () in
            coredataContext = context as? SugarRecordCDContext
        })
        var fetchedResultsController: NSFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext:coredataContext!.contextCD , sectionNameKeyPath: section, cacheName: cacheName)
        return fetchedResultsController
    }
}