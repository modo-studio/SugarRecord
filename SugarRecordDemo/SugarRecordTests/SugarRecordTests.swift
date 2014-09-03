// Swift
// Tests with Quick: https://github.com/Quick/Quick

import Quick
import SugarRecord
import Nimble
import CoreData

class SugarRecordHelperssTests: QuickSpec {
    override func spec() {
        beforeSuite {
            // Creating database stack
            SugarRecord.setupCoreDataStack(automigrating:true, databaseName: "testDatabase")
        }
        
        afterSuite {
            // Removing database
            let success: Bool = SugarRecord.removeDatabaseNamed("testDatabase")
        }

        describe("when initializing core", { () -> () in
            it ("should initialize a default persistant store coordinator") {
                expect(NSPersistentStoreCoordinator.defaultPersistentStoreCoordinator()).toNot(beNil())
            }
        });
        
        describe("deleting the database", { () -> () in
            it ("should delete the database locally if it exists") {
                let databaseName: String = "testDatabase"
                SugarRecord.removeDatabaseNamed(databaseName)
                let url: NSURL = NSPersistentStore.storeUrl(forDatabaseName: databaseName)
                let fileManager: NSFileManager = NSFileManager.defaultManager()
                expect(fileManager.fileExistsAtPath(url.absoluteString!)).to(equal(false))
                SugarRecord.setupCoreDataStack(automigrating:true, databaseName: "testDatabase")
            }
        })
        
        describe("cleaning up", { () -> () in
            // TODO - Ensure methods calls here (expectations)
        })
        
        describe("cleaning up the stack", { () -> () in
            // TODO - Ensure methods calls here too
        })
    }
}

class SugarRecordInformationTests: QuickSpec {
    override func spec() {
        beforeSuite {
            // Creating database stack
            SugarRecord.setupCoreDataStack(automigrating:true, databaseName: "testDatabase")
        }
        
        afterSuite {
            // Removing database
            let success: Bool = SugarRecord.removeDatabaseNamed("testDatabase")
        }
        
        context("getting information about the library") {
            it ("should return the version from the constant") {
                expect(SugarRecord.currentVersion()).to(equal(srSugarRecordVersion))
            }
        }
        context("returning the default database name") {
            it ("should use the mainBundle name if it exists") {
                let bundleName: AnyObject? = NSBundle.mainBundle().infoDictionary[kCFBundleNameKey]
                if let name = bundleName as? String {
                    expect(SugarRecord.defaultDatabaseName()).to(equal(name.stringByAppendingPathExtension("sqlite")))
                }
            }
        }
    }
}

class SugarRecordOperationsTests: QuickSpec {
    
    let dbName = "SavingDataBase"
    
    override func spec() {
        beforeSuite {
            // Creating database stack
            SugarRecord.setupCoreDataStack(automigrating:true, databaseName: self.dbName)
        }
        
        afterSuite {
            // Removing database
            let success: Bool = SugarRecord.removeDatabaseNamed(self.dbName)
        }
        
        context("Create an entity Person") {
            
            it ("should save successfully") {
                var saved = false
                SugarRecord.save(inBackground: true, savingBlock: { (context) -> () in
                    let fran: Person = Person.create(inContext: context) as Person
                    fran.name = "Fran"
                    fran.age = "27"
                    }) { (success, error) -> () in
                        expect(success).to(equal(true))
                        println(error)
                        saved = true
                }
                
                expect(saved).toEventually(equal(true))
            }
            
            it ("should save on a background thread and completion clousure called in the mainThread") {
                var saved = false
                SugarRecord.save(inBackground: true, savingBlock: { (context) -> () in
                    expect(NSThread.currentThread()).toNot(equal(NSThread.mainThread()));
                    }) { (success, error) -> () in
                    expect(NSThread.currentThread()).to(equal(NSThread.mainThread()));
                    saved = true
                }
                
                expect(saved).toEventually(equal(true))
            }
        }
        
    }
}