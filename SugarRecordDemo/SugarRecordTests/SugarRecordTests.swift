//
//  SugarRecordTests.swift
//  SugarRecordTests
//
//  Created by Pedro Piñera Buendía on 03/08/14.
//  Copyright (c) 2014 PPinera. All rights reserved.
//

import UIKit
import XCTest
import SugarRecord

class SugarRecordSetupTests: XCTestCase {
    var sugarRecord: SugarRecord?
    
    override func setUp() {
        super.setUp()
        sugarRecord = SugarRecord()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    
    
    
    func testExample() {
        // This is an example of a functional test case.
        XCTAssert(true, "Pass")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
}
