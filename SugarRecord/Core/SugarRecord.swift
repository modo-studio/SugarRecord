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

// MARK: SugarRecord Initialization

/**
 *  Main Library class with some useful constants and methods
 */
public class SugarRecord {
    
    /* Workaround to have static vars */
    private struct StaticVars
    {
        static var stacks: [protocol<SugarRecordStackProtocol>] = [SugarRecordStackProtocol]()
    }

    /**
    Set the stack of SugarRecord. The stack should be previously initialized with the custom user configuration.
    
    :param: stack Stack by default where objects are going to be persisted
    */
    public class func addStack(stack: protocol<SugarRecordStackProtocol>)
    {
        SugarRecordLogger.logLevelInfo.log("Set the stack -\(stack)- as the current SugarRecord stack")
        StaticVars.stacks.append(stack)
        stack.initialize()
    }
    
    
    /**
    Returns a valid stack for a given type
    
    :param: stackType StackType of the required stack
    
    :returns: SugarRecord stack
    */
    public class func stackFortype(stackType: SugarRecordStackType) -> SugarRecordStackProtocol?
    {
        for stack in StaticVars.stacks {
            if stack.stackType == stackType {
                return stack
            }
        }
        return nil
    }
    
    /**
    Called when the application will resign active
    */
    public class func applicationWillResignActive()
    {
        SugarRecordLogger.logLevelInfo.log("Notifying the current stack that the app will resign active")
        for stack in StaticVars.stacks {
            stack.applicationWillResignActive()
        }
    }
    
    /**
    Called when the application will terminate
    */
    public class func applicationWillTerminate()
    {
        SugarRecordLogger.logLevelInfo.log("Notifying the current stack that the app will temrinate")
        for stack in StaticVars.stacks {
            stack.applicationWillTerminate()
        }
    }
    
    /**
    Called when the application will enter foreground
    */
    public class func applicationWillEnterForeground()
    {
        SugarRecordLogger.logLevelInfo.log("Notifying the current stack that the app will temrinate")
        for stack in StaticVars.stacks {
            stack.applicationWillEnterForeground()
        }
    }
    
    /**
     Clean up the stack and notifies it using key srKVOCleanedUpNotification
     */
    public class func cleanup()
    {
        for stack in StaticVars.stacks {
            stack.cleanup()
        }
    }
    
    /**
    Remove the local database
    */
    public class func removeDatabase()
    {
        for stack in StaticVars.stacks {
            stack.removeDatabase()
        }
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

