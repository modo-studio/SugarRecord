//
//  SugarRecordTests.swift
//  SugarRecord
//
//  Created by Pedro Piñera Buendía on 27/09/14.
//  Copyright (c) 2014 SugarRecord. All rights reserved.
//

import UIKit
import XCTest

class SugarRecordTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testIfAddsTheStacksProperly()
    {
        let realm1: DefaultREALMStack = DefaultREALMStack(stackName: "REALM1", stackDescription: "Description")
        let realm2: DefaultREALMStack = DefaultREALMStack(stackName: "REALM2", stackDescription: "Description")
        SugarRecord.addStack(realm1)
        SugarRecord.addStack(realm2)
        XCTAssertEqual(SugarRecord.stacks().count, 2, "The number of stacks should be 2")
        SugarRecord.removeAllStacks()
    }
    
    func testIfStacksAreRemovedProperly()
    {
        let realm1: DefaultREALMStack = DefaultREALMStack(stackName: "REALM1", stackDescription: "Description")
        let realm2: DefaultREALMStack = DefaultREALMStack(stackName: "REALM2", stackDescription: "Description")
        SugarRecord.addStack(realm1)
        SugarRecord.addStack(realm2)
        SugarRecord.removeAllStacks()
        XCTAssertEqual(SugarRecord.stacks().count, 0, "The number of stacks should be 0")
    }
    
    func testIfReturnsTheProperStackForCoreDataType()
    {
        let realmStack: DefaultREALMStack = DefaultREALMStack(stackName: "Realm", stackDescription: "Description")
        let coreDataStack: DefaultCDStack = DefaultCDStack(databaseName: "CoreData", automigrating: true)
        SugarRecord.addStack(realmStack)
        SugarRecord.addStack(coreDataStack)
        XCTAssertNotNil(SugarRecord.stackFortype(SugarRecordEngine.SugarRecordEngineCoreData) as DefaultCDStack, "Should return a stack for CoreData")
        XCTAssertNotNil(SugarRecord.stackFortype(SugarRecordEngine.SugarRecordEngineRealm) as DefaultREALMStack, "Should return a stack for CoreData")
        SugarRecord.removeAllStacks()
    }
    
    func testThatApplicationWillResignActiveIsCalledInStacks()
    {
        class MockStack: DefaultREALMStack
        {
            var applicationWillResignActiveCalled: Bool = false
            override func applicationWillResignActive() {
                applicationWillResignActiveCalled = true
            }
        }
        let realmStack: MockStack = MockStack(stackName: "Realm", stackDescription: "Description")
        SugarRecord.addStack(realmStack)
        SugarRecord.applicationWillResignActive()
        XCTAssertTrue(realmStack.applicationWillResignActiveCalled, "SugarRecord should call applicationWillResignActive in stacks")
        SugarRecord.removeAllStacks()
    }
    
    func testThatApplicationWillTerminateIsCalledInStacks()
    {
        class MockStack: DefaultREALMStack
        {
            var applicationWillTerminateCalled: Bool = false
            override func applicationWillTerminate() {
                applicationWillTerminateCalled = true
            }
        }
        let realmStack: MockStack = MockStack(stackName: "Realm", stackDescription: "Description")
        SugarRecord.addStack(realmStack)
        SugarRecord.applicationWillTerminate()
        XCTAssertTrue(realmStack.applicationWillTerminateCalled, "SugarRecord should call applicationWillTerminate in stacks")
        SugarRecord.removeAllStacks()
    }
    
    
    func testThatApplicationWillEnterForegroundIsCalledInStacks()
    {
        class MockStack: DefaultREALMStack
        {
            var applicationWillEnterForegroundCalled: Bool = false
            override func applicationWillEnterForeground() {
                applicationWillEnterForegroundCalled = true
            }
        }
        let realmStack: MockStack = MockStack(stackName: "Realm", stackDescription: "Description")
        SugarRecord.addStack(realmStack)
        SugarRecord.applicationWillEnterForeground()
        XCTAssertTrue(realmStack.applicationWillEnterForegroundCalled, "SugarRecord should call applicationWillEnterForeground in stacks")
        SugarRecord.removeAllStacks()
    }
    
    func testThatRemoveDatabaseIsCalledInStacks()
    {
        class MockStack: DefaultREALMStack
        {
            var removeDatabaseCalled: Bool = false
            override func removeDatabase() {
                removeDatabaseCalled = true
            }
        }
        let realmStack: MockStack = MockStack(stackName: "Realm", stackDescription: "Description")
        SugarRecord.addStack(realmStack)
        SugarRecord.removeDatabase()
        XCTAssertTrue(realmStack.removeDatabaseCalled, "SugarRecord should call removeDatabase in stacks")
        SugarRecord.removeAllStacks()
    }
    
    func testThatStacksAreCleanedAfterDatabaseRemoval()
    {
        class MockSugarRecord: SugarRecord
        {
            private struct StaticVars
            {
                static var removeStacksCalled: Bool = false
            }
            override class func removeAllStacks()
            {
                StaticVars.removeStacksCalled = true
            }
            class func removeStacksCalled() -> Bool
            {
                return StaticVars.removeStacksCalled
            }
        }
        MockSugarRecord.removeDatabase()
        XCTAssertTrue(MockSugarRecord.removeStacksCalled(), "Remove stacks should be called when the database is removed")
    }
    
    func testIfOperationIsExecutedInMainThread()
    {
        class MockSugarRecord: SugarRecord
        {
            private struct StaticVars
            {
                static var operationCalled: Bool = false
                static var operationCalledInBackground: Bool = false
            }
            override class func operation(inBackground background: Bool, stackType: SugarRecordEngine, closure: (context: SugarRecordContext) -> ())
            {
                StaticVars.operationCalled = true
                StaticVars.operationCalledInBackground = background
            }
            class func operationCalled() -> Bool
            {
                return StaticVars.operationCalled
            }
            class func operationCalledInBackground() -> Bool
            {
                return StaticVars.operationCalledInBackground
            }
        }
        MockSugarRecord.operation(SugarRecordEngine.SugarRecordEngineCoreData, closure: { (context) -> () in})
        XCTAssertTrue(MockSugarRecord.operationCalled(), "Main operation method should be called")
        XCTAssertFalse(MockSugarRecord.operationCalledInBackground(), "Operation method should be called in the main thread")
    }
    
    func testThatTheClosureIsCalledPassingTheRightContextInMainThread()
    {
        let realmStack: DefaultREALMStack = DefaultREALMStack(stackName: "Realm", stackDescription: "Description")
        SugarRecord.addStack(realmStack)
        var sameContextUsed: Bool = false
        var calledInMainThread: Bool = false
        let expectation = expectationWithDescription("Operation")
        SugarRecord.operation(SugarRecordEngine.SugarRecordEngineRealm, closure: { (context) -> () in
            expectation.fulfill()
            calledInMainThread = NSThread.isMainThread()
        })
        XCTAssertTrue(calledInMainThread, "Operation should be executed in main thread")
        SugarRecord.removeAllStacks()
        waitForExpectationsWithTimeout(0.2, handler: nil)
    }
    
    func testThatTheClosureIsCalledPassingTheRightContextInBackgroundThread()
    {
        let realmStack: DefaultREALMStack = DefaultREALMStack(stackName: "Realm", stackDescription: "Description")
        SugarRecord.addStack(realmStack)
        var sameContextUsed: Bool = false
        let expectation = expectationWithDescription("Background operation")
        SugarRecord.operation(inBackground: true, stackType: SugarRecordEngine.SugarRecordEngineRealm) { (context) -> () in
            expectation.fulfill()
            XCTAssertFalse(NSThread.isMainThread(), "Operation should be executed in main thread")
            SugarRecord.removeAllStacks()
        }
        waitForExpectationsWithTimeout(0.2, handler: nil)
    }
}
