//
//  SugarRecordContext.swift
//  SugarRecord
//
//  Created by Pedro Piñera Buendia on 07/09/14.
//  Copyright (c) 2014 SugarRecord. All rights reserved.
//

import Foundation

public protocol SugarRecordContext
{
    func beginWritting()
    func endWritting()
    func createObject(objectClass: AnyClass) -> AnyObject?
    func insertObject(object: AnyObject)
    func deleteObject(object: AnyObject) -> Bool
    func deleteObjects(objects: [AnyObject]) -> Bool
    func find(finder: SugarRecordFinder) -> [AnyObject]?
}