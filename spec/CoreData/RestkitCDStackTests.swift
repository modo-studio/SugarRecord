//
//  RestkitCDStackTests.swift
//  SugarRecord
//
//  Created by Pedro Piñera Buendía on 28/09/14.
//  Copyright (c) 2014 SugarRecord. All rights reserved.
//

import Foundation
import XCTest
import CoreData

class RestkitCDStackTests: XCTestCase
{
    func testIfInitializeGetContextsFromRestkit()
    {
        class MockRKStore: RKManagedObjectStore
        {
            var addSQliteCalled: Bool = false
            var createManagedObjectContextsCalled: Bool = false
            override func addSQLitePersistentStoreAtPath(storePath: String!, fromSeedDatabaseAtPath seedPath: String!, withConfiguration nilOrConfigurationName: String!, options nilOrOptions: [NSObject : AnyObject]!) throws -> NSPersistentStore {
                addSQliteCalled = true
                return try super.addSQLitePersistentStoreAtPath(storePath, fromSeedDatabaseAtPath: seedPath, withConfiguration: nilOrConfigurationName, options: nilOrOptions)
            }
            override func createManagedObjectContexts()
            {
                super.createManagedObjectContexts()
                createManagedObjectContextsCalled = true
            }
        }
        
        class MockReskitCDStack: RestkitCDStack
        {
            var rkStore: MockRKStore?
            override func createRKManagedObjectStore() -> RKManagedObjectStore {
                rkStore = MockRKStore(managedObjectModel: self.managedObjectModel!)
                return rkStore!
            }
        }
        
        let bundle: NSBundle = NSBundle(forClass: CoreDataObjectTests.classForCoder())
        let modelPath: NSString = bundle.pathForResource("TestsDataModel", ofType: "momd")!
        let model: NSManagedObjectModel = NSManagedObjectModel(contentsOfURL: NSURL(fileURLWithPath: modelPath as String)!)!
        let stack: MockReskitCDStack = MockReskitCDStack(databaseName: "Restkit.sqlite", model: model, automigrating: true)
        stack.initialize()
        XCTAssertTrue(stack.rkStore!.addSQliteCalled, "The stack should initialize SQLite from RestKit")
        XCTAssertTrue(stack.rkStore!.createManagedObjectContextsCalled, "The stack should create contexts using RestKit")
        XCTAssertNotNil(stack.persistentStoreCoordinator, "The persistent store coordinator should be not nil")
        XCTAssertNotNil(stack.rootSavingContext, "The root saving context should be not nil")
        XCTAssertNotNil(stack.mainContext, "The main context should be not nil")
        stack.removeDatabase()
    }
}