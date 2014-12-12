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
    typealias T
    typealias R
    var count: UInt { get }
    func objectAtIndex(index: UInt) -> T!
    func firstObject() -> T!
    func lastObject() -> T!
    func indexOfObject(object: T) -> UInt
    func indexOfObjectWithPredicate(predicate: NSPredicate!) -> UInt
    func objectsWithPredicate(predicate: NSPredicate!) -> R!
    func sortedResultsUsingProperty(property: String!, ascending: Bool) -> R!
    func sortedResultsUsingDescriptors(properties: [AnyObject]!) -> R!
    subscript (index: UInt) -> T! { get }
}