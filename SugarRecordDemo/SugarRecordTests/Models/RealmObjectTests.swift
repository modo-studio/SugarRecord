//
//  RealmObjectTests.swift
//  SugarRecord
//
//  Created by Pedro Piñera Buendia on 20/09/14.
//  Copyright (c) 2014 SugarRecord. All rights reserved.
//

import XCTest
import CoreData
import Realm

class RealmObjectTests: XCTestCase
{
    override func setUp()
    {
        SugarRecord.addStack(DefaultREALMStack(stackName: "RealmTest", stackDescription: "Realm stack for tests"))
    }
    
    override func tearDown() {
        SugarRecord.cleanup()
        SugarRecord.removeDatabase()
    }
    
    func testObjectCreation()
    {
        var realmObject: RealmObject = RealmObject.create() as RealmObject
        realmObject.name = "Realmy"
        realmObject.age = 22
        realmObject.email = "test@mail.com"
        realmObject.city = "TestCity"
        realmObject.birthday = NSDate()
        let saved: Bool = realmObject.save()
        var realmObject2: RealmObject = RealmObject.create() as RealmObject
        realmObject2.name = "Realmy"
        realmObject2.age = 22
        realmObject2.email = "test@mail.com"
        realmObject2.city = "TestCity"
        realmObject2.birthday = NSDate()
        let saved2: Bool = realmObject2.save()
        XCTAssertEqual(RealmObject.all().find()!.count, 2, "The number of objects fetched should be equal to 2")
        realmObject.beginWriting().delete().endWriting()
        realmObject2.beginWriting().delete().endWriting()
    }
    
    func testObjectDeletion()
    {
        var realmObject: RealmObject = RealmObject.create() as RealmObject
        realmObject.name = "Realmy"
        realmObject.age = 22
        realmObject.email = "test@mail.com"
        realmObject.city = "TestCity"
        realmObject.birthday = NSDate()
        let saved: Bool = realmObject.save()
        realmObject.beginWriting().delete().endWriting()
        XCTAssertEqual(RealmObject.all().find()!.count, 0, "The number of objects fetched after the deletion should be equal to 0")
    }
    
    func testAllObjectsDeletion()
    {
        var realmObject: RealmObject = RealmObject.create() as RealmObject
        realmObject.name = "Realmy"
        realmObject.age = 22
        realmObject.email = "test@mail.com"
        realmObject.city = "TestCity"
        realmObject.birthday = NSDate()
        let saved: Bool = realmObject.save()
        var realmObject2: RealmObject = RealmObject.create() as RealmObject
        realmObject2.name = "Realmy"
        realmObject2.age = 22
        realmObject2.email = "test@mail.com"
        realmObject2.city = "TestCity"
        realmObject2.birthday = NSDate()
        let saved2: Bool = realmObject2.save()
        realmObject.beginWriting().delete().endWriting()
        realmObject2.beginWriting().delete().endWriting()
        XCTAssertEqual(RealmObject.all().find()!.count, 0, "The number of objects fetched after the deletion should be equal to 0")
    }
    
    func testObjectsEdition()
    {
        var realmObject: RealmObject? = nil
        realmObject = RealmObject.create() as? RealmObject
        realmObject?.save()
        realmObject!.beginWriting()
        realmObject!.name = "Testy"
        realmObject!.endWriting()
        let fetchedObject: RealmObject = RealmObject.allObjects().firstObject() as RealmObject
        XCTAssertEqual(fetchedObject.name, "Testy", "The name of the fetched object should be Testy")
        realmObject!.beginWriting().delete().endWriting()
    }
    
    func testObjectQuerying()
    {
        var realmObject: RealmObject? = nil
        var realmObject2: RealmObject? = nil
        realmObject = RealmObject.create() as? RealmObject
        realmObject!.name = "Realmy"
        realmObject!.age = 22
        realmObject!.email = "test@mail.com"
        realmObject!.city = "TestCity"
        realmObject!.birthday = NSDate()
        let saved: Bool = realmObject!.save()
        realmObject2 = RealmObject.create() as? RealmObject
        realmObject2!.name = "Realmy2"
        realmObject2!.age = 22
        realmObject2!.email = "test@mail.com"
        realmObject2!.city = "TestCity2"
        realmObject2!.birthday = NSDate()
        let saved2: Bool = realmObject2!.save()
        XCTAssertEqual(RealmObject.all().find()!.count, 2, "It should return 2 elements")
        XCTAssertEqual(RealmObject.by("age", equalTo: "22").find()!.count, 2, "It should return 2 elements with the age of 22")
        XCTAssertEqual(RealmObject.by("age", equalTo: "10").find()!.count, 0, "It should return 0 elements with the age of 10")
        XCTAssertEqual(RealmObject.sorted(by: "name", ascending: true).first().find()!.first!.name, "Realmy", "The name of the first object returned should be Realmy")
        XCTAssertEqual(RealmObject.sorted(by: "name", ascending: true).last().find()!.first!.name, "Realmy2", "The name of the first object returned should be Realmy2")
        XCTAssertEqual(RealmObject.sorted(by: "name", ascending: true).firsts(20).find()!.count, 2, "The number of fetched elements using firsts should be equal to 2")
        XCTAssertEqual(RealmObject.sorted(by: "name", ascending: true).lasts(20).find()!.count, 2, "The number of fetched elements using lasts should be equal to 2")
        realmObject!.beginWriting().delete().endWriting()
        realmObject2!.beginWriting().delete().endWriting()
    }
}

