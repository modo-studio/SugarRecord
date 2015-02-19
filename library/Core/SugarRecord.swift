//
//  SugarRecord.swift
//  SugarRecord
//
//  Created by Pedro Piñera Buendía on 03/08/14.
//  Copyright (c) 2014 PPinera. All rights reserved.
//

import Foundation
import CoreData

// MARK: - Library Constants
internal let srSugarRecordVersion: String = "v1.0 - Alpha"


// MARK: -  Error codes
internal enum SugarRecordErrorCodes: Int {
    case UserError, LibraryError, CoreDataError, REALMError
}

/**
*  Completion closure used by the stack initialization
*
*  @param NSError? Error passed in case of something happened
*
*  @return Nothing to return
*/
public typealias CompletionClosure = (error: NSError?) -> ()


// MARK: -  Library

/**
 *  Main Library class with some useful constants and methods
 */
public class SugarRecord {
    
    /* Workaround to have static vars */
    private struct StaticVars
    {
        static var stacks: [protocol<SugarRecordStackProtocol>] = [SugarRecordStackProtocol]()
    }
    
    internal class func stacks() -> [protocol<SugarRecordStackProtocol>]
    {
        return StaticVars.stacks
    }

    /**
    Set the stack of SugarRecord. The stack should be previously initialized with the custom user configuration.
    
    :param: stack Stack by default where objects are going to be persisted
    */
    public class func addStack(stack: protocol<SugarRecordStackProtocol>)
    {
        SugarRecordLogger.logLevelInfo.log("Stack -\(stack)- added to SugarRecord")
        StaticVars.stacks.append(stack)
        stack.initialize()
    }
    
    
    /**
    Remove all the stacks from the list
    */
    public class func removeAllStacks()
    {
        StaticVars.stacks.removeAll(keepCapacity: false)
        SugarRecordLogger.logLevelVerbose.log("Removed all stacks form SugarRecord")
    }
    
    
    /**
    Returns a valid stack for a given type
    
    :param: stackType StackType of the required stack
    
    :returns: SugarRecord stack
    */
    internal class func stackFortype(stackType: SugarRecordEngine) -> SugarRecordStackProtocol?
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
        SugarRecordLogger.logLevelVerbose.log("Cleanup executed")
    }
    
    /**
    Remove the local database of stacks
    */
    public class func removeDatabase()
    {
        for stack in StaticVars.stacks {
            stack.removeDatabase()
        }
        removeAllStacks()
        SugarRecordLogger.logLevelVerbose.log("Database removed")
    }
    
    /**
     Returns the current version of SugarRecord

     :returns: String with the version value
     */
    public class func currentVersion() -> String
    {
        return srSugarRecordVersion
    }
    
    //MARK: - Operations
    
    /**
    Executes an operation closure in the main thread
    
    :param: closure Closure with operations to be executed
    */
    public class func operation(stackType: SugarRecordEngine, closure: (context: SugarRecordContext) -> ())
    {
        operation(inBackground: false, stackType: stackType, closure: closure)
    }
    
    /**
    Executes an operation closure passing it the context to perform operations
    
    :param: background Bool indicating if the operation is in background or not
    :param: closure    Closure with actions to be executed
    */
    public class func operation(inBackground background: Bool, stackType: SugarRecordEngine, closure: (context: SugarRecordContext) -> ())
    {
        let stack: SugarRecordStackProtocol? = stackFortype(stackType)
        if stack == nil {
            SugarRecord.handle(NSError(domain: "Cannot find an stack for the given type", code: SugarRecordErrorCodes.UserError.rawValue, userInfo: nil))
        }
        else if !stack!.stackInitialized {
            SugarRecordLogger.logLevelWarn.log("The stack hasn't been initialized yet")
            return
        }
        let context: SugarRecordContext? = background ? stack!.backgroundContext(): stack!.mainThreadContext()
        if context == nil {
            SugarRecord.handle(NSError(domain: "Something went wrong, the stack is set as initialized but there's no contexts", code: SugarRecordErrorCodes.LibraryError.rawValue, userInfo: nil))
        }
        if background {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), { () -> Void in
                closure(context: context!)
            })
        }
        else {
            closure(context: context!)
        }
    }
    
    
    // MARK: - SugarRecord Error Handler
    
    /**
    Handles an error around the SugarRecordLibrary
    Note: It asserts the error
    
    :param: error NSError to be processed
    */
    internal class func handle(error: NSError?) {
        if error == nil  { return }
        SugarRecordLogger.logLevelFatal.log("Error caught: \(error)")
        assert(true, "\(error?.localizedDescription)")
    }
    
    /**
    Handles an exception around the library
    
    :param: exception NSException to be processed
    */
    internal class func handle(exception: NSException?) {
        if exception == nil { return }
        SugarRecordLogger.logLevelError.log("Exception caught: \(exception)")
    }
}

