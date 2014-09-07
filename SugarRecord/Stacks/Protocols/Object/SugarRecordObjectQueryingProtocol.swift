//
//  SugarRecordObjectQueryingProtocol.swift
//  SugarRecord
//
//  Created by Pedro Piñera Buendia on 07/09/14.
//  Copyright (c) 2014 SugarRecord. All rights reserved.
//

import Foundation

protocol SugarRecordObjectQueryingProtocol
{
    class func findBy(predicate: NSPredicate) -> ([SugarRecordObjectProtocol])
    class func findby(key: String, equalTo value: String) -> ([SugarRecordObjectProtocol])
    
}