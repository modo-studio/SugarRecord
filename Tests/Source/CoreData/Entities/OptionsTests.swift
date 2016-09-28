import Foundation
import Quick
import Nimble
import CoreData

@testable import SugarRecord

class OptionsTests: QuickSpec {
    
    override func spec() {
        
        describe("options dictionary content") {
            
            it("should return the right data for default options") {
                let options = CoreDataOptions.basic.dict()
                let sqliteOptions = options[NSSQLitePragmasOption] as! [String: String]
                expect(sqliteOptions["journal_mode"]) == "DELETE"
                expect(options[NSMigratePersistentStoresAutomaticallyOption] as? NSNumber) == NSNumber(value: true)
                expect(options[NSInferMappingModelAutomaticallyOption] as? NSNumber) == NSNumber(value: false)
            }
            
            it("should return the right data for migration options") {
                let options = CoreDataOptions.migration.dict()
                let sqliteOptions = options[NSSQLitePragmasOption] as! [String: String]
                expect(sqliteOptions["journal_mode"]) == "DELETE"
                expect(options[NSMigratePersistentStoresAutomaticallyOption] as? NSNumber) == NSNumber(value: true)
                expect(options[NSInferMappingModelAutomaticallyOption] as? NSNumber) == NSNumber(value: true)
            }
            
        }
        
    }
    
}
