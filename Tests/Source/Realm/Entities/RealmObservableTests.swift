import Foundation
import Quick
import Nimble
import RealmSwift

@testable import SugarRecord

class RealmObservableTests: QuickSpec {
    
    override func spec() {
        
        var subject: RealmObservable<Issue>!
        var request: FetchRequest<Issue>!
        var realm: Realm!
        
        beforeEach {
            realm = testRealm()
            realm.beginWrite()
            realm.create(Issue.self, value: ["id": "123", "name": "issue"], update: true)
            try! realm.commitWrite()
            request = FetchRequest<Issue>()
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
                            case .initial(let issues):
                                expect(issues.first?.id) == "123"
                                done()
                            default:
                                break
                            }
                        })
                    })
                }
            }
            
            //FIXME
//            context("update") {
//                it("should notify about updates") {
//                    waitUntil(timeout: 5.0, action: { (done) in
//                        var called: Bool = false
//                        subject.observe({ (change) in
//                            switch change {
//                            case .update(_, let insertions, _):
//                                if !called {
//                                    expect(insertions.first?.element.id) == "666"
//                                    done()
//                                    called = true
//                                }
//                            default:
//                                break
//                            }
//                        })
//                        realm.beginWrite()
//                        realm.create(Issue.self, value: ["id": "666", "name": "issue"], update: true)
//                        try! realm.commitWrite()
//                    })
//                }
//            }
            
        }
        
    }
    
}
