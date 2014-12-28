//
//  SugarRecordResults.swift
//  project
//
//  Created by Pedro Piñera Buendía on 25/12/14.
//  Copyright (c) 2014 SugarRecord. All rights reserved.
//

import Foundation
import CoreData
import Realm

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

public class SugarRecordResults: SequenceType
{
    
    //MARK: - Attributes
    
    var results: SugarRecordResultsProtocol
    private var finder: SugarRecordFinder
    
    
    //MARK: - Constructors
    
    /**
    Initializes SRResults passing an object that conforms the protocol SRResultsProtocol
    
    :param: results Original results
    
    :returns: Initialized SRResults
    */
    internal init(results: SugarRecordResultsProtocol, finder: SugarRecordFinder) {
        self.results = results
        self.finder = finder
    }
    
    
    //MARK: - Public methods
    
    /// Returns the number of elements
    public var count:Int {
        get {
            return results.count(finder: finder)
        }
    }
    
    func objectAtIndex(index: UInt) -> AnyObject!
    {
        return results.objectAtIndex(index, finder: finder)
    }
    
    func firstObject() -> AnyObject!
    {
        return results.firstObject(finder: finder)
    }
    
    func lastObject() -> AnyObject!
    {
        return results.lastObject(finder: finder)
    }

    /**
    *  Access to the element at a given index
    */
    subscript (index: Int) -> AnyObject! {
        get {
            return results.objectAtIndex(UInt(index), finder: finder)
        }
    }
    
    
    //MARK: SequenceType Protocol
    
    public func generate() -> SRResultsGenerator
    {
        return SRResultsGenerator(results: self)
    }
}


//MARK: Generator

public class SRResultsGenerator: GeneratorType {
    private var results: SugarRecordResults
    private var nextIndex: Int
    
    init(results: SugarRecordResults) {
        self.results = results
        nextIndex = 0
    }
    
    public func next() -> AnyObject? {
        if (nextIndex < 0) {
            return nil
        }
        return self.results[nextIndex--]
    }
}