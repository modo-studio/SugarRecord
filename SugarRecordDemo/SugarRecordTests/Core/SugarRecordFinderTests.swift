//
//  SugarRecordFinderTests.swift
//  SugarRecord
//
//  Created by Pedro Piñera Buendia on 07/09/14.
//  Copyright (c) 2014 SugarRecord. All rights reserved.
//

import XCTest
import Foundation
import CoreData


class SugarRecordSugarRecordFinderTests: XCTestCase
{
    var sugarRecordFinder: SugarRecordFinder!
    override func setUp()
    {
        super.setUp()
        sugarRecordFinder = SugarRecordFinder()
    }
    
    override func tearDown()
    {
        sugarRecordFinder = nil
        super.tearDown()
    }
    
    func testIfSortDescriptorsAreAddedToTheArrayUnsingSortDescriptor()
    {
        var sortDescriptor: NSSortDescriptor = NSSortDescriptor(key: "test", ascending: true)
        sugarRecordFinder.addSortDescriptor(sortDescriptor)
        XCTAssertEqual(sugarRecordFinder.sortDescriptorsCount(), 1, "The number of sort descriptors should be 1")
    }
    
    func testIfSortDescriptorsAreAddedToTheArrayUnsingKeyAndAscending()
    {
        sugarRecordFinder = sugarRecordFinder.addSortDescriptor(byKey: "name", ascending: true)
        XCTAssertEqual(sugarRecordFinder.sortDescriptors.last!.ascending, true, "The ascending value should be true")
        XCTAssertEqual(sugarRecordFinder.sortDescriptors.last!.key!, "name", "The key value should be name")
    }
    
    func testIfPredicatesAreAddedPassingThePredicate()
    {
        let predicate: NSPredicate = NSPredicate()
        sugarRecordFinder.setPredicate(predicate)
        XCTAssertEqual(sugarRecordFinder.predicate!, predicate, "The predicate is not the same")
    }
    
    func testIfPredicatesAreAddedPassingThePredicateString()
    {
        let predicateString: String = "name == NULL"
        sugarRecordFinder.setPredicate(predicateString)
        let predicate: NSPredicate = sugarRecordFinder.predicate!
        XCTAssertEqual(predicate.predicateFormat, "name == nil", "The predicate format doesn't match with the passed string")
    }
    
    func testIfAllElementsIsAdded()
    {
        sugarRecordFinder = sugarRecordFinder.all()
        var isAll: Bool?
        switch sugarRecordFinder.elements {
        case .all:
            isAll = true
        default:
            isAll = false
        }
        XCTAssertEqual(isAll!, true, "ALL not set properly")
    }
    
    func testIfFirstElementsIsAdded()
    {
        sugarRecordFinder = sugarRecordFinder.first()
        var isFirst: Bool?
        switch sugarRecordFinder.elements {
        case .first:
            isFirst = true
        default:
            isFirst = false
        }
        XCTAssertEqual(isFirst!, true, "FIRST not set properly")
    }
    
    func testIfLastElementsIsAdded()
    {
        sugarRecordFinder = sugarRecordFinder.last()
        var isLast: Bool?
        switch sugarRecordFinder.elements {
        case .last:
            isLast = true
        default:
            isLast = false
        }
        XCTAssertEqual(isLast!, true, "LAST not set properly")
    }
    
    func testIfLastsElementsIsAdded()
    {
        sugarRecordFinder = sugarRecordFinder.lasts(20)
        var isLasts: Bool?
        switch sugarRecordFinder.elements {
        case .lasts(let count):
            isLasts = count == 20
        default:
            isLasts = false
        }
        XCTAssertEqual(isLasts!, true, "LASTS not set properly")
    }
    
    func testsIfFirstsElementsIsAdded()
    {
        sugarRecordFinder = sugarRecordFinder.firsts(20)
        var isFirsts: Bool?
        switch sugarRecordFinder.elements {
        case .firsts(let count):
            isFirsts = count == 20
        default:
            isFirsts = false
        }
        XCTAssertEqual(isFirsts!, true, "LASTS not set properly")
    }
}
