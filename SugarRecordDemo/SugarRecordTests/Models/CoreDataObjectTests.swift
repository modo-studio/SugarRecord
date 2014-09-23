//
//  CoreDataObjectTests.swift
//  SugarRecord
//
//  Created by Pedro Piñera Buendía on 20/09/14.
//  Copyright (c) 2014 SugarRecord. All rights reserved.
//

import Quick
import Nimble
import CoreData
import Realm

class CoreDataObjectTests: QuickSpec {
    override func spec() {
        beforeSuite
        {
            let bundle: NSBundle = NSBundle(forClass: CoreDataObjectTests.classForCoder())
            let modelPath: NSString = bundle.pathForResource("SugarRecord", ofType: "momd")!
            let model: NSManagedObjectModel = NSManagedObjectModel(contentsOfURL: NSURL(fileURLWithPath: modelPath))
            let stack: DefaultCDStack = DefaultCDStack(databaseName: "TestDB.sqlite", model: model, automigrating: true)
            SugarRecord.addStack(stack)
        }
        afterSuite
        {
            SugarRecord.cleanup()
            SugarRecord.removeDatabase()
        }
        describe("object creation", { () -> () in
            it("should create the item in database", { () -> () in
                var coreDataObject: CoreDataObject = CoreDataObject.create() as CoreDataObject
                coreDataObject.name = "Testy"
                coreDataObject.age = 21
                coreDataObject.email = "test@test.com"
                coreDataObject.birth = NSDate()
                coreDataObject.city = "Springfield"
                let saved: Bool = coreDataObject.save()
                var coreDataObject2: CoreDataObject = CoreDataObject.create() as CoreDataObject
                coreDataObject2.name = "Testy2"
                coreDataObject2.age = 22
                coreDataObject2.email = "test2@test.com"
                coreDataObject2.birth = NSDate()
                coreDataObject2.city = "Springfield"
                let saved2: Bool = coreDataObject2.save()
                expect(CoreDataObject.all().find()!.count).to(equal(2))
                coreDataObject.beginWritting().delete().endWritting()
                coreDataObject2.beginWritting().delete().endWritting()
            })
        });
        
        describe("object deletion", { () -> () in
            it("should delete a given object properly", { () -> () in
                var coreDataObject: CoreDataObject = CoreDataObject.create() as CoreDataObject
                coreDataObject.name = "Realmy"
                coreDataObject.age = 22
                coreDataObject.email = "test@mail.com"
                coreDataObject.city = "TestCity"
                coreDataObject.birth = NSDate()
                let saved: Bool = coreDataObject.save()
                coreDataObject.beginWritting().delete().endWritting()
                expect(CoreDataObject.all().find()!.count).to(equal(0))
            })
            it("should delete all the objects in the database", { () -> () in
                var coreDataObject: CoreDataObject = CoreDataObject.create() as CoreDataObject
                coreDataObject.name = "Realmy"
                coreDataObject.age = 22
                coreDataObject.email = "test@mail.com"
                coreDataObject.city = "TestCity"
                coreDataObject.birth = NSDate()
                let saved: Bool = coreDataObject.save()
                var coreDataObject2: CoreDataObject = CoreDataObject.create() as CoreDataObject
                coreDataObject2.name = "Realmy"
                coreDataObject2.age = 22
                coreDataObject2.email = "test@mail.com"
                coreDataObject2.city = "TestCity"
                coreDataObject2.birth = NSDate()
                let saved2: Bool = coreDataObject2.save()
                coreDataObject.beginWritting().delete().endWritting()
                coreDataObject2.beginWritting().delete().endWritting()
                expect(CoreDataObject.all().find()!.count).to(equal(0))
            })
        });
        describe("object edition", { () -> () in
            var coreDataObject: CoreDataObject? = nil
            beforeEach({ () -> () in
                coreDataObject = CoreDataObject.create() as? CoreDataObject
                coreDataObject?.save()
            })
            afterEach({ () -> () in
                coreDataObject!.beginWritting().delete().endWritting()
            })
            it("should apply the changes when the object changes are persisted", { () -> () in
                coreDataObject!.beginWritting()
                coreDataObject!.name = "Testy"
                coreDataObject!.endWritting()
                let fetchedObject: CoreDataObject = CoreDataObject.all().find()!.first as CoreDataObject
                expect(fetchedObject.name).to(equal("Testy"))
            })
        });
        describe("object querying", { () -> () in
            var coreDataObject: CoreDataObject? = nil
            var coreDataObject2: CoreDataObject? = nil
            beforeEach({ () -> () in
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
            })
            afterEach({ () -> () in
                coreDataObject!.beginWritting().delete().endWritting()
                coreDataObject2!.beginWritting().delete().endWritting()
            })
            it("should return all objects", { () -> () in
                let found: [AnyObject] = CoreDataObject.all().find()!
                expect(found.count).to(equal(2))
            });
            it("should return ALL filtered objects", { () -> () in
                let found: [AnyObject] = CoreDataObject.by("age", equalTo: "22").find()!
                expect(found.count).to(equal(2))
            })
            it("should return ANYTHING if the filter doesn't match any result", { () -> () in
                let found: [AnyObject] = CoreDataObject.by("age", equalTo: "10").find()!
                expect(found.count).to(equal(0))
            })
            it("should return the FIRST element", { () -> () in
                let found: [AnyObject] = CoreDataObject.sorted(by: "name", ascending: true).first().find()!
                let object: CoreDataObject = found.first! as CoreDataObject
                expect(object.name).to(equal("Realmy"))
            })
            it("should return the LAST element", { () -> () in
                let found: [AnyObject] = CoreDataObject.sorted(by: "name", ascending: true).last().find()!
                let object: CoreDataObject = found.first! as CoreDataObject
                expect(object.name).to(equal("Realmy2"))
            })
            it("should return the FIRSTS elements", { () -> () in
                let found: [AnyObject] = CoreDataObject.sorted(by: "name", ascending: true).firsts(20).find()!
                let object: CoreDataObject = found.first! as CoreDataObject
                expect(found.count).to(equal(2))
            })
            it("should return the LASTS elements", { () -> () in
                let found: [AnyObject] = CoreDataObject.sorted(by: "name", ascending: true).lasts(20).find()!
                let object: CoreDataObject = found.first! as CoreDataObject
                expect(found.count).to(equal(2))
            })
        });
    }
}