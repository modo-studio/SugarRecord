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
    
    func testIfInitializeTriesToMigrateIfNeeded()
    {
        class MockRealmStack: DefaultREALMStack {
            var migrateIfNeededCalled: Bool = false
            override func migrateIfNeeded() {
                self.migrateIfNeededCalled = true
            }
        }
        let mockRealmStack: MockRealmStack = MockRealmStack(stackName: "Mock Stack", stackDescription: "Stack description")
        mockRealmStack.initialize()
        XCTAssertTrue(mockRealmStack.migrateIfNeededCalled, "Migration checking should be done in when initializing")
    }
    
    func testIfMigrationsAreProperlySorted() {
        var migrations: [RLMObjectMigration<RLMObject>] = [RLMObjectMigration<RLMObject>]()
        migrations.append(RLMObjectMigration<RLMObject>(toSchema: 13, migrationClosure: { (oldObject, newObject) -> () in }))
        migrations.append(RLMObjectMigration<RLMObject>(toSchema: 3, migrationClosure: { (oldObject, newObject) -> () in }))
        migrations.append(RLMObjectMigration<RLMObject>(toSchema: 1, migrationClosure: { (oldObject, newObject) -> () in }))
        var sortedMigrations: [RLMObjectMigration<RLMObject>] = DefaultREALMStack.sorted(migrations: migrations, fromOldSchema: 2)
        XCTAssertEqual(sortedMigrations.first!.toSchema, 3, "First migration in the array should have toSchema = 3")
        XCTAssertEqual(sortedMigrations.last!.toSchema, 13, "First migration in the array should have toSchema = 13")
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
