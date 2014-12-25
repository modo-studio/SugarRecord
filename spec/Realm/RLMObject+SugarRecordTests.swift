//
//  RLMObject+SugarRecordTests.swift
//  SugarRecord
//
//  Created by Pedro Piñera Buendia on 07/09/14.
//  Copyright (c) 2014 SugarRecord. All rights reserved.
//

import Foundation
import CoreData
import Realm
import XCTest

class RLMObjectSugarRecordTests: XCTestCase
{
    override func setUp()
    {
        super.setUp()
        SugarRecord.addStack(DefaultREALMStack(stackName: "RealmTest", stackDescription: "Realm stack for tests"))
    }
    
    override func tearDown() {
        SugarRecord.cleanup()
        SugarRecord.removeDatabase()
        super.tearDown()
    }
    
    func testIfTheSugarRecordRealmMatchesTheObjectContext()
    {
        let object: RealmObject = RealmObject.create() as RealmObject
        object.save()
        let context: SugarRecordRLMContext = object.context() as SugarRecordRLMContext
        XCTAssertEqual(context.realmContext, object.realm, "SugarRecord context should have the object context")
    }
    
    func testIfReturnsTheEntityNameWithoutNamespace()
    {
        XCTAssertEqual(RealmObject.modelName(), "RealmObject", "The entity name shouldn't include the namespace")
    }
    
    func testIfTheFinderReturnsTheProperStackType()
    {
        let sameClass: Bool = RealmObject.stackType() == SugarRecordEngine.SugarRecordEngineRealm
        XCTAssertEqual(sameClass, true, "The stack type should be SugarRecordEngineRealm")
    }

    func testIfTheReturnedFinderIsRight()
    {
        var predicate: NSPredicate = NSPredicate()
        var finder: SugarRecordFinder = RealmObject.by(predicate)
        XCTAssertEqual(finder.predicate!, predicate, "The finder predicate should be the one passed to the object class using by")
        finder = RealmObject.by("name == Test")
        XCTAssertEqual(finder.predicate!.predicateFormat, "name == Test", "The finder predicate format should be the same as the passed to the object class using predicateString")
        finder = RealmObject.by("name", equalTo: "Test")
        XCTAssertEqual(finder.predicate!.predicateFormat, "name == Test", "The finder predicate format should be the same as the passed to the object class using key-value")
    }
    
    func testIfTheObjectClassAndStackTypeAreSetToTheFinderWhenFiltering()
    {
        var predicate: NSPredicate = NSPredicate()
        var finder: SugarRecordFinder = RealmObject.by(predicate)
        var sameClass = finder.objectClass? is RealmObject.Type
        XCTAssertTrue(sameClass, "The class of the finder should be the object class")
        XCTAssertTrue(finder.stackType == SugarRecordEngine.SugarRecordEngineRealm, "The stack type should be the CoreData one")
        finder = RealmObject.by("name == Test")
        sameClass = finder.objectClass? is RealmObject.Type
        XCTAssertTrue(sameClass, "The class of the finder should be the object class")
        XCTAssertTrue(finder.stackType == SugarRecordEngine.SugarRecordEngineRealm, "The stack type should be the CoreData one")
        finder = RealmObject.by("name", equalTo: "Test")
        sameClass = finder.objectClass? is RealmObject.Type
        XCTAssertTrue(sameClass, "The class of the finder should be the object class")
        XCTAssertTrue(finder.stackType == SugarRecordEngine.SugarRecordEngineRealm, "The stack type should be the CoreData one")
    }
    
    func testIfTheSortDescriptorsAreProperlySetToTheFinder()
    {
        var sortDescriptor: NSSortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        var finder: SugarRecordFinder = RealmObject.sorted(by: sortDescriptor)
        XCTAssertEqual(finder.sortDescriptors.last!, sortDescriptor, "Sort descriptor should be added to the stack of the finder")
        finder = RealmObject.sorted(by: "name", ascending: true)
        XCTAssertEqual(finder.sortDescriptors.last!.key!, "name", "The key of the last sortDescriptor should match the last added's key")
        XCTAssertTrue(finder.sortDescriptors.last!.ascending, "The ascending of the last sortDescriptor should match the last added's key")
        finder = RealmObject.sorted(by: [sortDescriptor])
        XCTAssertEqual(finder.sortDescriptors, [sortDescriptor], "The sort descriptor should be added to the stack")
    }
    
    func testIfTheObjectClassAndStackTypeAreProperlySetWhenSorting()
    {
        var sortDescriptor: NSSortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        var finder: SugarRecordFinder = RealmObject.sorted(by: sortDescriptor)
        var sameClass = finder.objectClass? is RealmObject.Type
        XCTAssertTrue(sameClass, "The objectClass of the finder should be the same of the object")
        XCTAssertTrue(finder.stackType == SugarRecordEngine.SugarRecordEngineRealm, "The stack type should be the CoreData one")
        finder = RealmObject.sorted(by: "name", ascending: true)
        sameClass = finder.objectClass? is RealmObject.Type
        XCTAssertTrue(sameClass, "The objectClass of the finder should be the same of the object")
        XCTAssertTrue(finder.stackType == SugarRecordEngine.SugarRecordEngineRealm, "The stack type should be the CoreData one")
        finder = RealmObject.sorted(by: [sortDescriptor])
        sameClass = finder.objectClass? is RealmObject.Type
        XCTAssertTrue(sameClass, "The objectClass of the finder should be the same of the object")
        XCTAssertTrue(finder.stackType == SugarRecordEngine.SugarRecordEngineRealm, "The stack type should be the CoreData one")
    }
    
    func testIfAllIsProperlySetToTheFinder()
    {
        var finder: SugarRecordFinder = NSManagedObject.all()
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
