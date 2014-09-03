//
//  NSManagedObject+Stack.swift
//  SugarRecord
//
//  Created by Pedro Piñera Buendía on 26/08/14.
//  Copyright (c) 2014 PPinera. All rights reserved.
//

import Foundation

extension NSManagedObject {

    /**
     Returns the entityName

     :returns: String with the entity name
     */
    class func entityName() -> (String) {
        var entityName: String? = NSStringFromClass(self)
        return entityName!
    }
    
    /**
     Returns the entity description in a given context

     :param: context NSManagedObjectContext where the entityDescription is going to be returned from

     :returns: NSEntityDescription
     */
    class func entityDescription(inContext context: NSManagedObjectContext?) -> (NSEntityDescription) {
        let entityName: String = self.entityName()
        return NSEntityDescription.entityForName(entityName, inManagedObjectContext: context!)
    }
    
    /**
     Generate sortDescriptors from an Array of Strings

     :param: attributes [String] with the sortDescriptors in String format

     :returns: [NSSortDescriptor] array with the created sortDescriptors
     */
    class func sortDescriptors(attributes: [String]) -> ([NSSortDescriptor]) {
        return sortDescriptors(attributes, ascending: true)
    }
    
    /**
     Generate sortDescriptors from an Array of Strings

     :param: attributes [String] with the sortDescriptors in String format
     :param: ascending  Bool with the order of the sortDescriptors

     :returns: [NSSortDescriptor] array with the created sortDescriptors
     */
    class func sortDescriptors(attributes: [String], ascending: Bool) -> ([NSSortDescriptor]) {
        var sortDescriptors: [NSSortDescriptor] = [NSSortDescriptor]()
        for attribute in attributes {
            sortDescriptors.append(NSSortDescriptor(key: attribute, ascending: ascending))
        }
        return sortDescriptors
    }
    
    /**
     Returns an array with the properties of the object

     :param: named   [String] Array with the properties in String format
     :param: context NSManagedObjectContext where the properties are going to be fetched

     :returns: [NSPropertyDescription] With properties descriptions
     */
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
                propertiesWanted[propertyName] = property!
            }
            else {
                SugarRecordLogger.logLevelVerbose.log("Property \(propertyName) not found for \(object_getClassName(self))")
            }
        }
        return propDict
    }
}