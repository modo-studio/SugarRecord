//
//  SugarRecordFinder.swift
//  SugarRecord
//
//  Created by Pedro Piñera Buendia on 07/09/14.
//  Copyright (c) 2014 SugarRecord. All rights reserved.
//

import Foundation


public enum SugarRecordFinderElements
{
    case first, last, all
    case firsts(Int)
    case lasts(Int)
}

public class SugarRecordFinder
{
    
    //MARK - Attributes
    
    var predicate: NSPredicate?
    var objectClass: AnyClass?
    var elements: SugarRecordFinderElements?
    lazy var sortDescriptors: [NSSortDescriptor] = [NSSortDescriptor] ()
    
    
    // MARK - Constructors
    
    init () {}
    
    init (predicate: NSPredicate)
    {
        self.predicate = predicate
    }
    
    init (sortDescriptor: NSSortDescriptor)
    {
        self.sortDescriptors = [sortDescriptor]
    }
    
    
    // MARK - Concatenaros
    
    public func by(predicate: NSPredicate) -> SugarRecordFinder
    {
        if self.predicate != nil {
            SugarRecordLogger.logLevelWarm.log("You are overriding an existing predicate")
        }
        self.predicate = predicate
        return self
    }
    
    public func by(predicateString: NSString) -> SugarRecordFinder
    {
        if self.predicate != nil {
            SugarRecordLogger.logLevelWarm.log("You are overriding an existing predicate")
        }
        self.setPredicate(predicateString)
        return self
    }
    
    public func by(key: String, equalTo value: String) -> SugarRecordFinder
    {
        if self.predicate != nil {
            SugarRecordLogger.logLevelWarm.log("You are overriding an existing predicate")
        }
        self.setPredicate(byKey: key, andValue: value)
        return self
    }
    
    public func sorted(by sortingKey: String, ascending: Bool) -> SugarRecordFinder
    {
        self.addSortDescriptor(byKey: sortingKey, ascending: ascending)
        return self
    }
    
    public func sorted(by sortDescriptor: NSSortDescriptor) -> SugarRecordFinder
    {
        self.addSortDescriptor(sortDescriptor)
        return self
    }
    
    public func sorted(by sortDescriptors: [NSSortDescriptor]) -> SugarRecordFinder
    {
        if self.sortDescriptors.count != 0  {
            SugarRecordLogger.logLevelWarm.log("You are overriding the existing sort descriptors")
        }
        self.sortDescriptors = sortDescriptors
        return self
    }
    
    
    //MARK - Sort Descriptors
    
    func addSortDescriptor(sortDescriptor: NSSortDescriptor) -> SugarRecordFinder
    {
        sortDescriptors.append(sortDescriptor)
        return self
    }
    
    func addSortDescriptor(byKey key: String, ascending: Bool) -> SugarRecordFinder
    {
        sortDescriptors.append(NSSortDescriptor(key: key, ascending: ascending))
        return self
    }
    
    func setSortDescriptors(sortDescriptors: [NSSortDescriptor]) -> SugarRecordFinder
    {
        self.sortDescriptors = sortDescriptors
        return self
    }
    
    func sortDescriptorsCount() -> Int
    {
        return self.sortDescriptors.count
    }
    
    
    //MARK - Predicates
    
    func setPredicate(predicate: NSPredicate) -> SugarRecordFinder
    {
        self.predicate = predicate
        return self
    }
    
    func setPredicate(predicateString: String) -> SugarRecordFinder
    {
        self.predicate = NSPredicate(format: predicateString)
        return self
    }
    
    func setPredicate(byKey key: String, andValue value: String) -> SugarRecordFinder
    {
        self.predicate = NSPredicate(format: "\(key) == \(value)")
        return self
    }
    
    
    //MARK - Elements
    
    public func all() -> SugarRecordFinder
    {
        self.elements = SugarRecordFinderElements.all
        return self
    }
    
    public func first() -> SugarRecordFinder
    {
        self.elements = SugarRecordFinderElements.first
        return self
    }
    
    public func last() -> SugarRecordFinder
    {
        self.elements = SugarRecordFinderElements.last
        return self
    }
    
    public func firsts(number: Int) -> SugarRecordFinder
    {
        self.elements = SugarRecordFinderElements.firsts(number)
        return self
    }
    
    public func lasts(number: Int) -> SugarRecordFinder
    {
        self.elements = SugarRecordFinderElements.firsts(number)
        return self
    }
}