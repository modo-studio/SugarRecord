//
//  Person.swift
//  SugarRecord
//
//  Created by Pedro Piñera Buendía on 15/09/14.
//  Copyright (c) 2014 SugarRecord. All rights reserved.
//

import Foundation
import CoreData

public class CoreData: NSManagedObject
{
    @NSManaged var age: NSDecimalNumber
    @NSManaged var email: String
    @NSManaged var name: String
    @NSManaged var birth: NSDate
    @NSManaged var city: String

}
