//
//  SugarRecord+Operations.swift
//  SugarRecord
//
//  Created by Pedro Piñera Buendía on 26/08/14.
//  Copyright (c) 2014 PPinera. All rights reserved.
//

import Foundation
import CoreData

// MARK - SugarRecord Operations

public extension SugarRecord
    {
    /**
     Executes a closure pasing a context as an input paramter to the closure and saving the context changes before deleting it

     :param: background  Indicates if the saving is going to be executed in background
     :param: savingClosure Closure to be executed. Context passed is a private context
     */
    class func save(inBackground background: Bool, savingClosure: (context: NSManagedObjectContext) -> (), completion: (success: Bool, error: NSError?) -> ())
    {
        SugarRecord.save(true, savingClosure: savingClosure, completion: completion)
    }
    

    /**
    Executes a closure in background pasing a context as an input paramter to the closure and saving the context changes before deleting it


     :param: synchronously Bool indicating if the saving is going to be synchronous
     :param: savingClosure   Closure to be executed. Context passed is a private context
     */
    private class func save(synchronously: Bool, savingClosure: (context: NSManagedObjectContext) -> (), completion: (success: Bool, error: NSError?) -> ())
    {
        // Generating context
        let privateContext: NSManagedObjectContext = NSManagedObjectContext.newContextWithParentContext(NSManagedObjectContext.rootSavingContext()!)
        
        // Executing closure
        if synchronously {
            privateContext.performBlockAndWait({ () -> Void in
                savingClosure(context: privateContext)
                privateContext.save(true, savingParents: true, completion: completion)
            })
        }
        else {
            privateContext.performBlock({ () -> Void in
                savingClosure(context: privateContext)
                privateContext.save(false, savingParents: true, completion: completion)
            })
        }
    }

    /**
     Executes a closure operatin in background but without saving the context used in background.

     :param: Closure that is going to be executed
     */
    class func background(closure: (context: NSManagedObjectContext) -> ())
    {
        var privateContext: NSManagedObjectContext = NSManagedObjectContext.newContextWithParentContext(NSManagedObjectContext.rootSavingContext()!)
        privateContext.performBlockAndWait({ () -> Void in
            closure(context: privateContext)
        })
    
    }
}
