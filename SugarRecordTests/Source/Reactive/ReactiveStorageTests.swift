import Foundation
import ReactiveCocoa
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
                })
                .startWithCompleted({ () -> () in
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
                    })
                    .startWithCompleted({ () -> () in
                        let count = try! storage?.mainContext.request(Issue.self).fetch().count
                        expect(count) == 1
                        done()
                    })
                })
            }
        }
        
        describe("rac_fetch") {
            it("should execute the fetch and return the results") {
                storage?.operation({ (context, save) -> Void in
                    let _: Issue = try! context.create()
                    save()
                })
                storage?.rac_fetch(Request<Issue>()).startWithNext({ (issues) -> () in
                    expect(issues.count) == 1
                })
            }
        }
        
        describe("rac_backgroundFetch") {
            it("should execute the fetch mapping the returned objects") {
                storage?.operation({ (context, save) -> Void in
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
    }
}

private func mapper(issue: Issue) -> String {
    return issue.name
}