//
//  CDArray+SugarRecordResultsTests.swift
//  project
//
//  Created by Pedro Piñera Buendía on 29/12/14.
//  Copyright (c) 2014 SugarRecord. All rights reserved.
//

import Foundation
import XCTest

class CDArraySugarRecordResultsTests: XCTestCase
{
    // Mock class
    class MockManagedObject: NSManagedObject
    {
        var customName: String = ""
        init(customName: String) {
            self.customName = customName
        }
    }
    var array: SugarRecordArray?
    
    override func setUp() {
        var objects: [MockManagedObject] = [MockManagedObject]()
        objects.append(MockManagedObject(customName: "1"))
        array = SugarRecordArray(array: objects)
    }
    
    func testCount()
    {
        let count = array!.count(finder: SugarRecordFinder())
        XCTAssertEqual(count, 1, "The number of elements should be 1")
    }
    
    func testObjectAtIndex()
    {
        let object: MockManagedObject? = array?.objectAtIndex(0, finder: SugarRecordFinder()) as? CDArraySugarRecordResultsTests.MockManagedObject
        XCTAssertEqual(object!.customName, "1", "The name should be 1")
    }
    
    func testFirstObject()
    {
        let object: MockManagedObject? = array?.firstObject(finder: SugarRecordFinder()) as? CDArraySugarRecordResultsTests.MockManagedObject
        XCTAssertEqual(object!.customName, "1", "The name should be 1")
    }
    
    func testLastObject()
    {
        let object: MockManagedObject? = array?.lastObject(finder: SugarRecordFinder()) as? CDArraySugarRecordResultsTests.MockManagedObject
        XCTAssertEqual(object!.customName, "1", "The name should be 1")
    }
}