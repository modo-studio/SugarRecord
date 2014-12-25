//
//  RealmModel.swift
//  SugarRecordExample
//
//  Created by Pedro Piñera Buendía on 25/12/14.
//  Copyright (c) 2014 Robert Dougan. All rights reserved.
//

import Foundation
import Realm

class RealmModel: RLMObject {
    dynamic var name = ""
    dynamic var date = NSDate()
}