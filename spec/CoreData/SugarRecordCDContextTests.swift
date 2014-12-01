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
        let model: NSManagedObjectModel = NSManagedObjectModel(contentsOfURL: NSURL(fileURLWithPath: modelPath)!)!
        let stack: DefaultCDStack = DefaultCDStack(databaseName: "TestDB.sqlite", model: model, automigrating: true)
        SugarRecord.addStack(stack)
    }
    
    override func tearDown() {
        SugarRecord.cleanup()
        SugarRecord.removeDatabase()
        super.tearDown()
    }
    
    
    func testThatEndWritingCallSavesTheContext()
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
        sugarRecordContext.endWriting()
        XCTAssertTrue(mockContext.contextSaved, "EndWriting in SugarRecord context should call save in CD context")
    }
    
    func testIfCancelWritingCancelChangesInTheCoreDataContext()
    {
        class MockCoreDataContext: NSManagedObjectContext
        {
            var rollBackCalled: Bool = false
            private override func rollback() {
                rollBackCalled = true
            }
        }
        let mockContext = MockCoreDataContext()
        let sugarRecordContext: SugarRecordCDContext = SugarRecordCDContext(context: mockContext)
        sugarRecordContext.cancelWriting()
        XCTAssertTrue(mockContext.rollBackCalled, "CancelWriting in SugarRecord context should call rollback in CD context")
    }
    
    func testThatCreateObjectsDoesItInTheProperContext()
    {
        SugarRecord.operation(SugarRecordStackType.SugarRecordStackTypeCoreData, closure: { (context) -> () in
            let object: CoreDataObject = context.createObject(CoreDataObject.self) as CoreDataObject
            XCTAssertEqual(object.managedObjectContext!, (context as SugarRecordCDContext).contextCD, "Returned object should be in the passed context")
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
    
    func testFetchRequestGenerationFromFinder()
    {
        var sortDescriptor: NSSortDescriptor = NSSortDescriptor(key: "test", ascending: true)
        var sortDescriptor2: NSSortDescriptor = NSSortDescriptor(key: "test2", ascending: true)
        let predicate: NSPredicate = NSPredicate()
        var finder: SugarRecordFinder = SugarRecordFinder()
        finder.addSortDescriptor(sortDescriptor)
        finder.addSortDescriptor(sortDescriptor2)
        finder.setPredicate(predicate)
        finder.elements = SugarRecordFinderElements.all
        finder.objectClass = CoreDataObject.self
        var fetchRequest: NSFetchRequest = SugarRecordCDContext.fetchRequest(fromFinder: finder)
        XCTAssertEqual(fetchRequest.predicate!, predicate, "The predicate should be the same")
        XCTAssertEqual((fetchRequest.sortDescriptors!.first! as NSSortDescriptor).key!, (finder.sortDescriptors.first! as NSSortDescriptor).key!, "The sort descriptors should be the same")
        XCTAssertEqual(fetchRequest.entityName!, CoreDataObject.entityName(), "The entity name should be the same")
        finder.elements = SugarRecordFinderElements.first
        fetchRequest = SugarRecordCDContext.fetchRequest(fromFinder: finder)
        XCTAssertEqual(fetchRequest.predicate!, predicate, "The predicate should be the same")
        XCTAssertEqual((fetchRequest.sortDescriptors!.first! as NSSortDescriptor).key!, (finder.sortDescriptors.first! as NSSortDescriptor).key!, "The sort descriptors should be the same")
        XCTAssertEqual(fetchRequest.entityName!, CoreDataObject.entityName(), "The entity name should be the same")
        XCTAssertEqual(fetchRequest.fetchLimit, 1, "The fetch limit should be 1")
        finder.elements = SugarRecordFinderElements.firsts(20)
        fetchRequest = SugarRecordCDContext.fetchRequest(fromFinder: finder)
        XCTAssertEqual(fetchRequest.predicate!, predicate, "The predicate should be the same")
        XCTAssertEqual((fetchRequest.sortDescriptors!.first! as NSSortDescriptor).key!, (finder.sortDescriptors.first! as NSSortDescriptor).key!, "The sort descriptors should be the same")
        XCTAssertEqual(fetchRequest.entityName!, CoreDataObject.entityName(), "The entity name should be the same")
        XCTAssertEqual(fetchRequest.fetchLimit, 20, "The fetch limit should be 20")
        finder.elements = SugarRecordFinderElements.last
        fetchRequest = SugarRecordCDContext.fetchRequest(fromFinder: finder)
        XCTAssertEqual(fetchRequest.predicate!, predicate, "The predicate should be the same")
        XCTAssertNotEqual((fetchRequest.sortDescriptors!.first! as NSSortDescriptor).ascending, (finder.sortDescriptors.first! as NSSortDescriptor).ascending, "The sort descriptors shouldn't be the same")
        XCTAssertEqual(fetchRequest.entityName!, CoreDataObject.entityName(), "The entity name should be the same")
        XCTAssertEqual(fetchRequest.fetchLimit, 1, "The fetch limit should be 1")
        finder.elements = SugarRecordFinderElements.lasts(20)
        fetchRequest = SugarRecordCDContext.fetchRequest(fromFinder: finder)
        XCTAssertEqual(fetchRequest.predicate!, predicate, "The predicate should be the same")
        XCTAssertNotEqual((fetchRequest.sortDescriptors!.first! as NSSortDescriptor).ascending, (finder.sortDescriptors.first! as NSSortDescriptor).ascending, "The sort descriptors shouldn't be the same")
        XCTAssertEqual(fetchRequest.entityName!, CoreDataObject.entityName(), "The entity name should be the same")
        XCTAssertEqual(fetchRequest.fetchLimit, 20, "The fetch limit should be 20")
    }
}