//
//  RestKitModel.swift
//  SugarRecordExample
//
//  Created by Robert Dougan on 15/12/14.
//  Copyright (c) 2014 Robert Dougan. All rights reserved.
//

import Foundation
import CoreData

@objc(RestKitModel)
class RestKitModel: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var date: NSDate

}
