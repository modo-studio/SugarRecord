//
//  SugarRecordResultsProtocol.swift
//  project
//
//  Created by Pedro Piñera Buendía on 29/12/14.
//  Copyright (c) 2014 SugarRecord. All rights reserved.
//

import Foundation

internal protocol SugarRecordResultsProtocol
{
    /**
    Returns the count of elements in Results
    
    :param: finder Finder restrict the query results (lasts, first, firsts, ...) which is not possible directly on Realm
    
    :returns: Count of elements
    */
    func count(#finder: SugarRecordFinder) -> Int
    
    /**
    Returns the object at a given index
    
    :param: index  Index of the object
    :param: finder Finder restrict the query results (lasts, first, firsts, ...) which is not possible directly on Realm
    
    :returns: Object at that index (if exists)
    */
    func objectAtIndex(index: UInt, finder: SugarRecordFinder) -> AnyObject!
    
    /**
    Returns the first object of the results
    
    :param: finder Finder restrict the query results (lasts, first, firsts, ...) which is not possible directly on Realm
    
    :returns: First object (if exists)
    */
    func firstObject(#finder: SugarRecordFinder) -> AnyObject!
    
    /**
    Returns the last object of the results
    
    :param: finder Finder restrict the query results (lasts, first, firsts, ...) which is not possible directly on Realm
    
    :returns: Last object (if exists)
    */
    func lastObject(#finder: SugarRecordFinder) -> AnyObject!
}