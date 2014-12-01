//
//  Realm.swift
//  SugarRecord
//
//  Created by Pedro Piñera Buendía on 15/09/14.
//  Copyright (c) 2014 SugarRecord. All rights reserved.
//

import Foundation
import Realm

public class RealmObject: RLMObject
{
    public dynamic var name: String = ""
    public dynamic var age: Int = 0
    public dynamic var email: String = ""
    public dynamic var city: String = ""
    public dynamic var birthday: NSDate = NSDate()
}