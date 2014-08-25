// Swift
// Tests with Quick: https://github.com/Quick/Quick

import Quick
import Nimble

class TableOfContentsSpec: QuickSpec {
    override func spec() {
        beforeSuite {
            // Creating database stack
            SugarRecord.setupCoreDataStack(true, databaseName: "testDatabase")
        }
        
        afterSuite {
            // Removing database
            let success: Bool = SugarRecord.removeDatabaseNamed("testDatabase")
        }

        describe("when initializing core", { () -> () in

        });
        
        describe("deleting the database", { () -> () in
            
        })
        
        describe("cleaning up", { () -> () in
            
        })
        
        describe("cleaning up the stack", { () -> () in
            
        })
    }
}