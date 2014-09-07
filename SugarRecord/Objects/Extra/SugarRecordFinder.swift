//
//  SugarRecordFinder.swift
//  SugarRecord
//
//  Created by Pedro Piñera Buendia on 07/09/14.
//  Copyright (c) 2014 SugarRecord. All rights reserved.
//

import Foundation

public class SugarRecordFinder
{
    //MARK - Attributes
    
    var predicate: NSPredicate?
    var objectClass: AnyClass?
    
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
    
    //MARK - Cuantifiers
    // - all
    // - first
    // - last
    // - firsts(20)
    // - lasts(50)
    
    //MARK - Finders
    
    func fetch() -> ([AnyClass])
    {
        
    }
    
    func fetch(inContext context: SugarRecordContext) -> ([AnyClass])
    {
        
    }
    
    func fetchAsync(completion: (objects: [AnyClass]) -> ())
    {
        
    }

    
}