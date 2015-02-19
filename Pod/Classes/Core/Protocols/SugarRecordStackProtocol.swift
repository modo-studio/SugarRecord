//
//  SugarRecordStackProtocol.swift
//  SugarRecord
//
//  Created by Pedro Piñera Buendia on 07/09/14.
//  Copyright (c) 2014 SugarRecord. All rights reserved.
//

import Foundation

/**
Enum with the available stack types

- SugarRecordEngineCoreData: Stack type for Core Data stores
- SugarRecordEngineRealm:    Stack type for REALM stores
*/
public enum SugarRecordEngine
{
    case SugarRecordEngineCoreData, SugarRecordEngineRealm
}

/**
*  Protocol that defines the methods that every SugarRecord stack should implement
*/
public protocol SugarRecordStackProtocol
{
    /// Name of the stack
    var name: String { get }
    
    /// Type of stack
    var stackType: SugarRecordEngine { get }
    
    /// Description of the stack
    var stackDescription: String { get }
    
    /// Bool that indicates if the stack is initialized and ready to be used
    var stackInitialized: Bool { get }
    
    /**
    *  Called the first time to initialize the stack elements
    */
    func initialize()
    
    /**
    *  Called to remove the database
    */
    func removeDatabase()
    
    /**
    *  Clean up whatever is needed in the store
    */
    func cleanup()
    
    /**
    *  Called when the application will resign active
    */
    func applicationWillResignActive()
    
    /**
    *  Called when the application will terminate
    */
    func applicationWillTerminate()
    
    /**
    *  Called when the application will enter foreground
    */
    func applicationWillEnterForeground()
    
    /**
    *  Returns a background SugarRecord context to execute background operations
    */
    func backgroundContext() -> SugarRecordContext?
    
    /**
    *  Returns a SugarRecord context to execute background operations
    */
    func mainThreadContext() -> SugarRecordContext?
}