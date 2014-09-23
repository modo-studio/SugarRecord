//
//  NSManagedObjectContext+Debug.swift
//  SugarRecord
//
//  Created by Pedro Piñera Buendía on 26/08/14.
//  Copyright (c) 2014 PPinera. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObjectContext {
    /**
     Set a working name to the context

     :param: workingName String with the working name
     */
    func setWorkingName(workingName: String) {
        self.userInfo.setObject(workingName, forKey: srContextWorkingNameKey)
    }

    /**
     Returns the working name of the context. "Unnamed context" otherwise

     :returns: String with the working name
     */
    func workingName() -> (String) {
        var workingName: String? =   self.userInfo.objectForKey(srContextWorkingNameKey)  as? String
        if workingName == nil {
            workingName = "Unnamed context"
        }
        return workingName!
    }

    /**
     Returns an String with the description of the context

     :returns: String with the description
     */
    func description() -> (String) {
        let onMainThread: String = NSThread.isMainThread() ? "Main Thread" : "Background thread"
        return "<\(object_getClassName(self)): \(self.workingName()) on \(onMainThread)"
    }
    
    /**
     Returns an String with the stack information on the top of the context

     :returns: String with the informaion
     */
    func parentChain () -> (String)
    {
        var familyTree: String = "\n"
        var currentContext: NSManagedObjectContext! = self
        do {
            familyTree += " - \(currentContext.workingName()) (\(currentContext)) \n"
            familyTree += currentContext == self ? "(*)" : ""
            currentContext = currentContext.parentContext
        } while (currentContext != nil)
        return familyTree
    }
}