//
//  RLMResults+SugarRecordResults.swift
//  project
//
//  Created by Pedro Piñera Buendía on 28/12/14.
//  Copyright (c) 2014 SugarRecord. All rights reserved.
//

import Foundation
import Realm

 extension RLMResults: SugarRecordResultsProtocol
{
    func count(finder finder: SugarRecordFinder) -> Int
    {
        let (firstIndex, lastIndex) = indexes(finder: finder)
        if (lastIndex == 0 && firstIndex == 0) { return Int(self.count) }
        return lastIndex - firstIndex + 1
    }
    
    func objectAtIndex(index: UInt, finder: SugarRecordFinder) -> AnyObject!
    {
        let (firstIndex, lastIndex) = indexes(finder: finder)
        return self.objectAtIndex(UInt(firstIndex) + index)
    }
    
    func firstObject(finder finder: SugarRecordFinder) -> AnyObject!
    {
        let (firstIndex, lastIndex) = indexes(finder: finder)
        return self.objectAtIndex(UInt(firstIndex))
    }
    
    func lastObject(finder finder: SugarRecordFinder) -> AnyObject!
    {
        let (firstIndex, lastIndex) = indexes(finder: finder)
        return self.objectAtIndex(UInt(lastIndex))
    }
    
    //MARK: Helpers
    
    /**
    Returns the first and the last element taking into account the SugarRecordFinder options
    
    - returns: Tuple with the first and last index
    */
    private func indexes(finder finder: SugarRecordFinder) -> (Int, Int)
    {
        var firstIndex: Int = 0
        var lastIndex: Int = Int(self.count) - 1
        
        switch(finder.elements) {
        case .first:
            firstIndex = 0
            lastIndex = 0
        case .last:
            lastIndex = Int(self.count) - 1
            firstIndex = Int(self.count) - 1
        case .firsts(let number):
            firstIndex = 0
            lastIndex = firstIndex + number - 1
            if (lastIndex > Int(self.count) - 1) { lastIndex = Int(self.count) - 1 }
        case .lasts(let number):
            lastIndex = Int(self.count) - 1
            firstIndex = firstIndex - (number - 1)
            if (firstIndex < 0) { firstIndex = 0 }
        default:
            break
        }
        return (firstIndex, lastIndex)
    }
}