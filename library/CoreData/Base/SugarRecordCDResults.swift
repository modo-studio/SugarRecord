//
//  SugarRecordCDResults.swift
//  project
//
//  Created by Pedro Piñera Buendía on 11/12/14.
//  Copyright (c) 2014 SugarRecord. All rights reserved.
//

import Foundation
import CoreData

class SugarRecordCDResults: SugarRecordResultsProtocol
{
    //MARK: - Attributes
    typealias T = NSManagedObject
    typealias R = SugarRecordCDResults
    private var results: [T]
    
    //MARK: - Constructors
    
    init(results: [NSManagedObject])
    {
        self.results = results
    }
    
    //MARK: - SugarRecordResultsProtocol
    
    var count:UInt {
        get {
            return UInt(results.count)
        }
    }
    
    func objectAtIndex(index: UInt) -> T!
    {
        return results[Int(index)] as T
    }
    
    func firstObject() -> T!
    {
        return results.first! as T
    }
    
    func lastObject() -> T!
    {
        return results.last! as T
    }
    
    func indexOfObject(object: T) -> UInt
    {
        if let i = find(results, object) {
            return UInt(i)
        }
        else {
            return UInt(NSNotFound)
        }
    }
    
    func indexOfObjectWithPredicate(predicate: NSPredicate!) -> UInt
    {
        var filteredArray: R! = objectsWithPredicate(predicate)
        var first: T! = filteredArray.firstObject()
        if first != nil {
            return indexOfObject(first)
        }
        else {
            return UInt(NSNotFound)
        }
    }
    
    func objectsWithPredicate(predicate: NSPredicate!) -> R!
    {
        var array: NSArray = NSArray(array: results)
        return SugarRecordCDResults(results: (array.filteredArrayUsingPredicate(predicate) as [T]))
    }
    
    func sortedResultsUsingProperty(property: String!, ascending: Bool) -> R!
    {
        var array: NSArray = NSArray(array: results)
        return SugarRecordCDResults(results: (array.sortedArrayUsingDescriptors([NSSortDescriptor(key: property, ascending: ascending)]) as [T]))
    }
    
    func sortedResultsUsingDescriptors(properties: [AnyObject]!) -> R!
    {
        var array: NSArray = NSArray(array: results)
        return SugarRecordCDResults(results: (array.sortedArrayUsingDescriptors(properties) as [T]))
    }
    
    subscript (index: UInt) -> T! {
        get {
            return results[Int(index)] as T
        }
    }
}
