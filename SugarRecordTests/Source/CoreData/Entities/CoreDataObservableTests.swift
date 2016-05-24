import Foundation
import Quick
import Nimble
import CoreData

@testable import SugarRecordCoreData

class CoreDataObservableTests: QuickSpec {
    
    override func spec() {
        
        var request: Request<Track>!
        var subject: CoreDataObservable<Track>!
        var storage: CoreDataDefaultStorage!
        
        beforeEach {
            let store: CoreData.Store = CoreData.Store.Named("test")
            let bundle = NSBundle(forClass: self.classForCoder)
            let model = CoreData.ObjectModel.Merged([bundle])
            storage = try! CoreDataDefaultStorage(store: store, model: model)
            _ = try? storage.removeStore()
            request = Request<Track>().sortedWith("name", ascending: true)
            let context: NSManagedObjectContext = storage.mainContext as! NSManagedObjectContext
            subject = CoreDataObservable(request: request, context: context)
            context.performBlock({ 
                let track: Track = try! context.create()
                track.name = "test"
                track.artist = "pedro"
                try! context.save()
            })
        }
        
        afterEach {
            _ = try? storage.removeStore()
        }
        
        describe("-observe:") {
            it("should report the initial state") {
                waitUntil(action: { (done) in
                    subject.observe({ (change) in
                        switch change {
                        case .Initial(let values):
                            expect(values.first?.name) == "test"
                            expect(values.first?.artist) == "pedro"
                            done()
                        default:
                            break
                        }
                    })
                })
            }
            
            it("should report updates") {
                waitUntil(action: { (done) in
                    subject.observe({ (change) in
                        switch change {
                        case .Update(_, let insertions, _):
                            expect(insertions[0].element.name) == "test2"
                            expect(insertions[0].element.artist) == "pedro"
                            done()
                        default:
                            break
                        }
                    })
                    let context: NSManagedObjectContext = storage.mainContext as! NSManagedObjectContext
                    context.performBlockAndWait {
                        let track: Track = try! context.create()
                        track.name = "test2"
                        track.artist = "pedro"
                        try! context.save()
                    }
                })
            }
        }
        
        describe("-dispose") {
            it("should unlink the NSFetchedResultsController from the observable") {
                subject.dispose()
                expect(subject.fetchedResultsController.delegate).to(beNil())
            }
        }
    }
    
}