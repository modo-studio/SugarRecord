import Foundation
import Quick
import Nimble
import RealmSwift

@testable import SugarRecord

class RequestTests: QuickSpec {
    
    override func spec() {
        
        describe("builders") {
            
            it("should properly initialize the request with the provided predicate") {
                let predicate: NSPredicate = NSPredicate(format: "name == TEST")
                let request: Request<Issue> = Request(context: testRealm()).filteredWith(predicate: predicate)
                expect(request.predicate) == predicate
            }
            
            it("should properly initialize the request with the key and value") {
                let predicate: NSPredicate = NSPredicate(format: "name == TEST")
                let request: Request<Issue> = Request(context: testRealm()).filteredWith("name", equalTo: "TEST")
                
            }
            
        }
        
    }
    
}