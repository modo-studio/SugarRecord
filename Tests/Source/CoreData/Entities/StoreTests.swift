import Foundation
import Quick
import Nimble

@testable import SugarRecord

class StoreTests: QuickSpec {
    
    override func spec() {
        
        describe("path generation") { () -> Void in
            
            it("should return the url if the store is specified via an URL", closure: { () -> () in
                let url: URL = URL(string: "myurl")!
                expect(CoreDataStore.url(url).path()) == url
            })
            
            it("should return the store name in documents folder if it's a named store", closure: { () -> () in
                let name: String = "database.sqlite"
                expect(CoreDataStore.named(name).path()) == NSURL(fileURLWithPath: documentsDirectory()).appendingPathComponent(name)
            })
            
        }
    }
}
