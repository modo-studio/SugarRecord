import Foundation
import Quick
import Nimble
import RealmSwift

@testable import SugarRecordRealm

class RealmDefaultStorageTests: QuickSpec {
    
    override func spec() {
        
        var subject: RealmDefaultStorage!
        
        beforeEach {
            subject = RealmDefaultStorage()
        }
        
        afterEach {
            _ = try? subject.removeStore()
        }
        
        describe("-description") {
            it("should have the correct description") {
                expect(subject.description) == "RealmDefaultStorage"
            }
        }
        
        describe("-type") {
            it("should have the correct type") {
                expect(subject.type) == StorageType.Realm
            }
        }
        
        describe("-memoryContext") {
            it("should return a memory realm for the memory context") {
                let memoryRealm: Realm? = subject.memoryContext as? Realm
                expect(memoryRealm?.configuration.inMemoryIdentifier) == "MemoryRealm"
            }
        }
        
        describe("-removeStore") {
            it("should remove the storage") {
                _ = try? subject.removeStore()
                let path = Realm.Configuration.defaultConfiguration.fileURL?.absoluteString
                expect(NSFileManager.defaultManager().fileExistsAtPath(path!)) == false
            }
            
            it("shouldn't throw an exception") {
                expect{ try subject!.removeStore() }.toNot(throwError())
            }
        }
        
        describe("-operation:") {
            
            it("should save the changes if the save closure is called") {
                waitUntil(action: { (done) -> Void in
                    _ = try? subject.operation({ (context, save) -> Void in
                        let issue: Issue = try! context.create()
                        issue.name = "test"
                        save()
                    })
                    let fetched = try! subject.mainContext.request(Issue.self).fetch()
                    expect(fetched.count) == 1
                    done()
                })
            }
            
            it("shouldn't persist the changes if the save closure is not called") {
                waitUntil(action: { (done) -> Void in
                    _ = try? subject.operation({ (context, save) -> Void in
                        let issue: Issue = try! context.create()
                        issue.name = "test"
                    })
                    let fetched = try! subject.mainContext.request(Issue.self).fetch()
                    expect(fetched.count) == 0
                    done()
                })
            }
            
        }
        
        describe("-observable") {
            
            var observable: RealmObservable<Issue>!
            var request: Request<Issue>!
            
            beforeEach {
                request = Request()
                observable = subject.observable(request) as! RealmObservable<Issue>
            }
            
            it("should have the correct request") {
                expect(observable.realm) == subject.mainContext as? Realm
            }
            
            it("should have the correct realm") {
                expect((observable as RequestObservable<Issue>).request) == request
            }
            
        }
        
    }
    
}
