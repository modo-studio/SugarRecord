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
import CoreData

class SugarRecordSetupTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testSingletonInstance() {
        //XCTAssertNotNil(SugarRecord.sharedInstance, "Sugar record shared instance should not be nil")
    }
    
    func testSetupStoreCoordinatorIfNotExisting() {
        //SugarRecord.setupCoreDataStack(false, databaseName: "testDatabase")
        //XCTAssertNotNil(NSPersistentStoreCoordinator.defaultPersistentStoreCoordinator(), "Default persistent store coordinator should be not nil after the initial setup")
    }
}

