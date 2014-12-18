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
    private var finder: SugarRecordFinder
    
    //MARK: - Constructors
    
    init(realmResults: RLMResults, finder: SugarRecordFinder)
    {
        self.realmResults = realmResults
        self.finder = finder
    }
    
    //MARK: - SugarRecordResultsProtocol
    
    var count: Int {
        let (firstIndex, lastIndex) = indexes()
        if (lastIndex == 0 && firstIndex == 0) { return Int(realmResults.count) }
        return lastIndex - firstIndex + 1
    }
    
    func objectAtIndex(index: UInt) -> AnyObject!
    {
        let (firstIndex, lastIndex) = indexes()
        return realmResults.objectAtIndex(firstIndex + index)
    }
    
    func firstObject() -> AnyObject!
    {
        let (firstIndex, lastIndex) = indexes()
        return realmResults.objectAtIndex(UInt(firstIndex))
    }
    
    func lastObject() -> AnyObject!
    {
        let (firstIndex, lastIndex) = indexes()
        return realmResults.objectAtIndex(UInt(lastIndex))
    }
    
    func indexOfObject(object: AnyObject) -> Int
    {
        let (firstIndex, lastIndex) = indexes()
        return Int(realmResults.indexOfObject(object as RLMObject)) - firstIndex
    }
    
    func indexOfObjectWithPredicate(predicate: NSPredicate!) -> Int
    {
        let (firstIndex, lastIndex) = indexes()
        return Int(realmResults.indexOfObjectWithPredicate(predicate)) - firstIndex
    }
    
    func objectsWithPredicate(predicate: NSPredicate!) -> SugarRecordResultsProtocol!
    {
        return SugarRecordRLMResults(realmResults: realmResults.objectsWithPredicate(predicate), finder: SugarRecordFinder())
    }
    
    func sortedResultsUsingProperty(property: String!, ascending: Bool) -> SugarRecordResultsProtocol!
    {
        return SugarRecordRLMResults(realmResults: realmResults.sortedResultsUsingProperty(property, ascending: ascending), finder: SugarRecordFinder())
    }
    
    func sortedResultsUsingDescriptors(properties: [AnyObject]!) -> SugarRecordResultsProtocol!
    {
        return SugarRecordRLMResults(realmResults: realmResults.sortedResultsUsingDescriptors(properties), finder: SugarRecordFinder())
    }
    
    subscript (index: Int) -> AnyObject! {
        get {
            let (firstIndex, lastIndex) = indexes()
            return realmResults[UInt(index+firstIndex)]
        }
    }
    
    
    //MARK: - Helpers
    
    func indexes() -> (Int, Int)
    {
        var firstIndex: Int = 0
        var lastIndex: Int = Int(realmResults.count) - 1
        
        switch(finder.elements) {
        case .first:
            firstIndex = 0
            lastIndex = 0
        case .last:
            lastIndex = Int(realmResults.count) - 1
            firstIndex = Int(realmResults.count) - 1
        case .firsts(let number):
            firstIndex = 0
            lastIndex = firstIndex + number - 1
            if (lastIndex > Int(realmResults.count) - 1) { lastIndex = Int(realmResults.count) - 1 }
        case .lasts(let number):
            lastIndex = Int(realmResults.count) - 1
            firstIndex = firstIndex - (number - 1)
            if (firstIndex < 0) { firstIndex = 0 }
        default:
            break
        }
        return (firstIndex, lastIndex)
    }
}