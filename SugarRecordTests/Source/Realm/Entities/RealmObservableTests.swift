import Foundation
import Quick
import Nimble
import RealmSwift

@testable import SugarRecordRealm

class RealmObservableTests: QuickSpec {
    
    override func spec() {
        
        var subject: RealmObservable<Issue>!
        var request: Request<Issue>!
        var realm: Realm!
        
        beforeEach {
            realm = testRealm()
            realm.beginWrite()
            realm.create(Issue.self, value: ["id": "123", "name": "issue"], update: true)
            try! realm.commitWrite()
            request = Request<Issue>().filteredWith("id", equalTo: "123")
            subject = RealmObservable(request: request, realm: realm)
        }
        
        afterEach {
            realm.beginWrite()
            realm.deleteAll()
            try! realm.commitWrite()
        }
        
        describe("-observe:") {
            
            context("initial") {
                it("should notify about the initial state") {
                    waitUntil(action: { (done) in
                        subject.observe({ (change) in
                            switch change {
                            case .Initial(let issues):
                                expect(issues.first?.id) == "123"
                                done()
                            default:
                                break
                            }
                        })
                    })
                }
            }
            
            context("update") {
                //TODO - Figure out how to implement it since when the observable is released the entity get unsubscribed from notification and this test fails.
//                it("should notify about updates") {
//                    waitUntil(action: { (done) in
//                        subject.observe({ (change) in
//                            switch change {
//                            case .Update(let updated, _, let insertions, _):
//                                expect(insertions.first) == 0
//                                expect(updated.first?.id) == "666"
//                                done()
//                            default:
//                                break
//                            }
//                        })
//                        realm.beginWrite()
//                        realm.create(Issue.self, value: ["id": "666", "name": "issue"], update: true)
//                        try! realm.commitWrite()
//                    })
//                }
            }
            
        }
        
    }
    
}
