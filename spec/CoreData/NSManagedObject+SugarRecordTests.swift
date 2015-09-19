//
//  NSManagedObject+SugarRecordTests.swift
//  SugarRecord
//
//  Created by Pedro Piñera Buendia on 07/09/14.
//  Copyright (c) 2014 SugarRecord. All rights reserved.
//

import Foundation
import CoreData
import XCTest

@available(iOS 8.0, *)
class NSManagedObjectSugarRecordTests: XCTestCase
{
    override func setUp()
    {
        super.setUp()
        let bundle: NSBundle = NSBundle(forClass: CoreDataObjectTests.classForCoder())
        let modelPath: NSString = bundle.pathForResource("TestsDataModel", ofType: "momd")!
        let model: NSManagedObjectModel = NSManagedObjectModel(contentsOfURL: NSURL(fileURLWithPath: modelPath as String))!
        if #available(iOS 8.0, *) {
            let stack: DefaultCDStack = DefaultCDStack(databaseName: "TestDB.sqlite", model: model, automigrating: true)
            SugarRecord.addStack(stack)
        }
    }
    override func tearDown()
    {
        SugarRecord.cleanup()
        SugarRecord.removeDatabase()
        SugarRecord.removeAllStacks()
        super.tearDown()
    }
    
    func testIfTheSugarRecordCDMatchesTheObjectContext()
    {
        let object: CoreDataObject = CoreDataObject.create() as! CoreDataObject
        let context: SugarRecordCDContext = object.context() as! SugarRecordCDContext
        XCTAssertEqual(context.contextCD, object.managedObjectContext!, "SugarRecord context should have the object context")
    }
    
    func testIfReturnsTheEntityNameWithoutNamespace()
    {
        XCTAssertEqual(CoreDataObject.modelName(), "CoreDataObject", "The entity name shouldn't include the namespace")
    }
    
    func testIfTheFinderReturnsTheProperStackType()
    {
        let sameClass: Bool = CoreDataObject.stackType() == SugarRecordEngine.SugarRecordEngineCoreData
        XCTAssertEqual(sameClass, true, "The stack type should be SugarRecordEngineCoreData")
    }
    
    func testIfTheReturnedFinderIsRight()
    {
        let predicate: NSPredicate = NSPredicate()
        var finder: SugarRecordFinder = NSManagedObject.by(predicate)
        XCTAssertEqual(finder.predicate!, predicate, "The finder predicate should be the one passed to the object class using by")
        finder = NSManagedObject.by("name == Test")
        XCTAssertEqual(finder.predicate!.predicateFormat, "name == Test", "The finder predicate format should be the same as the passed to the object class using predicateString")
        finder = NSManagedObject.by("name", equalTo: "Test")
        XCTAssertEqual(finder.predicate!.predicateFormat, "name == \"Test\"", "The finder predicate format should be the same as the passed to the object class using key-value")
    }
    
    func testIfTheObjectClassAndStackTypeAreSetToTheFinderWhenFiltering()
    {
        let predicate: NSPredicate = NSPredicate()
        var finder: SugarRecordFinder = CoreDataObject.by(predicate)
        var sameClass = finder.objectClass is NSManagedObject.Type
        XCTAssertTrue(sameClass, "The class of the finder should be the object class")
        XCTAssertTrue(finder.stackType == SugarRecordEngine.SugarRecordEngineCoreData, "The stack type should be the CoreData one")
        finder = NSManagedObject.by("name == Test")
        sameClass = finder.objectClass is NSManagedObject.Type
        XCTAssertTrue(sameClass, "The class of the finder should be the object class")
        XCTAssertTrue(finder.stackType == SugarRecordEngine.SugarRecordEngineCoreData, "The stack type should be the CoreData one")
        finder = NSManagedObject.by("name", equalTo: "Test")
        sameClass = finder.objectClass is NSManagedObject.Type
        XCTAssertTrue(sameClass, "The class of the finder should be the object class")
        XCTAssertTrue(finder.stackType == SugarRecordEngine.SugarRecordEngineCoreData, "The stack type should be the CoreData one")
    }
    
    func testIfTheSortDescriptorsAreProperlySetToTheFinder()
    {
        let sortDescriptor: NSSortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        var finder: SugarRecordFinder = NSManagedObject.sorted(by: sortDescriptor)
        XCTAssertEqual(finder.sortDescriptors.last!, sortDescriptor, "Sort descriptor should be added to the stack of the finder")
        finder = NSManagedObject.sorted(by: "name", ascending: true)
        XCTAssertEqual(finder.sortDescriptors.last!.key!, "name", "The key of the last sortDescriptor should match the last added's key")
        XCTAssertTrue(finder.sortDescriptors.last!.ascending, "The ascending of the last sortDescriptor should match the last added's key")
        finder = NSManagedObject.sorted(by: [sortDescriptor])
        XCTAssertEqual(finder.sortDescriptors, [sortDescriptor], "The sort descriptor should be added to the stack")
    }
    
    func testIfTheObjectClassAndStackTypeAreProperlySetWhenSorting()
    {
        
        let sortDescriptor: NSSortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        var finder: SugarRecordFinder = NSManagedObject.sorted(by: sortDescriptor)
        var sameClass = finder.objectClass is NSManagedObject.Type
        XCTAssertTrue(sameClass, "The objectClass of the finder should be the same of the object")
        XCTAssertTrue(finder.stackType == SugarRecordEngine.SugarRecordEngineCoreData, "The stack type should be the CoreData one")
        finder = NSManagedObject.sorted(by: "name", ascending: true)
        sameClass = finder.objectClass is NSManagedObject.Type
        XCTAssertTrue(sameClass, "The objectClass of the finder should be the same of the object")
        XCTAssertTrue(finder.stackType == SugarRecordEngine.SugarRecordEngineCoreData, "The stack type should be the CoreData one")
        finder = NSManagedObject.sorted(by: [sortDescriptor])
        sameClass = finder.objectClass is NSManagedObject.Type
        XCTAssertTrue(sameClass, "The objectClass of the finder should be the same of the object")
        XCTAssertTrue(finder.stackType == SugarRecordEngine.SugarRecordEngineCoreData, "The stack type should be the CoreData one")
    }
    
    func testIfAllIsProperlySetToTheFinder()
    {
        let finder: SugarRecordFinder = NSManagedObject.all()
        var isAll: Bool?
        switch finder.elements {
        case .all:
            isAll = true
        default:
            isAll = false
        }
        XCTAssertTrue(isAll!, "Elements of the finder should be ALL")
    }
    
    func testIfDeletePropagatesTheDeletionCallToTheContext()
    {
        // Cannot be applied yet because we cannot extend extension methods
    }
    
    func testIfCreationPropagatesTheCallUsingOperations()
    {
        // Cannot be applied yet because we cannot extend extension methods
    }
    
    func testIfSaveCallsSaveSynchronously()
    {
        // Cannot be applied yet because we cannot extend extension methods
    }
    
    func testSave()
    {
        // Cannot be applied yet because we cannot extend extension methods
    }
}
