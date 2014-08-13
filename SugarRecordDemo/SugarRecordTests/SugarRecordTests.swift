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
    
    func testSingletonInstance() {
        XCTAssertNotNil(SugarRecord.sharedInstance, "Sugar record shared instance should not be nil")
    }
    
    func testSetupCoreDataStackIfCoordinatorExisting() {
    
    }

}
