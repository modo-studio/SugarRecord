//
//  SugarRecordResultsProtocol.swift
//  project
//
//  Created by Pedro Piñera Buendía on 11/12/14.
//  Copyright (c) 2014 SugarRecord. All rights reserved.
//

import Foundation

public protocol SugarRecordResultsProtocol
{
    var count: Int { get }
    func objectAtIndex(index: UInt) -> AnyObject!
    func firstObject() -> AnyObject!
    func lastObject() -> AnyObject!
    func indexOfObject(object: AnyObject) -> Int
    func indexOfObjectWithPredicate(predicate: NSPredicate!) -> Int
    func objectsWithPredicate(predicate: NSPredicate!) -> SugarRecordResultsProtocol!
    func sortedResultsUsingProperty(property: String!, ascending: Bool) -> SugarRecordResultsProtocol!
    func sortedResultsUsingDescriptors(properties: [AnyObject]!) -> SugarRecordResultsProtocol!
    subscript (index: Int) -> AnyObject! { get }
}