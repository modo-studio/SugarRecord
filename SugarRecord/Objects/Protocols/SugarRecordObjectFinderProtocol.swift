//
//  SugarRecordObjectQueryingProtocol.swift
//  SugarRecord
//
//  Created by Pedro Piñera Buendia on 07/09/14.
//  Copyright (c) 2014 SugarRecord. All rights reserved.
//

import Foundation

public protocol SugarRecordObjectFinderProtocol
{
    
    //MARK - Filtering
    
    class func by(predicate: NSPredicate) -> SugarRecordFinder
    class func by(predicateString: NSString) -> SugarRecordFinder
    class func by(key: String, equalTo value: String) -> SugarRecordFinder
    
    
    //MARK - Sorting
    
    class func sorted(by sorterKey: String, ascending: Bool) -> SugarRecordFinder
    class func sorted(by sortDescriptor: NSSortDescriptor) -> SugarRecordFinder
    class func sorted(by sortDescriptors: [NSSortDescriptor]) -> SugarRecordFinder
 
    //MARK - All
    class func all() -> SugarRecordFinder
}