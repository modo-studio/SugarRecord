import Foundation
import Quick
import Nimble
import Result

@testable import SugarRecord

class RequestTests: QuickSpec {
    
    override func spec() {
        
        describe("builders") {
            
            it("-filtered:with") {
                let predicate: NSPredicate = NSPredicate(format: "name == TEST")
                let request: FetchRequest<Track> = FetchRequest(testCoreData()).filtered(with: predicate)
                expect(request.predicate) == predicate
            }
            
            it("-filtered(with:value:)") {
                let predicate: NSPredicate = NSPredicate(format: "name == %@", "TEST")
                let request: FetchRequest<Track> = FetchRequest(testCoreData()).filtered(with: "name", equalTo: "TEST")
                expect(request.predicate) == predicate
            }
            
            it("-filtered:with:in:") {
                let predicate: NSPredicate = NSPredicate(format: "name IN %@", ["TEST"])
                let request: FetchRequest<Track> = FetchRequest(testCoreData()).filtered(with: "name", in: ["TEST"])
                expect(request.predicate) == predicate
            }
            
            it("-filtered:with:notIn:") {
                let predicate: NSPredicate = NSPredicate(format: "NOT name IN %@", ["TEST"])
                let request: FetchRequest<Track> = FetchRequest(testCoreData()).filtered(with: "name", notIn: ["TEST"])
                expect(request.predicate) == predicate
            }
            
            it("-sorted(with:ascending:comparator)") {
                let descriptor: NSSortDescriptor = NSSortDescriptor(key: "name", ascending: true, comparator: { _ in return ComparisonResult.orderedSame})
                let request: FetchRequest<Track> = FetchRequest(testCoreData()).sorted(with: "name", ascending: true, comparator: {_ in return ComparisonResult.orderedSame})
                expect(descriptor.key) == request.sortDescriptor?.key
                expect(descriptor.ascending) == request.sortDescriptor?.ascending
            }
            
            it("-sorted(with:ascending)") {
                let descriptor: NSSortDescriptor = NSSortDescriptor(key: "name", ascending: true)
                let request: FetchRequest<Track> = FetchRequest(testCoreData()).sorted(with: "name", ascending: true)
                expect(descriptor.key) == request.sortDescriptor?.key
                expect(descriptor.ascending) == request.sortDescriptor?.ascending
            }
            
            it("sorted(with:ascending:selector)") {
                let descriptor: NSSortDescriptor = NSSortDescriptor(key: "name", ascending: true, selector: Selector("selector"))
                let request: FetchRequest<Track> = FetchRequest(testCoreData()).sorted(with: "name", ascending: true, selector: Selector("selector"))
                expect(descriptor.key) == request.sortDescriptor?.key
                expect(descriptor.ascending) == request.sortDescriptor?.ascending
                expect(descriptor.selector) == request.sortDescriptor?.selector
            }
        }
        
    }
    
}
