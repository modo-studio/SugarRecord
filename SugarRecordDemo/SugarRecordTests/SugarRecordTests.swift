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
            //SugarRecord.setupCoreDataStack(automigrating:true, databaseName: "testDatabase")
        }
        
        afterSuite {
            // Removing database
            //let success: Bool = SugarRecord.removeDatabaseNamed("testDatabase")
        }

        describe("when initializing core", { () -> () in
            it ("should initialize a default persistant store coordinator") {
                //expect(NSPersistentStoreCoordinator.defaultPersistentStoreCoordinator()).toNot(beNil())
            }
        });
    }
}
