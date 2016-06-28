import Foundation
import ReactiveCocoa
import RxSwift
import Quick
import Nimble

@testable import SugarRecordRealm

class ReactiveStorageTests: QuickSpec {
    override func spec() {
        
        var storage: RealmDefaultStorage?
        
        beforeEach {
            storage = RealmDefaultStorage()
        }
        
        afterEach {
            _ = try? storage?.removeStore()
        }
        
        describe("rac_operation") {
            it("should execute the operation notifying when completed") {
                storage?.rac_operation({ (context, save) -> Void in
                    let _: Issue = try! context.create()
                    save()
                })
                .startWithCompleted({ () -> () in
                    let count = try! storage?.mainContext.request(Issue.self).fetch().count
                    expect(count) == 1
                })
            }
        }
        
        describe("rx_operation") {
            it("should execute the operation notifying when completed") {
                _ = storage?.rx_operation({ (context, save) -> Void in
                    let _: Issue = try! context.create()
                    save()
                }).subscribeCompleted({ () -> Void in
                    let count = try! storage?.mainContext.request(Issue.self).fetch().count
                    expect(count) == 1
                })
            }
        }
        
        describe("rac_backgroundOperation") {
            it("should execute the operation notifying when completed") {
                waitUntil(action: { (done) -> Void in
                    storage?.rac_backgroundOperation({ (context, save) -> Void in
                        let _: Issue = try! context.create()
                        save()
                    })
                    .startWithCompleted({ () -> () in
                        let count = try! storage?.mainContext.request(Issue.self).fetch().count
                        expect(count) == 1
                        done()
                    })
                })
            }
        }
        
        describe("rx_backgroundOperation") {
            it("should execute the operation notifying when completed") {
                waitUntil(action: { (done) -> Void in
                    _ = storage?.rx_backgroundOperation({ (context, save) -> Void in
                        let _: Issue = try! context.create()
                        save()
                    }).subscribeCompleted({ () -> Void in
                        let count = try! storage?.mainContext.request(Issue.self).fetch().count
                        expect(count) == 1
                        done()
                    })
                })
            }
        }
        
        describe("rx_backgroundOperation") { 
            it("should produce the object from the inner block", closure: { 
                waitUntil(action: { (done) -> Void in
                    _ = storage?.rx_backgroundOperation({ (context, save) -> String in
                        let issue: Issue = try! context.create()
                        issue.name = "testName"
                        save()
                        return issue.name
                    }).subscribeNext({ (stringProduced) in
                        expect(stringProduced) == "testName"
                        done()
                    })
                    
                })
                
            })
        }
        
        describe("rac_fetch") {
            it("should execute the fetch and return the results") {
                _ = try? storage?.operation({ (context, save) -> Void in
                    let _: Issue = try! context.create()
                    save()
                })
                _ = storage?.rx_fetch(Request<Issue>()).subscribeNext({ (issues) -> Void in
                    expect(issues.count) == 1
                })
            }
        }
        
        describe("rac_backgroundFetch") {
            it("should execute the fetch mapping the returned objects") {
                _ = try? storage?.operation({ (context, save) -> Void in
                    let issue: Issue = try! context.create()
                    issue.name = "olakase"
                    save()
                })
                waitUntil(action: { (done) -> Void in
                    storage?.rac_backgroundFetch(Request<Issue>(), mapper: mapper)
                        .startWithNext({ (results) -> () in
                            expect(results.first) == "olakase"
                            done()
                        })
                })
            }
        }
        
        describe("rx_backgroundFetch") {
            it("should execute the fetch mapping the returned objects") {
                _ = try? storage?.operation({ (context, save) -> Void in
                    let issue: Issue = try! context.create()
                    issue.name = "olakase"
                    save()
                })
                waitUntil(action: { (done) -> Void in
                    _ = storage?.rx_backgroundFetch(Request<Issue>(), mapper: mapper).subscribeNext({ (results) -> Void in
                        expect(results.first) == "olakase"
                        done()
                    })
                })
            }
        }
    }
}

private func mapper(issue: Issue) -> String {
    return issue.name
}