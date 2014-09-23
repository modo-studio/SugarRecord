//
//  RealmObjectTests.swift
//  SugarRecord
//
//  Created by Pedro Piñera Buendia on 20/09/14.
//  Copyright (c) 2014 SugarRecord. All rights reserved.
//

import Quick
import Nimble
import CoreData
import Realm

class RealmObjectTests: QuickSpec {
    override func spec() {
        beforeSuite
        {
                SugarRecord.addStack(DefaultREALMStack(stackName: "RealmTest", stackDescription: "Realm stack for tests"))
        }
        afterSuite
        {
                SugarRecord.cleanup()
                SugarRecord.removeDatabase()
        }
        describe("object creation", { () -> () in
            it("should create the item in database", { () -> () in
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
                expect(RealmObject.allObjects().count).to(equal(2))
                realmObject.beginWritting().delete().endWritting()
                realmObject2.beginWritting().delete().endWritting()
            })
        });
        describe("object deletion", { () -> () in
            it("should delete a given object properly", { () -> () in
                var realmObject: RealmObject = RealmObject.create() as RealmObject
                realmObject.name = "Realmy"
                realmObject.age = 22
                realmObject.email = "test@mail.com"
                realmObject.city = "TestCity"
                realmObject.birthday = NSDate()
                let saved: Bool = realmObject.save()
                realmObject.beginWritting().delete().endWritting()
                expect(RealmObject.allObjects().count).to(equal(0))
            })
            it("should delete all the objects in the database", { () -> () in
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
                realmObject.beginWritting().delete().endWritting()
                realmObject2.beginWritting().delete().endWritting()
                expect(RealmObject.allObjects().count).to(equal(0))
            })
        });
        describe("object edition", { () -> () in
            var realmObject: RealmObject? = nil
            beforeEach({ () -> () in
                realmObject = RealmObject.create() as? RealmObject
                realmObject?.save()
            })
            afterEach({ () -> () in
                realmObject!.beginWritting().delete().endWritting()
            })
            it("should apply the changes when the object changes are persisted", { () -> () in
                realmObject!.beginWritting()
                realmObject!.name = "Testy"
                realmObject!.endWritting()
                let fetchedObject: RealmObject = RealmObject.allObjects().firstObject() as RealmObject
                expect(fetchedObject.name).to(equal("Testy"))
            })
        });
        describe("object querying", { () -> () in
            var realmObject: RealmObject? = nil
            var realmObject2: RealmObject? = nil
            beforeEach({ () -> () in
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
            })
            afterEach({ () -> () in
                realmObject2!.beginWritting().delete().endWritting()
                realmObject!.beginWritting().delete().endWritting()
            })
            it("should return all objects", { () -> () in
                let found: [AnyObject] = RealmObject.all().find()!
                expect(found.count).to(equal(2))
            });
            it("should return ALL filtered objects", { () -> () in
                let found: [AnyObject] = RealmObject.by("age", equalTo: "22").find()!
                expect(found.count).to(equal(2))
            })
            it("should return ANYTHING if the filter doesn't match any result", { () -> () in
                let found: [AnyObject] = RealmObject.by("age", equalTo: "10").find()!
                expect(found.count).to(equal(0))
            })
            it("should return the FIRST element", { () -> () in
                let found: [AnyObject] = RealmObject.sorted(by: "name", ascending: true).first().find()!
                let object: RealmObject = found.first! as RealmObject
                expect(object.name).to(equal("Realmy"))
            })
            it("should return the LAST element", { () -> () in
                let found: [AnyObject] = RealmObject.sorted(by: "name", ascending: true).last().find()!
                let object: RealmObject = found.first! as RealmObject
                expect(object.name).to(equal("Realmy2"))
            })
            it("should return the FIRSTS elements", { () -> () in
                let found: [AnyObject] = RealmObject.sorted(by: "name", ascending: true).firsts(20).find()!
                let object: RealmObject = found.first! as RealmObject
                expect(found.count).to(equal(2))
            })
            it("should return the LASTS elements", { () -> () in
                let found: [AnyObject] = RealmObject.sorted(by: "name", ascending: true).lasts(20).find()!
                let object: RealmObject = found.first! as RealmObject
                expect(found.count).to(equal(2))
            })
        });
    }
}

