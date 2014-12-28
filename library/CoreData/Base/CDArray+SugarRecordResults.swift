//
//  CDArray+SugarRecordResults.swift
//  project
//
//  Created by Pedro Piñera Buendía on 28/12/14.
//  Copyright (c) 2014 SugarRecord. All rights reserved.
//

import Foundation
import CoreData

/**
*  Created array to add the conformance.
*   - It's a kind of tricky solution because conformance from a Generic type Array<T> turns into troubles
*/
internal class SugarRecordArray: SugarRecordResultsProtocol
{
    var array: Array<NSManagedObject>
    
    init(array: Array<NSManagedObject>)
    {
       self.array = array
    }
    
    func count(#finder: SugarRecordFinder) -> Int
    {
        return self.array.count
    }
    
    func objectAtIndex(index: UInt, finder: SugarRecordFinder) -> AnyObject!
    {
        if (Int(index) >= 0 && Int(index) < self.array.count) {
            return self.array[Int(index)]
        }
        return nil
    }
    
    func firstObject(#finder: SugarRecordFinder) -> AnyObject!
    {
        return (self.array.count != 0) ? self.array[0] : nil
    }
    
    func lastObject(#finder: SugarRecordFinder) -> AnyObject!
    {
        return (self.array.count != 0) ? self.array[self.array.count-1] : nil
    }
}
