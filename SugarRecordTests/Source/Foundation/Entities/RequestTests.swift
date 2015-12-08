import Foundation
import Quick
import Nimble
import RealmSwift
import Result

@testable import SugarRecord

class RequestTests: QuickSpec {
    
    override func spec() {
        
        describe("fetching") {
            
            it("should use the context for fetching passing itself") {
                let context = MockContext()
                let request: Request<Issue> = Request(context: context)
                _ = request.fetch()
                expect(context.fetched) == true
            }
            
        }
        
        describe("builders") {
            
            it("-filteredWithPredicate") {
                let predicate: NSPredicate = NSPredicate(format: "name == TEST")
                let request: Request<Issue> = Request(context: testRealm()).filteredWith(predicate: predicate)
                expect(request.predicate) == predicate
            }
            
            it("-filteredWith(key:value:)") {
                let predicate: NSPredicate = NSPredicate(format: "name == %@", "TEST")
                let request: Request<Issue> = Request(context: testRealm()).filteredWith("name", equalTo: "TEST")
                expect(request.predicate) == predicate
            }
            
            it("-sortedWith(key:ascending:comparator)") {
                let descriptor: NSSortDescriptor = NSSortDescriptor(key: "name", ascending: true, comparator: { _ in return NSComparisonResult.OrderedSame})
                let request: Request<Issue> = Request(context: testRealm()).sortedWith("name", ascending: true, comparator: {_ in return NSComparisonResult.OrderedSame})
                expect(descriptor.key) == request.sortDescriptor?.key
                expect(descriptor.ascending) == request.sortDescriptor?.ascending
            }
            
            it("-sortedWith(key:ascending)") {
                let descriptor: NSSortDescriptor = NSSortDescriptor(key: "name", ascending: true)
                let request: Request<Issue> = Request(context: testRealm()).sortedWith("name", ascending: true)
                expect(descriptor.key) == request.sortDescriptor?.key
                expect(descriptor.ascending) == request.sortDescriptor?.ascending
            }
            
            it("sortedWith(key:ascending:selector)") {
                let descriptor: NSSortDescriptor = NSSortDescriptor(key: "name", ascending: true, selector: "selector")
                let request: Request<Issue> = Request(context: testRealm()).sortedWith("name", ascending: true, selector: "selector")
                expect(descriptor.key) == request.sortDescriptor?.key
                expect(descriptor.ascending) == request.sortDescriptor?.ascending
                expect(descriptor.selector) == request.sortDescriptor?.selector
            }
        }
        
    }
    
}


// MARK: - FetchContext

private class MockContext: Context {
    
    var fetched: Bool = false
    
    private func insert<T : Entity>() -> Result<T, Error> {
        return Result(error: Error.Nothing)
    }
    
    private func remove<T : Entity>(objects: [T]) -> Result<Void, Error> {
        return Result(error: Error.Nothing)
    }
    
    private func fetch<T : Entity>(request: Request<T>) -> Result<[T], Error> {
        self.fetched = true
        return Result(error: Error.Nothing)
    }
}