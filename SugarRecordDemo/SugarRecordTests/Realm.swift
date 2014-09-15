//
//  Realm.swift
//  SugarRecord
//
//  Created by Pedro Piñera Buendía on 15/09/14.
//  Copyright (c) 2014 SugarRecord. All rights reserved.
//

import Foundation
import Realm

class Realm: RLMObject
{
    var name: String?
    var age: Int?
    var email: String?
    var city: String?
    var birthday: NSDate?
}