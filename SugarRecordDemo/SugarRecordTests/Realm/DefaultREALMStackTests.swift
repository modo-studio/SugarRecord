//
//  DefaultREALMStackTests.swift
//  SugarRecord
//
//  Created by Pedro Piñera Buendía on 27/09/14.
//  Copyright (c) 2014 SugarRecord. All rights reserved.
//

import UIKit
import XCTest
import Realm

class DefaultREALMStackTests: XCTestCase {

    override func setUp()
    {
        super.setUp()
    }
    
    override func tearDown()
    {
        super.tearDown()
    }

    func testThatPropertiesAreSetInInit()
    {
        let stack: DefaultREALMStack = DefaultREALMStack(stackName: "name", stackDescription: "description")
        XCTAssertEqual(stack.name, "name", "The name should be set in init")
        XCTAssertEqual(stack.stackDescription, "description", "The description should be set in init")
    }
    
    func testIfReturnsTheDefaultRLMContextForTheContext()
    {
        let stack: DefaultREALMStack = DefaultREALMStack(stackName: "name", stackDescription: "description")
        XCTAssertEqual((stack.mainThreadContext() as SugarRecordRLMContext).realmContext, RLMRealm.defaultRealm(), "Default stack should return the default realm object")
    }
    
    func testIfReturnsTheDefaultRLMContextForTheContextInBAckground()
    {
        let stack: DefaultREALMStack = DefaultREALMStack(stackName: "name", stackDescription: "description")
        let expectation = expectationWithDescription("background operation")
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), { () -> Void in
            XCTAssertEqual((stack.backgroundContext() as SugarRecordRLMContext).realmContext, RLMRealm.defaultRealm(), "Default stack should return the default realm object")
            expectation.fulfill()
        })
        waitForExpectationsWithTimeout(0.2, handler: nil)
    }
    
    func testDatabaseRemoval()
    {
        let stack = DefaultREALMStack(stackName: "test", stackDescription: "test stack")
        SugarRecord.addStack(stack)
        let documentsPath: String = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let databaseName: String = documentsPath.stringByAppendingPathComponent("default.realm")
        XCTAssertTrue(NSFileManager.defaultManager().fileExistsAtPath(databaseName), "The database is not created in the right place")
        stack.removeDatabase()
        XCTAssertFalse(NSFileManager.defaultManager().fileExistsAtPath(databaseName), "The database is not created in the right place")
        SugarRecord.removeAllStacks()
    }
}
