//
//  SugarRecord+Operations.swift
//  SugarRecord
//
//  Created by Pedro Piñera Buendía on 26/08/14.
//  Copyright (c) 2014 PPinera. All rights reserved.
//

import Foundation

// MARK - SugarRecord Operations

public extension SugarRecord {
    /**
     Executes a closure block pasing a context as an input paramter to the closure and saving the context changes before deleting it

     :param: background  Indicates if the saving is going to be executed in background
     :param: savingBlock Closure to be executed. Context passed is a private context
     */
    class func save(inBackground background: Bool, savingBlock: (context: NSManagedObjectContext) -> (), completion: (success: Bool, error: NSError?) -> ()) {
        SugarRecord.save(true, savingBlock: savingBlock, completion: completion)
    }
    

    /**
    Executes a closure block in background pasing a context as an input paramter to the closure and saving the context changes before deleting it


     :param: synchronously Bool indicating if the saving is going to be synchronous
     :param: savingBlock   Closure to be executed. Context passed is a private context
     */
    private class func save(synchronously: Bool, savingBlock: (context: NSManagedObjectContext) -> (), completion: (success: Bool, error: NSError?) -> ()) {
        // Generating context
        let privateContext: NSManagedObjectContext = NSManagedObjectContext.newContextWithParentContext(NSManagedObjectContext.rootSavingContext()!)
        
        // Executing block
        if synchronously {
            privateContext.performBlockAndWait({ () -> Void in
                savingBlock(context: privateContext)
                privateContext.save(true, savingParents: true, completion: completion)
            })
        }
        else {
            privateContext.performBlock({ () -> Void in
                savingBlock(context: privateContext)
                privateContext.save(false, savingParents: true, completion: completion)
            })
        }
    }

}
