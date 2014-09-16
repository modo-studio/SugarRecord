// Swift
// Tests with Quick: https://github.com/Quick/Quick

import Quick
import SugarRecord
import Nimble
import CoreData
import Realm

class SugarRecordCoreDataTests: QuickSpec {
    override func spec() {
        beforeSuite
        {
            //SugarRecord.setStack(DefaultCDStack(stackName: "RealmTest", stackDescription: "Realm stack for tests"))
        }
        
        afterSuite
        {
                
        }
        
        afterSuite
        {
            SugarRecord.stack().cleanup()
        }
        
        describe("object creation", { () -> () in
            beforeEach({ () -> () in
                
            })
            afterEach({ () -> () in
            })
        });
        
        describe("object deletion", { () -> () in
            beforeEach({ () -> () in
                
            })
            afterEach({ () -> () in
            })
        });
        
        describe("object edition", { () -> () in
            beforeEach({ () -> () in
                
            })
            
            afterEach({ () -> () in
            })
        });
        
        describe("object querying", { () -> () in
            beforeEach({ () -> () in
                
            })
            afterEach({ () -> () in
            })
        });
        
    }
}

class SugarRecordREALMTests: QuickSpec {
    override func spec() {
        beforeSuite
        {
            SugarRecord.setStack(DefaultREALMStack(stackName: "RealmTest", stackDescription: "Realm stack for tests"))
        }

        afterSuite
        {
            SugarRecord.cleanUp()
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
                realmObject.delete()
                realmObject2.delete()
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
                realmObject.delete()
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
                realmObject2.delete()
                realmObject.delete()
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
                let deleted: Bool = realmObject!.delete()
            })
            
            it("should apply the changes when the object changes are persisted", { () -> () in
                realmObject!.beginEditing()
                realmObject!.name = "Testy"
                realmObject!.endEditing()
                let fetchedObject: RealmObject = RealmObject.allObjects().firstObject() as RealmObject
                expect(fetchedObject.name).to(equal("Testy"))
            })
        });
        
        describe("object querying", { () -> () in
            beforeEach({ () -> () in
                
            })
            afterEach({ () -> () in
                
            })
        });
    }
}
