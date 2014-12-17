//
//  SugarRecordResultsProtocol.swift
//  project
//
//  Created by Pedro Piñera Buendía on 11/12/14.
//  Copyright (c) 2014 SugarRecord. All rights reserved.
//

import Foundation

protocol SugarRecordResultsProtocol
{
    var count: UInt { get }
    func objectAtIndex(index: UInt) -> AnyObject!
    func firstObject() -> AnyObject!
    func lastObject() -> AnyObject!
    func indexOfObject(object: AnyObject) -> UInt
    func indexOfObjectWithPredicate(predicate: NSPredicate!) -> UInt
    func objectsWithPredicate(predicate: NSPredicate!) -> SugarRecordResultsProtocol!
    func sortedResultsUsingProperty(property: String!, ascending: Bool) -> SugarRecordResultsProtocol!
    func sortedResultsUsingDescriptors(properties: [AnyObject]!) -> SugarRecordResultsProtocol!
    subscript (index: UInt) -> AnyObject! { get }
}