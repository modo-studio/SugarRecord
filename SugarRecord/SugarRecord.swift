//
//  SugarRecord.swift
//  SugarRecord
//
//  Created by Pedro Piñera Buendía on 03/08/14.
//  Copyright (c) 2014 PPinera. All rights reserved.
//

import Foundation
import CoreData

// MARK: Library Constants
public let srSugarRecordVersion: String = "v1.0 - Alpha"

// MARK: Options


// MARK: SugarRecord Initialization

/**
 *  Main Library class with some useful constants and methods
 */
public class SugarRecord {
    
    /* Workaround to have static vars */
    private struct StaticVars
    {
        static var stack: protocol<SugarRecordStackProtocol>?
    }

    /**
    Set the stack of SugarRecord. The stack should be previously initialized with the custom user configuration.
    
    :param: stack Stack by default where objects are going to be persisted
    */
    public class func setStack(stack: protocol<SugarRecordStackProtocol>)
    {
        StaticVars.stack = stack
    }
    
    
    public class func stack() -> (protocol<SugarRecordStackProtocol>) {
        return StaticVars.stack!
    }

    /**
     Clean up the stack and notifies it using key srKVOCleanedUpNotification
     */
    public class func cleanUp() {
        StaticVars.stack?.cleanup()
    }
    
    /**
    Remove the local database
    */
    public class func removeDatabase()
    {
        
    }
    
    /**
     Returns the current version of SugarRecord

     :returns: String with the version value
     */
    public class func currentVersion() -> String
    {
        return srSugarRecordVersion
    }
}

