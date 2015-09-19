//
//  CoreDataObjectTests.swift
//  SugarRecord
//
//  Created by Pedro Piñera Buendía on 20/09/14.
//  Copyright (c) 2014 SugarRecord. All rights reserved.
//

import XCTest
import CoreData
import Realm

@available(iOS 8.0, *)
class CoreDataObjectTests: XCTestCase
{
    override func setUp()
    {
        super.setUp()
        let bundle: NSBundle = NSBundle(forClass: CoreDataObjectTests.classForCoder())
        let modelPath: NSString = bundle.pathForResource("TestsDataModel", ofType: "momd")!
        let model: NSManagedObjectModel = NSManagedObjectModel(contentsOfURL: NSURL(fileURLWithPath: modelPath as String))!
        let stack: DefaultCDStack = DefaultCDStack(databaseName: "TestDB.sqlite", model: model, automigrating: true)
        SugarRecord.addStack(stack)
    }
    
    override func tearDown() {
        SugarRecord.cleanup()
        SugarRecord.removeDatabase()
        super.tearDown()
    }
    
    func testObjectCreation()
    {
        var coreDataObject: CoreDataObject = CoreDataObject.create() as! CoreDataObject
        coreDataObject.name = "Testy"
        coreDataObject.age = 21
        coreDataObject.email = "test@test.com"
        coreDataObject.birth = NSDate()
        coreDataObject.city = "Springfield"
        let saved: Bool = coreDataObject.save()
        var coreDataObject2: CoreDataObject = CoreDataObject.create() as! CoreDataObject
        coreDataObject2.name = "Testy2"
        coreDataObject2.age = 22
        coreDataObject2.email = "test2@test.com"
        coreDataObject2.birth = NSDate()
        coreDataObject2.city = "Springfield"
        let saved2: Bool = coreDataObject2.save()
        XCTAssertEqual(CoreDataObject.all().find().count, 2, "The number of objects fetched should be equal to 2")        
        coreDataObject.beginWriting().delete().endWriting()
        coreDataObject2.beginWriting().delete().endWriting()
    }
    
    func testObjectDeletion()
    {
        var coreDataObject: CoreDataObject = CoreDataObject.create() as! CoreDataObject
        coreDataObject.name = "Realmy"
        coreDataObject.age = 22
        coreDataObject.email = "test@mail.com"
        coreDataObject.city = "TestCity"
        coreDataObject.birth = NSDate()
        let saved: Bool = coreDataObject.save()
        coreDataObject.beginWriting().delete().endWriting()
        XCTAssertEqual(CoreDataObject.all().find().count, 0, "The number of objects fetched after the deletion should be equal to 0")
    }
    
    func testAllObjectsDeletion()
    {
        var coreDataObject: CoreDataObject = CoreDataObject.create() as! CoreDataObject
        coreDataObject.name = "Realmy"
        coreDataObject.age = 22
        coreDataObject.email = "test@mail.com"
        coreDataObject.city = "TestCity"
        coreDataObject.birth = NSDate()
        let saved: Bool = coreDataObject.save()
        var coreDataObject2: CoreDataObject = CoreDataObject.create() as! CoreDataObject
        coreDataObject2.name = "Realmy"
        coreDataObject2.age = 22
        coreDataObject2.email = "test@mail.com"
        coreDataObject2.city = "TestCity"
        coreDataObject2.birth = NSDate()
        let saved2: Bool = coreDataObject2.save()
        coreDataObject.beginWriting().delete().endWriting()
        coreDataObject2.beginWriting().delete().endWriting()
        XCTAssertEqual(CoreDataObject.all().find().count, 0, "The number of objects fetched after the deletion should be equal to 0")
    }
    
    func testObjectsEdition()
    {
        var coreDataObject: CoreDataObject? = nil
        coreDataObject = CoreDataObject.create() as? CoreDataObject
        coreDataObject?.save()
        coreDataObject!.beginWriting()
        coreDataObject!.name = "Testy"
        coreDataObject!.endWriting()
        let fetchedObject: CoreDataObject = CoreDataObject.all().find().firstObject() as! CoreDataObject
        XCTAssertEqual(fetchedObject.name, "Testy", "The name of the fetched object should be Testy")
        coreDataObject!.beginWriting().delete().endWriting()
    }
    
