//
//  NSManagedObjectModel+Stack.swift
//  SugarRecord
//
//  Created by Pedro Piñera Buendía on 26/08/14.
//  Copyright (c) 2014 PPinera. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObjectModel {
    // Static variables
    struct Static {
        static var defaultManagedObjectModel: NSManagedObjectModel? = nil
    }
    
    /**
     Set the default managed object modelName

     :param: objectModel NSManagedObjectModel to be set as default
     */
    class func setDefaultManagedObjectModel(objectModel: NSManagedObjectModel) {
        Static.defaultManagedObjectModel = objectModel
    }
    class func defaultManagedObjectModel() -> NSManagedObjectModel {
        var currentModel: NSManagedObjectModel? = Static.defaultManagedObjectModel
        if currentModel == nil {
            currentModel = self.mergedModelFromBundles(nil)
            self.setDefaultManagedObjectModel(currentModel!)
        }
        return currentModel!
    }
    
    /**
     Returns the mergedModel from the main bundle

     :returns: NSManagedObjectModel from the main Bundle
     */
    class func mergedModelFromMainBundle() -> NSManagedObjectModel {
        return mergedModelFromBundles(nil)
    }
    
    
    /**
     Creates a new model in with the passed name and in the bundle passed too 
    
     :param: modelName String with the new model name
     :param: inBundle NSBundle where the NSManagedObjectModel is going to be created

     :returns: NSManagedObjectModel created NSManagedObjectModel
     */
    class func newModel(modelName: String, var inBundle bundle: NSBundle?) -> NSManagedObjectModel {
        if bundle == nil {
            bundle = NSBundle.mainBundle()
        }
        let path: String = bundle!.pathForResource(modelName.stringByDeletingPathExtension, ofType: modelName.pathExtension)!
        let modelURL: NSURL = NSURL.fileURLWithPath(path)!
        let mom: NSManagedObjectModel = NSManagedObjectModel(contentsOfURL: modelURL)
        return mom
    }
    
    /**
     Clean the default managed object model
     */
    class func cleanUp () {
        Static.defaultManagedObjectModel = nil
    }
}