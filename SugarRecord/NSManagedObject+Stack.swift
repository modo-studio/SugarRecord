//
//  NSManagedObject+Stack.swift
//  SugarRecord
//
//  Created by Pedro Piñera Buendía on 26/08/14.
//  Copyright (c) 2014 PPinera. All rights reserved.
//

import Foundation

extension NSManagedObject {
    class func entityName() -> (String) {
        var entityName: String? = NSStringFromClass(self)
        return entityName!
    }
    
    class func entityDescriptionInContext(context: NSManagedObjectContext) -> (NSEntityDescription) {
        var entityName: String = self.entityName()
        return NSEntityDescription.entityForName(entityName, inManagedObjectContext: context)
    }

    class func entityDescription(inContext context: NSManagedObjectContext?) -> (NSEntityDescription) {
        let entityName: String = self.entityName()
        return NSEntityDescription.entityForName(entityName, inManagedObjectContext: context!)
    }
    
    class func sortDescriptors(attributes: [String]) -> ([NSSortDescriptor]) {
        return sortDescriptors(attributes, ascending: true)
    }
    
    class func sortDescriptors(attributes: [String], ascending: Bool) -> ([NSSortDescriptor]) {
        var sortDescriptors: [NSSortDescriptor] = [NSSortDescriptor]()
        for attribute in attributes {
            sortDescriptors.append(NSSortDescriptor(key: attribute, ascending: ascending))
        }
        return sortDescriptors
    }
    
    class func properties(named: [String], inContext context: NSManagedObjectContext?) -> ([String: NSPropertyDescription]) {
        let description: NSEntityDescription = self.entityDescription(inContext: context)
        var propertiesWanted: [String: NSPropertyDescription] = [String: NSPropertyDescription]()
        if named.count == 0 {
            return propertiesWanted
        }
        var propDict: [String: NSPropertyDescription] = description.propertiesByName as [String: NSPropertyDescription]!
        for propertyName in named {
            let property: NSPropertyDescription? = propDict[propertyName]
            if property != nil {
                
            }
            else {
                SugarRecordLogger.logLevelVerbose.log("Property \(propertyName) not found for \(object_getClassName(self))")
            }
        }
        return propDict
    }
}