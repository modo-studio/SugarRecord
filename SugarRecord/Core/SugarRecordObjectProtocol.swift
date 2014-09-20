//
//  SugarRecordObjectProtocol.swift
//  SugarRecord
//
//  Created by Pedro Piñera Buendía on 11/09/14.
//  Copyright (c) 2014 SugarRecord. All rights reserved.
//

import Foundation

public protocol SugarRecordObjectProtocol
{
    //MARK - Custom Getter
    
    func context() -> SugarRecordContext
    class func entityName() -> String
    
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
    
    
    //MARK - Deletion
    
    func delete() -> Bool
    
    
    //MARK - Creation
    
    class func create() -> AnyObject
    class func create(inContext context: SugarRecordContext) -> AnyObject
    
    
    //MARK - Saving
    
    func save () -> Bool
    func save (asynchronously: Bool, completion: (error: NSError) -> ())
    
    //MARK - BeginEditing
    
    func beginEditing()
    func endEditing()
}