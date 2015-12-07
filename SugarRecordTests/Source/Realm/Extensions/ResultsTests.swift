import Foundation
import Quick
import Nimble
import RealmSwift

@testable import SugarRecord

class ResultsTests: QuickSpec {
    
    override func spec() {
        
        var realm: Realm?
        
        beforeEach {
            realm = testRealm()
        }
        
        afterEach {
            realm!.beginWrite()
            realm!.deleteAll()
            _ = try? realm!.commitWrite()
        }
        
        describe("array generation") {
            
            it("should return the same number of elements") {
                let issue = Issue()
                realm?.beginWrite()
                realm?.add(issue)
                _ = try? realm?.commitWrite()
                expect(realm?.objects(Issue.self).toArray().count) == 1
            }
            
            it("should return the proper elements") {
                let issue = Issue()
                realm?.beginWrite()
                issue.name = "test"
                realm?.add(issue)
                _ = try? realm?.commitWrite()
                expect(realm?.objects(Issue.self).toArray().first?.name) == "test"
            }
            
        }
    }
    
}