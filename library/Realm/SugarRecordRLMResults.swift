//
//  SugarRecordRLMResults.swift
//  project
//
//  Created by Pedro Piñera Buendía on 11/12/14.
//  Copyright (c) 2014 SugarRecord. All rights reserved.
//

import Foundation
import Realm

class SugarRecordRLMResults: SugarRecordResultsProtocol
{
    //MARK: - Attributes
    typealias T = RLMObject
    typealias R = SugarRecordRLMResults
    private var realmResults: RLMResults
    
    //MARK: - Constructors
    
    init(realmResults: RLMResults)
    {
        self.realmResults = realmResults
    }
    
    //MARK: - SugarRecordResultsProtocol
    
    var count:UInt {
        get {
            return realmResults.count
        }
    }
    
    func objectAtIndex(index: UInt) -> T!
    {
        return realmResults.objectAtIndex(index) as T
    }
    
    func firstObject() -> T!
    {
        return realmResults.firstObject() as T
    }
    
    func lastObject() -> T!
    {
        return realmResults.lastObject() as T
    }
    
    func indexOfObject(object: T) -> UInt
    {
        return realmResults.indexOfObject(object)
    }
    
    func indexOfObjectWithPredicate(predicate: NSPredicate!) -> UInt
    {
        return realmResults.indexOfObjectWithPredicate(predicate)
    }
    
    func objectsWithPredicate(predicate: NSPredicate!) -> R!
    {
        return SugarRecordRLMResults(realmResults: realmResults.objectsWithPredicate(predicate))
    }
    
    func sortedResultsUsingProperty(property: String!, ascending: Bool) -> R!
    {
        return SugarRecordRLMResults(realmResults: realmResults.sortedResultsUsingProperty(property, ascending: ascending))
    }
    
    func sortedResultsUsingDescriptors(properties: [AnyObject]!) -> R!
    {
        return SugarRecordRLMResults(realmResults: realmResults.sortedResultsUsingDescriptors(properties))
    }
    
    subscript (index: UInt) -> T! {
        get {
            return realmResults[index] as T
        }
    }
}