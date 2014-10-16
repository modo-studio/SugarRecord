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
    
    //MARK: - Initialization
    
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
        let completion: CompletionClosure = mock.dataBaseAddedClosure()
        completion(error: nil)
        XCTAssertTrue(mock.createRootSavingContextCalled, "It should create the root saving context")
        XCTAssertTrue(mock.createMainContextCalled, "It should create the main context")
        XCTAssertTrue(mock.addObserversCaled, "It should add observers")
        XCTAssertTrue(mock.stackInitialized, "It should set the stack as initialized")
    }
    
    func testIfTheRootSavingContextHasTheProperPersistentStoreCoordinator()
    {
        let stack: iCloudCDStack = iCloudCDStack(databaseName: "Test.sqlite", icloudData: iCloudData(iCloudAppID: "Testid", iCloudDataDirectoryName: nil, iCloudLogsDirectory: nil))
        let psc: NSPersistentStoreCoordinator = NSPersistentStoreCoordinator()
        let rootSavingContext: NSManagedObjectContext = stack.createRootSavingContext(psc)
        XCTAssertEqual(rootSavingContext.concurrencyType, NSManagedObjectContextConcurrencyType.PrivateQueueConcurrencyType, "The concurrency type should be PrivateQueue")
        let sameMergePolicy: Bool = (rootSavingContext.mergePolicy as NSObject).isKindOfClass((NSMergeByPropertyObjectTrumpMergePolicy as NSObject).classForCoder)
        XCTAssertTrue(sameMergePolicy, "The merge policy should be by property object trump")
    }
    
    //MARK: - Observers
    
    func testIfObserversAreAddedToDetectiCloudChanges()
    {
        class MockNotificationCenter: NSNotificationCenter
        {
            var addedObserverForStoresWillChange: Bool = false
            var addedObserverForStoresDidChange: Bool = false
            var addedObserversForUbiquituousContentChanges: Bool = false
            override func addObserver(observer: AnyObject, selector aSelector: Selector, name aName: String?, object anObject: AnyObject?) {
                if (aSelector == Selector("storesWillChange:") && aName! == NSPersistentStoreCoordinatorStoresWillChangeNotification) {
                    addedObserverForStoresWillChange = true
                }
                else if (aSelector == Selector("storeDidChange:") && aName! == NSPersistentStoreCoordinatorStoresDidChangeNotification) {
                    addedObserverForStoresDidChange = true
                }
                else if (aSelector == Selector("persistentStoreDidImportUbiquitousContentChanges:") && aName! == NSPersistentStoreDidImportUbiquitousContentChangesNotification) {
                    addedObserversForUbiquituousContentChanges = true
                }
            }
        }
        
        class MockStack: iCloudCDStack
        {
            convenience init(nc: MockNotificationCenter) {
                self.init(databaseName: "Test.sqlite", icloudData: iCloudData(iCloudAppID: "Testid", iCloudDataDirectoryName: nil, iCloudLogsDirectory: nil))
                self.notificationCenter = nc
            }
        }
        let nc: MockNotificationCenter = MockNotificationCenter()
        let stack: MockStack = MockStack(nc: nc)
        stack.addObservers()
        XCTAssertTrue(nc.addedObserverForStoresDidChange, "It should add an observer to detect when the store did change")
        XCTAssertTrue(nc.addedObserverForStoresWillChange, "It should add an observer to detect when the store will change")
        XCTAssertTrue(nc.addedObserversForUbiquituousContentChanges, "It should add an observer to detect changes in the ubiquituous")
    }
    
    func testStoresWillChange()
    {
        class MockStack: iCloudCDStack
        {
            var saveChangesCalled: Bool = false
            override func saveChanges() {
                saveChangesCalled = true
            }
        }
        let mock: MockStack = MockStack(databaseName: "Test.sqlite", icloudData: iCloudData(iCloudAppID: "Testid", iCloudDataDirectoryName: nil, iCloudLogsDirectory: nil))
        mock.storesWillChange(NSNotification(name: "test", object: nil))
        XCTAssertTrue(mock.saveChangesCalled, "It should save the changes if the store is going to change")
    }
    
    func testIfChangesAreBroughtIfUbiquituousChanges()
    {
        class MockContext: NSManagedObjectContext {
            var changesMerged: Bool = false
            override func mergeChangesFromContextDidSaveNotification(notification: NSNotification) {
                changesMerged = true
            }
            override func performBlock(block: () -> Void) {
                block()
            }
        }
        
        class MockStack: iCloudCDStack
        {
            convenience init(mainContext: MockContext, rootSavingContext: MockContext) {
                self.init(databaseName: "Test.sqlite", icloudData: iCloudData(iCloudAppID: "Testid", iCloudDataDirectoryName: nil, iCloudLogsDirectory: nil))
                self.rootSavingContext = rootSavingContext
                self.mainContext = mainContext
            }
        }
        
        let mainContext: MockContext = MockContext()
        let rootContext: MockContext = MockContext()
        let mock: MockStack = MockStack(mainContext: mainContext, rootSavingContext: rootContext)
        mock.persistentStoreDidImportUbiquitousContentChanges(NSNotification(name: "test", object: nil))
        XCTAssertTrue(mainContext.changesMerged, "Changes in iCloud should be persisted to the main context")
        XCTAssertTrue(rootContext.changesMerged, "Changes in iCloud should be persisted to the root context")
    }
}
