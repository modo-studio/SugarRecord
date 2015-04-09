//
//  SugarRecordResults.swift
//  project
//
//  Created by Pedro Piñera Buendía on 25/12/14.
//  Copyright (c) 2014 SugarRecord. All rights reserved.
//

import Foundation

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
    internal init(results: SugarRecordResultsProtocol, finder: SugarRecordFinder)
    {
        self.results = results
        self.finder = finder
    }
    
    
    //MARK: - Public methods
    
    /// Returns the number of elements
    public var count:Int
    {
        get {
            return results.count(finder: finder)
        }
    }
    
    /**
    Returns the object at a given index
    
    :param: index Index of the object
    
    :returns: Object at the passed index (if exists)
    */
    public func objectAtIndex(index: UInt) -> AnyObject!
    {
        return results.objectAtIndex(index, finder: finder)
    }
    
    
    /**
    Returns the first object of the results
    
    :returns: First object (if exists)
    */
    public func firstObject() -> AnyObject!
    {
        return results.firstObject(finder: finder)
    }
    
    /**
    Returns the last object of the results
    
    :returns: Last object (if exists)
    */
    public func lastObject() -> AnyObject!
    {
        return results.lastObject(finder: finder)
    }

    /**
    *  Access to the element at a given index
    */
    public subscript (index: Int) -> AnyObject!
    {
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
    
    init(results: SugarRecordResults)
    {
        self.results = results
        nextIndex = results.count - 1
    }
    
    public func next() -> AnyObject?
    {
        if (nextIndex < 0) {
            return nil
        }
        return self.results[nextIndex--]
    }
}

//MARK: Convenience Methods Extension

extension SugarRecordResults {
    func filter<T>(predicate:(T) -> Bool) -> [T] {
        var result = [T]()
        for obj in self {
            if predicate(obj as! T) { result.append(obj as! T) }
        }
        return result
    }
    func map<T, U>(transform:(T) -> (U)) -> [U] {
        var result = [U]()
        for obj in self {
            result.append(transform(obj as! T))
        }
        return result
    }
}