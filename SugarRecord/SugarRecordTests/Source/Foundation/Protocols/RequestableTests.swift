import Foundation
import Quick
import Nimble
import RealmSwift

@testable import SugarRecord

class RequestableTests: QuickSpec {
    
    override func spec() {
        
        describe("static initializers") {
            
            it("should initialize the request with the right sort descriptor and predicate") {
                let predicate: NSPredicate = NSPredicate(format: "")
                let descriptor: NSSortDescriptor = NSSortDescriptor(key: "name", ascending: true)
                
                
                
            }
            
        }
    }
    
}