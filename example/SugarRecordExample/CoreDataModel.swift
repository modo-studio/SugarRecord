//
//  CoreDataModel.swift
//  SugarRecordExample
//
//  Created by Robert Dougan on 10/12/14.
//  Copyright (c) 2014 Robert Dougan. All rights reserved.
//

import Foundation
import CoreData

@objc(CoreDataModel)
class CoreDataModel: NSManagedObject {

    @NSManaged var text: String

}