    func testObjectQuerying()
    {
        var coreDataObject: CoreDataObject? = nil
        var coreDataObject2: CoreDataObject? = nil
        coreDataObject = CoreDataObject.create() as? CoreDataObject
        coreDataObject!.name = "Realmy"
        coreDataObject!.age = 22
        coreDataObject!.email = "test@mail.com"
        coreDataObject!.city = "TestCity"
        coreDataObject!.birth = NSDate()
        let saved: Bool = coreDataObject!.save()
        coreDataObject2 = CoreDataObject.create() as? CoreDataObject
        coreDataObject2!.name = "Realmy2"
        coreDataObject2!.age = 22
        coreDataObject2!.email = "test@mail.com"
        coreDataObject2!.city = "TestCity2"
        coreDataObject2!.birth = NSDate()
        let saved2: Bool = coreDataObject2!.save()
        XCTAssertEqual(CoreDataObject.all().find().count, 2, "It should return 2 elements")
        
        //TODO `by` method doesn't work
        // XCTAssertEqual(CoreDataObject.by("age", equalTo: "22").find().count, 2, "It should return 2 elements with the age of 22")
        // XCTAssertEqual(CoreDataObject.by("age", equalTo: "10").find().count, 0, "It should return 0 elements with the age of 10")
        XCTAssertEqual((CoreDataObject.sorted(by: "name", ascending: true).first() .find().firstObject() as! CoreDataObject).name, "Realmy", "The name of the first object returned should be Realmy")
        XCTAssertEqual((CoreDataObject.sorted(by: "name", ascending: true).last().find().firstObject() as! CoreDataObject).name, "Realmy2", "The name of the first object returned should be Realmy2")
        XCTAssertEqual(CoreDataObject.sorted(by: "name", ascending: true).firsts(20).find().count, 2, "The number of fetched elements using firsts should be equal to 2")
        XCTAssertEqual(CoreDataObject.sorted(by: "name", ascending: true).lasts(20).find().count, 2, "The number of fetched elements using lasts should be equal to 2")
        coreDataObject!.beginWriting().delete().endWriting()
        coreDataObject2!.beginWriting().delete().endWriting()
    }
    
    func testObjectsCount()
    {
        var coreDataObject: CoreDataObject? = nil
        var coreDataObject2: CoreDataObject? = nil
        coreDataObject = CoreDataObject.create() as? CoreDataObject
        coreDataObject!.name = "Realmy"
        coreDataObject!.age = 22
        coreDataObject!.email = "test@mail.com"
        coreDataObject!.city = "TestCity"
        coreDataObject!.birth = NSDate()
        let saved: Bool = coreDataObject!.save()
        coreDataObject2 = CoreDataObject.create() as? CoreDataObject
        coreDataObject2!.name = "Realmy2"
        coreDataObject2!.age = 22
        coreDataObject2!.email = "test@mail.com"
        coreDataObject2!.city = "TestCity2"
        coreDataObject2!.birth = NSDate()
        let saved2: Bool = coreDataObject2!.save()
        XCTAssertEqual(CoreDataObject.count(), 2, "The count should be equal to 2")
        XCTAssertEqual(CoreDataObject.by("name", equalTo: "Realmy2").count(), 1, "The count should be equal to 1")
        coreDataObject!.beginWriting().delete().endWriting()
        coreDataObject2!.beginWriting().delete().endWriting()
    }
    
    func testObjectsWritingCancellation()
    {
        var coreDataObject: CoreDataObject? = nil
        coreDataObject = CoreDataObject.create() as? CoreDataObject
        coreDataObject!.name = "Realmy"
        coreDataObject!.age = 22
        coreDataObject!.email = "test@mail.com"
        coreDataObject!.city = "TestCity"
        coreDataObject!.birth = NSDate()
        _ = coreDataObject!.save()
        coreDataObject!.beginWriting().delete().cancelWriting()
        XCTAssertEqual(CoreDataObject.all().find().count, 1, "It should return 1 element because the writing transaction was cancelled")
        let objects = CoreDataObject.all().find()
        (objects.firstObject() as! CoreDataObject).beginWriting().delete().endWriting()
        XCTAssertEqual(CoreDataObject.all().find().count, 0, "It should return 0 element because the writing transaction was commited")
    }
}