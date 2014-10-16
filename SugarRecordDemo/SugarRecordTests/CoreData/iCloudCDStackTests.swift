//
//  iCloudCDStack.swift
//  SugarRecord
//
//  Created by Pedro Piñera Buendía on 14/10/14.
//  Copyright (c) 2014 SugarRecord. All rights reserved.
//

import UIKit
import XCTest

class iCloudCDStackTests: XCTestCase {
    
    func testStackComponentsAreInitialized()
    {
        class MockStack: iCloudCDStack {
            var createManagedObjecModelIfNeededCalled: Bool = false
            var createPersistentStoreCoordinatorCalled: Bool = false
            var addDatabaseCompletionClosureCalled: Bool = false
            override func createManagedObjecModelIfNeeded() {
                createManagedObjecModelIfNeededCalled = true
            }
            override func createPersistentStoreCoordinator() -> NSPersistentStoreCoordinator {
                createPersistentStoreCoordinatorCalled = true
                return NSPersistentStoreCoordinator()
            }
            override func addDatabase(foriCloud icloud: Bool, completionClosure: CompletionClosure) {
                completionClosure(error: nil)
            }
            override func dataBaseAddedClosure() -> CompletionClosure {
                return { [weak self] (error) -> () in
                    self!.addDatabaseCompletionClosureCalled = true
                }
            }
        }
        
        let mock: MockStack = MockStack(databaseName: "Test.sqlite", icloudData: iCloudData(iCloudAppID: "Testid", iCloudDataDirectoryName: nil, iCloudLogsDirectory: nil))
        mock.initialize()
        XCTAssertTrue(mock.createManagedObjecModelIfNeededCalled, "It should initialize object model")
        XCTAssertTrue(mock.createPersistentStoreCoordinatorCalled, "It should initialize the persistent store coordinator")
        XCTAssertTrue(mock.addDatabaseCompletionClosureCalled, "It should execute a completion once the database is added")
    }
    
    func testThatContextsAreCreatedOnceDatabaseIsAdded()
    {
        class MockStack: iCloudCDStack {
            var createRootSavingContextCalled: Bool = false
            var createMainContextCalled: Bool = false
            var addObserversCaled: Bool = false
            override func createRootSavingContext(persistentStoreCoordinator: NSPersistentStoreCoordinator?) -> NSManagedObjectContext {
                createRootSavingContextCalled = true
                return NSManagedObjectContext()
            }
            override func createMainContext(parentContext: NSManagedObjectContext?) -> NSManagedObjectContext {
                createMainContextCalled = true
                return NSManagedObjectContext()
            }
            override func addObservers() {
                addObserversCaled = true
            }
        }
        let mock: MockStack = MockStack(databaseName: "Test.sqlite", icloudData: iCloudData(iCloudAppID: "Testid", iCloudDataDirectoryName: nil, iCloudLogsDirectory: nil))
        //let completionClosure: (error: NSError?)
    
    }
}
