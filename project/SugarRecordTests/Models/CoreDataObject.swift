//
//  CoreDataObject.swift
//  SugarRecord
//
//  Created by Pedro Piñera Buendía on 20/09/14.
//  Copyright (c) 2014 SugarRecord. All rights reserved.
//

import Foundation
import CoreData

@objc(CoreDataObject)
class CoreDataObject: NSManagedObject {

    @NSManaged var age: NSDecimalNumber
    @NSManaged var birth: NSDate
    @NSManaged var city: String
    @NSManaged var email: String
    @NSManaged var name: String

}
