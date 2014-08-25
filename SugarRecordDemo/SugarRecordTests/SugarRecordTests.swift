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

        describe("the table of contents below") {
            it("has everything you need to get started") {
                expect(3).to(equal(3))
            }
            
            context("if it doesn't have what you're looking for") {
                it("needs to be updated") {
                    expect(3).to(equal(3))
                }
            }
        }
    }
}