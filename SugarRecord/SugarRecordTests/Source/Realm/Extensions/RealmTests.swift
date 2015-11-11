import Foundation
import Quick
import Nimble
import RealmSwift
import Result

@testable import SugarRecord

class RealmTests: QuickSpec {
    
    override func spec() {
        
        var subject: Realm?

        beforeEach {
            subject = testRealm()
        }
        
        afterEach {
            subject!.beginWrite()
            subject!.deleteAll()            
            _ = try? subject!.commitWrite()
        }
        
        describe("fetching") {
            it("should properly fetch objects persisted in the database") {
                let issue = Issue()
                subject?.beginWrite()
                subject?.add(issue)
                _ = try? subject?.commitWrite()
                
                let fetched: Result<[Issue], Error> = subject!.fetch(Request<Issue>())
                expect(fetched.value?.count) == 1
            }
        }
        
        describe("insert") {
            it("should return the object inserted in the Realm") {
                subject!.beginWrite()
                let inserted: Result<Issue, Error> = subject!.insert()
                _ = try? subject!.commitWrite()
                _ = inserted
                expect(subject!.objects(Issue.self).count) == 1
            }
        }
        
        describe("remove") {
            
            it("should remove objects from Realm properly") {
                try! subject!.write({ () -> Void in
                    let issue: Issue = Issue()
                    issue.name = "test"
                    subject!.add(issue)
                })
                
                // Fetching
                let _issue = subject!.objects(Issue.self).filter("name == %@", "test").first!
                subject!.remove([_issue])
                
                // Testing
                expect(subject!.objects(Issue.self).count) == 0
            }
            
        }
        
    }
}