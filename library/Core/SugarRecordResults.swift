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

public class SugarRecordResults<T>
{
    //MARK: - Attributes
    private var coredataResults: [NSManagedObject]?
    private var realmResults: RLMResults?
    private var finder: SugarRecordFinder<T>
    private var engine: SugarRecordEngine {
        if (coredataResults != nil) {
            return SugarRecordEngine.SugarRecordEngineCoreData
        }
        else {
            return SugarRecordEngine.SugarRecordEngineRealm
        }
    }

    //MARK: - Constructors
    
    init(coredataResults: [NSManagedObject], finder: SugarRecordFinder<T>)
    {
        self.coredataResults = coredataResults
        self.finder = finder
    }
    
    init(realmResults: RLMResults, finder: SugarRecordFinder<T>) {
        self.realmResults = realmResults
        self.finder = finder
    }
    
    //MARK: - SugarRecordResultsProtocol
    
    var count:Int {
        get {
            if (engine == SugarRecordEngine.SugarRecordEngineCoreData) {
                return coredataResults!.count
            }
            else {
                let (firstIndex, lastIndex) = indexes()
                if (lastIndex == 0 && firstIndex == 0) { return Int(realmResults!.count) }
                return lastIndex - firstIndex + 1
            }
        }
    }
    
    func objectAtIndex(index: UInt) -> T!
    {
        if (engine == SugarRecordEngine.SugarRecordEngineCoreData) {
            return coredataResults![Int(index)] as T
        }
        else {
            let (firstIndex, lastIndex) = indexes()
            return realmResults!.objectAtIndex(firstIndex + index) as T
        }
    }
    
    func firstObject() -> T!
    {
        if (engine == SugarRecordEngine.SugarRecordEngineCoreData) {
            return coredataResults!.first! as T
        }
        else {
            let (firstIndex, lastIndex) = indexes()
            return realmResults!.objectAtIndex(UInt(firstIndex)) as T
        }
    }
    
    func lastObject() -> T!
    {
        if (engine == SugarRecordEngine.SugarRecordEngineCoreData) {
            return coredataResults!.last! as T
        }
        else {
            let (firstIndex, lastIndex) = indexes()
            return realmResults!.objectAtIndex(UInt(lastIndex)) as T
        }
    }
    
    func indexOfObject(object: T) -> Int
    {
        if (engine == SugarRecordEngine.SugarRecordEngineCoreData) {
            if let i = find(coredataResults!, object as NSManagedObject) {
                return i
            }
            else {
                return NSNotFound
            }
        }
        else {
            let (firstIndex, lastIndex) = indexes()
            return Int(realmResults!.indexOfObject(object as RLMObject)) - firstIndex
        }
    }
    
    func indexOfObjectWithPredicate(predicate: NSPredicate!) -> Int
    {
        if (engine == SugarRecordEngine.SugarRecordEngineCoreData) {
            var filteredArray: SugarRecordResults<T>! = objectsWithPredicate(predicate)
            var first: T! = filteredArray.firstObject()
            if first != nil {
                return indexOfObject(first)
            }
            else {
                return NSNotFound
            }
        }
        else {
            let (firstIndex, lastIndex) = indexes()
            return Int(realmResults!.indexOfObjectWithPredicate(predicate)) - firstIndex
        }
    }
    
    func objectsWithPredicate(predicate: NSPredicate!) -> SugarRecordResults<T>!
    {
        if (engine == SugarRecordEngine.SugarRecordEngineCoreData) {
            var array: NSArray = NSArray(array: coredataResults!)
            return SugarRecordResults(coredataResults: array.filteredArrayUsingPredicate(predicate) as [NSManagedObject], finder: finder)
        }
        else {
            return SugarRecordResults(realmResults: realmResults!.objectsWithPredicate(predicate), finder: SugarRecordFinder<T>())

        }
    }
    
    func sortedResultsUsingProperty(property: String!, ascending: Bool) -> SugarRecordResults<T>!
    {
        if (engine == SugarRecordEngine.SugarRecordEngineCoreData) {
            var array: NSArray = NSArray(array: coredataResults!)
            return SugarRecordResults(coredataResults: (array.sortedArrayUsingDescriptors([NSSortDescriptor(key: property, ascending: ascending)]) as [NSManagedObject]), finder: finder)
        }
        else {
            return SugarRecordResults(realmResults: realmResults!.sortedResultsUsingProperty(property, ascending: ascending), finder: SugarRecordFinder<T>())
        }
    }
    
    func sortedResultsUsingDescriptors(properties: [AnyObject]!) -> SugarRecordResults<T>!
    {
        if (engine == SugarRecordEngine.SugarRecordEngineCoreData) {
            var array: NSArray = NSArray(array: coredataResults!)
            return SugarRecordResults(coredataResults: (array.sortedArrayUsingDescriptors(properties) as [NSManagedObject]), finder: finder)
        }
        else {
            return SugarRecordResults(realmResults: realmResults!.sortedResultsUsingDescriptors(properties), finder: finder)
        }
    }
    
    func realCollection() -> AnyObject
    {
        if (engine == SugarRecordEngine.SugarRecordEngineCoreData) {
            return coredataResults!
        }
        else {
            return realmResults!
        }
    }
    
    subscript (index: Int) -> T! {
        get {
            if (engine == SugarRecordEngine.SugarRecordEngineCoreData) {
                return coredataResults![index] as T
            }
            else {
                let (firstIndex, lastIndex) = indexes()
                return realmResults![UInt(index+firstIndex)] as T
            }
        }
    }
    
    //MARK: - Helpers
    
    func indexes() -> (Int, Int)
    {
        var firstIndex: Int = 0
        var lastIndex: Int = Int(realmResults!.count) - 1
        
        switch(finder.elements) {
        case .first:
            firstIndex = 0
            lastIndex = 0
        case .last:
            lastIndex = Int(realmResults!.count) - 1
            firstIndex = Int(realmResults!.count) - 1
        case .firsts(let number):
            firstIndex = 0
            lastIndex = firstIndex + number - 1
            if (lastIndex > Int(realmResults!.count) - 1) { lastIndex = Int(realmResults!.count) - 1 }
        case .lasts(let number):
            lastIndex = Int(realmResults!.count) - 1
            firstIndex = firstIndex - (number - 1)
            if (firstIndex < 0) { firstIndex = 0 }
        default:
            break
        }
        return (firstIndex, lastIndex)
    }
}