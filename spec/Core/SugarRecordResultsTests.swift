//
//  SugarRecordResultsTests.swift
//  project
//
//  Created by Pedro Piñera Buendía on 25/12/14.
//  Copyright (c) 2014 SugarRecord. All rights reserved.
//

import Foundation
import XCTest
import CoreData
import Realm

class SugarRecordResultsTests: XCTestCase
{
    //MARK: - Setup
    
    func beforeEach()
    {
        // Core Data
        var coreDataObject: CoreDataObject = CoreDataObject.create() as CoreDataObject
        coreDataObject.name = "CD1"
        let saved: Bool = coreDataObject.save()
        var coreDataObject2: CoreDataObject = CoreDataObject.create() as CoreDataObject
        coreDataObject2.name = "CD2"
        let saved2: Bool = coreDataObject2.save()
        
        // Realm
        var realmObject: RealmObject = RealmObject.create() as RealmObject
        realmObject.name = "R1"
        let savedRealm: Bool = realmObject.save()
        var realmObject2: RealmObject = RealmObject.create() as RealmObject
        realmObject2.name = "R2"
        let savedRealm2: Bool = realmObject2.save()
    }
    
    func afterEach()
    {
        // Core Data
        let coreDataObjects = CoreDataObject.all().find()
        for object in coreDataObjects{
            let coreDataObject: CoreDataObject? = object as? CoreDataObject
            if (coreDataObject != nil) {
                coreDataObject!.beginWriting().delete().endWriting()
            }
        }
        
        // Realm
        let realmObjects = RealmObject.all().find()
        for object in realmObjects{
            let realmObject: RealmObject? = object as? RealmObject
            if (realmObject != nil) {
                realmObject!.beginWriting().delete().endWriting()
            }
        }
    }
    
    override func setUp()
    {
        // Core Data
        super.setUp()
        let bundle: NSBundle = NSBundle(forClass: CoreDataObjectTests.classForCoder())
        let modelPath: NSString = bundle.pathForResource("TestsDataModel", ofType: "momd")!
        let model: NSManagedObjectModel = NSManagedObjectModel(contentsOfURL: NSURL(fileURLWithPath: modelPath)!)!
        let stack: DefaultCDStack = DefaultCDStack(databaseName: "TestDB.sqlite", model: model, automigrating: true)
        SugarRecord.addStack(stack)
        
        // Realm
        SugarRecord.addStack(DefaultREALMStack(stackName: "RealmTest", stackDescription: "Realm stack for tests"))
    }
    
    override func tearDown() {
        // Core Data
        SugarRecord.cleanup()
        SugarRecord.removeDatabase()
        super.tearDown()
        
        // Realm
        SugarRecord.cleanup()
        SugarRecord.removeDatabase()
    }
    
    
    //MARK: - Tests
    
    func testCount()
    {
        beforeEach()
        XCTAssertEqual(CoreDataObject.all().count(), 2, "CoreData objects count should be 2")
        XCTAssertEqual(RealmObject.all().count(), 2, "RealmObject objects count should be 2")
        afterEach()
    }
    
    func testFirstObject()
    {
        beforeEach()
        XCTAssertEqual((CoreDataObject.all().sorted(by: "name", ascending: true).find().firstObject() as CoreDataObject).name, "CD1", "The first object should be CD1")
        XCTAssertEqual((RealmObject.all().sorted(by: "name", ascending: true).find().firstObject() as RealmObject).name, "R1", "The first object should be R1")
        afterEach()
    }
    
    func testLastObject()
    {
        beforeEach()
        XCTAssertEqual((CoreDataObject.all().sorted(by: "name", ascending: true).find().lastObject() as CoreDataObject).name, "CD2", "The first object should be CD2")
        XCTAssertEqual((RealmObject.all().sorted(by: "name", ascending: true).find().lastObject() as RealmObject).name, "R2", "The first object should be R2")
        afterEach()
    }
    
    func testObjectAtIndex()
    {
        beforeEach()
        XCTAssertEqual((CoreDataObject.all().sorted(by: "name", ascending: true).find().objectAtIndex(0) as CoreDataObject).name, "CD1", "The first object should be CD1")
        XCTAssertEqual((RealmObject.all().sorted(by: "name", ascending: true).find().objectAtIndex(0) as RealmObject).name, "R1", "The first object should be R1")
        afterEach()
    }
    
    func testSubscript()
    {
        beforeEach()
        XCTAssertEqual((CoreDataObject.all().sorted(by: "name", ascending: true).find()[0] as CoreDataObject).name, "CD1", "The first object should be CD1")
        XCTAssertEqual((RealmObject.all().sorted(by: "name", ascending: true).find()[0] as RealmObject).name, "R1", "The first object should be R1")
        afterEach()
    }
}