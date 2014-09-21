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
    //MARK: - Custom Getter
    
    /**
    *  Returns the SugarRecord context
    */
    func context() -> SugarRecordContext
    
    /**
    *  Returns the stack type of this class
    */
    class func stackType() -> SugarRecordStackType
    
    /**
    *  Returns the entity name
    */
    class func entityName() -> String
    
    //MARK: - Filtering
    
    /**
    *  Returns a SugarRecord finder passing a predicate
    */
    class func by(predicate: NSPredicate) -> SugarRecordFinder
    
    /**
    *  Returns a SugarRecord finder passing a predicate in String format
    */
    class func by(predicateString: NSString) -> SugarRecordFinder
    
    /**
    *  Returns a SugarRecord finder passing a predicate in a value-key format
    */
    class func by(key: String, equalTo value: String) -> SugarRecordFinder
    
    
    //MARK: - Sorting
    
    /**
    *  Returns a SugarRecord finder passing a sorter key
    */
    class func sorted(by sorterKey: String, ascending: Bool) -> SugarRecordFinder
    
    /**
    *  Returns a SugarRecord finder pasing a sort descriptor
    */
    class func sorted(by sortDescriptor: NSSortDescriptor) -> SugarRecordFinder
    
    /**
    *  Returns a SugarRecord finder passing a sort descriptor
    */
    class func sorted(by sortDescriptors: [NSSortDescriptor]) -> SugarRecordFinder
    
    
    //MARK: - All
    
    /**
    *  Returns a SugarRecord finder to fetch all items
    */
    class func all() -> SugarRecordFinder
    
    
    //MARK: - Deletion
    
    /**
    *  Deletes the object
    */
    func delete() -> Bool
    
    
    //MARK: - Creation
    
    /**
    *  Creates the object in the main context
    */
    class func create() -> AnyObject
    
    /**
    *  Creates the object in the given context
    */
    class func create(inContext context: SugarRecordContext) -> AnyObject
    
    
    //MARK: - Saving
    
    /**
    *  Saves the object
    */
    func save () -> Bool
    
    /**
    *  Saves the object sync/async with a completion closure
    */
    func save (asynchronously: Bool, completion: (error: NSError) -> ())
    
    //MARK: - BeginEditing
    
    /**
    *  Notifies the context that the object is going to be edited
    */
    func beginEditing()
    
    /**
    *  Notifies the context that the object edition has finished
    */
    func endEditing()
}