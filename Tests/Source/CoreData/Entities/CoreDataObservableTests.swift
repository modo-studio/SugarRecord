import Foundation
import Quick
import Nimble
import CoreData

@testable import SugarRecord

class CoreDataObservableTests: QuickSpec {
    
    override func spec() {
        
        var request: FetchRequest<Track>!
        var subject: CoreDataObservable<Track>!
        var storage: CoreDataDefaultStorage!
        
        beforeEach {
            let store: CoreDataStore = CoreDataStore.named("test")
            let bundle = Bundle(for: self.classForCoder)
            let model = CoreDataObjectModel.merged([bundle])
            storage = try! CoreDataDefaultStorage(store: store, model: model)
            _ = try? storage.removeStore()
            request = FetchRequest<Track>().sorted(with: "name", ascending: true)
            let context: NSManagedObjectContext = storage.mainContext as! NSManagedObjectContext
            subject = CoreDataObservable(request: request, context: context)
            context.perform({
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
                        case .initial(let values):
                            expect(values.first?.name) == "test"
                            expect(values.first?.artist) == "pedro"
                            done()
                        default:
                            break
                        }
                    })
                })
            }

            //FIXME
//            it("should report updates") {
//                waitUntil(action: { (done) in
//                    subject.observe({ (change) in
//                        switch change {
//                        case .update(_, let insertions, _):
//                            expect(insertions[0].element.name) == "test2"
//                            expect(insertions[0].element.artist) == "pedro"
//                            done()
//                        default:
//                            break
//                        }
//                    })
//                    let context: NSManagedObjectContext = storage.mainContext as! NSManagedObjectContext
//                    context.performAndWait {
//                        let track: Track = try! context.create()
//                        track.name = "test2"
//                        track.artist = "pedro"
//                        try! context.save()
//                    }
//                })
//            }
        }
        
        describe("-dispose") {
            it("should unlink the NSFetchedResultsController from the observable") {
                subject.dispose()
                expect(subject.fetchedResultsController.delegate).to(beNil())
            }
        }
    }
    
}
