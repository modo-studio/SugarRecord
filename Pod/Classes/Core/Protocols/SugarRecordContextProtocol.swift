//
//  SugarRecordContext.swift
//  SugarRecord
//
//  Created by Pedro Piñera Buendia on 07/09/14.
//  Copyright (c) 2014 SugarRecord. All rights reserved.
//

import Foundation

public protocol SugarRecordContext
{
    /**
    *  Notifies the context that something is going to change there
    */
    func beginWriting()
    
    /**
    *  Notifies the context that the edition has finished
    */
    func endWriting()
    
    /**
    *  Asks the context for writing cancellation
    */
    func cancelWriting()
    
    /**
    *  Creates an object of the given type in the context (without saving the context)
    */
    func createObject(objectClass: AnyClass) -> AnyObject?
    
    /**
    *  Inserts a given object into a context (saving then the context with that object)
    */
    func insertObject(object: AnyObject)
    
    /**
    *  Deletes the object from the context
    */
    func deleteObject(object: AnyObject) -> SugarRecordContext
    
    /**
    *  Deletes the objects in the array from the context
    */
    func deleteObjects(objects: SugarRecordResults) -> ()
    
    /**
    *  Executes the finder query to return filtered values
    */
    func find(finder: SugarRecordFinder) -> SugarRecordResults
}