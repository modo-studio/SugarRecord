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
                SugarRecord.stack().cleanup()
        }
        
        describe("object creation", { () -> () in
            var realmObject: Realm!
            
            beforeEach({ () -> () in
                realmObject = Realm.create() as Realm
                realmObject.name = "Realmy"
                realmObject.age = 1
                let saved: Bool = realmObject.save()
            })
            afterEach({ () -> () in
                let deleted: Bool = realmObject.delete()
            })
            
            it("should create the item in database", { () -> () in
                expect(Realm.allObjects().count).to(equal(1))
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
