//
//  SugarRecordCDContextTests.swift
//  SugarRecord
//
//  Created by Pedro Piñera Buendía on 11/09/14.
//  Copyright (c) 2014 SugarRecord. All rights reserved.
//

import Foundation
import XCTest
import CoreData

class SugarRecordCDContextTests: XCTestCase
{
    override func setUp()
    {
        super.setUp()
        let bundle: NSBundle = NSBundle(forClass: CoreDataObjectTests.classForCoder())
        let modelPath: NSString = bundle.pathForResource("SugarRecord", ofType: "momd")!
        let model: NSManagedObjectModel = NSManagedObjectModel(contentsOfURL: NSURL(fileURLWithPath: modelPath))
        let stack: DefaultCDStack = DefaultCDStack(databaseName: "TestDB.sqlite", model: model, automigrating: true)
        SugarRecord.addStack(stack)
    }
    
    override func tearDown() {
        SugarRecord.cleanup()
        SugarRecord.removeDatabase()
        super.tearDown()
    }
    
    
    func testThatEndWrittingCallSavesTheContext()
    {
        // ManagedObjectContext Mock
        class MockCoreDataContext: NSManagedObjectContext
        {
            var contextSaved: Bool = false
            override func save(error: NSErrorPointer) -> Bool {
                contextSaved = true
                return true
            }
        }
        let mockContext = MockCoreDataContext()
        let sugarRecordContext: SugarRecordCDContext = SugarRecordCDContext(context: mockContext)
        sugarRecordContext.endWritting()
        XCTAssertTrue(mockContext.contextSaved, "EndWritting in SugarRecord context should call save in CD context")
    }
    
    func testThatCreateObjectsDoesItInTheProperContext()
    {
        SugarRecord.operation(SugarRecordStackType.SugarRecordStackTypeCoreData, closure: { (context) -> () in
            let object: CoreDataObject = context.createObject(CoreDataObject.self) as CoreDataObject
            XCTAssertEqual(object.managedObjectContext, (context as SugarRecordCDContext).contextCD, "Returned object should be in the passed context")
        })
    }
    
    func testDeleteObjectsShouldCallDeleteObjectForEachObject()
    {
        class MockCDContext: SugarRecordCDContext
        {
            var deleteObjectCalled: Bool = false
            override func deleteObject(object: AnyObject) -> SugarRecordContext {
                deleteObjectCalled = true
                return self
            }
        }
        
        let context: MockCDContext = MockCDContext(context: NSManagedObjectContext())
        context.deleteObjects(["object"])
        XCTAssertTrue(context.deleteObjectCalled, "Delete object should be called when deleting multiple objects")
    }
}