//
//  NSManagedObjectContext+Saving.swift
//  SugarRecord
//
//  Created by Pedro Piñera Buendía on 26/08/14.
//  Copyright (c) 2014 PPinera. All rights reserved.
//

import Foundation

extension NSManagedObjectContext {
    /// Delete the given objects
    func delete(let objects: [NSManagedObject]) {
        for object in objects {
            self.deleteObject(object)
        }
    }
    
    /**
     Save the context with extra options

     :param: synchronously Bool indicating if the saving has to be synchronous
     :param: savingParents Bool indicating if parents have to be saved too
     :param: completion    Closure with the completion block
     */
    func save(synchronously: Bool, savingParents: Bool, completion: (success: Bool, error: NSError?) -> ()) {
       var hasChanges: Bool = false
        if self.concurrencyType == .ConfinementConcurrencyType {
            hasChanges = self.hasChanges
        }
        else {
            self.performBlockAndWait({ () -> Void in
                hasChanges = self.hasChanges
            })
        }
        
        // If it doesn't have changes there's nothing to do
        if !hasChanges {
            SugarRecordLogger.logLevelVerbose.log("No changes in context \(self.workingName()) - Not saving")
            dispatch_async(dispatch_get_main_queue(), {
                        completion(success: false, error: nil)
            })
        }
        
        var saveClosure: () -> () = {
            var saveResult: Bool = false
            var error: NSError?
            saveResult = self.save(&error)
            if error != nil {
                SugarRecord.handle(error!)
            }
            if (saveResult && savingParents && self.parentContext != nil) {
                self.parentContext.save(synchronously, savingParents: savingParents, completion: completion)
            }
            else {
                if saveResult {
                    SugarRecordLogger.logLevelVerbose.log("Finished saving \(self.description)")
                }
                dispatch_async(dispatch_get_main_queue(), {
                    completion(success: saveResult, error: error)
                })
            }
        }
        
        // Saving otherwise
        if synchronously {
            self.performBlockAndWait(saveClosure)
        }
        else {
            self.performBlock(saveClosure)
        }
    }
}