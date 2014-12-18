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
    class func modelName() -> String
    
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
    class func by<T: StringLiteralConvertible, R: StringLiteralConvertible>(key: T, equalTo value: R) -> SugarRecordFinder
    
    
    //MARK: - Sorting
    
    /**
    *  Returns a SugarRecord finder passing a sorter key
    */
    class func sorted<T: StringLiteralConvertible>(by sorterKey: T, ascending: Bool) -> SugarRecordFinder
    
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
    func delete() -> SugarRecordContext
    
    
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
    
    
    //MARK: - Editing
    
    /**
    *  Notifies the context that the object is going to be edited returning the object for the edition
    */
    func beginWriting() -> SugarRecordObjectProtocol
    
    /**
    *  Notifies the context that the object edition has finished
    */
    func endWriting()

    
    /**
    * Asks the context for writing cancellation
    */
    func cancelWriting()
}

//MARK : Operators

infix operator <- { associativity right precedence 90 }

//MARK : Operators

public func += <R: SugarRecordObjectProtocol> (left: R.Type, inout right: R)
{
    right.save()
}

public postfix func ++ <R: SugarRecordObjectProtocol> (left: R.Type) -> R
{
    var object: R = left.create() as R
    return object
}

public func -= <R: SugarRecordObjectProtocol> (left: R.Type, inout right: R)
{
    right.delete()
}

public func <- <R: SugarRecordObjectProtocol, C: SugarRecordContext> (left: C, inout right: R.Type) -> R
{
    var object: R = right.create(inContext: left) as R
    return object
}
