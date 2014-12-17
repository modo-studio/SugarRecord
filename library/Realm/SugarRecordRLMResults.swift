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
    
    func objectAtIndex(index: UInt) -> AnyObject!
    {
        return realmResults.objectAtIndex(index) as RLMObject
    }
    
    func firstObject() -> AnyObject!
    {
        return realmResults.firstObject() as RLMObject
    }
    
    func lastObject() -> AnyObject!
    {
        return realmResults.lastObject() as RLMObject
    }
    
    func indexOfObject(object: AnyObject) -> UInt
    {
        return realmResults.indexOfObject(object as RLMObject)
    }
    
    func indexOfObjectWithPredicate(predicate: NSPredicate!) -> UInt
    {
        return realmResults.indexOfObjectWithPredicate(predicate)
    }
    
    func objectsWithPredicate(predicate: NSPredicate!) -> SugarRecordResultsProtocol!
    {
        return SugarRecordRLMResults(realmResults: realmResults.objectsWithPredicate(predicate))
    }
    
    func sortedResultsUsingProperty(property: String!, ascending: Bool) -> SugarRecordResultsProtocol!
    {
        return SugarRecordRLMResults(realmResults: realmResults.sortedResultsUsingProperty(property, ascending: ascending))
    }
    
    func sortedResultsUsingDescriptors(properties: [AnyObject]!) -> SugarRecordResultsProtocol!
    {
        return SugarRecordRLMResults(realmResults: realmResults.sortedResultsUsingDescriptors(properties))
    }
    
    subscript (index: UInt) -> AnyObject! {
        get {
            return realmResults[index]
        }
    }
}