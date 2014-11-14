//
//  Film.swift
//  SugarRecord
//
//  Created by Pedro Piñera Buendía on 26/10/14.
//  Copyright (c) 2014 SugarRecord. All rights reserved.
//

import Foundation
import CoreData

class Film: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var date: NSDate
    @NSManaged var budget: NSNumber
    @NSManaged var collection: NSNumber
    @NSManaged var actors: NSDecimalNumber
    @NSManaged var rating: NSNumber
    @NSManaged var opinions: NSNumber
    @NSManaged var countries: NSNumber
    @NSManaged var english: NSNumber

}
