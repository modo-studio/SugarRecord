import Foundation
import Quick
import Nimble
import CoreData

@testable import SugarRecord

class CoreDataDefaultStorageTests: QuickSpec {
    override func spec() {
        
        describe("storage") { () -> Void in
            
            var store: CoreDataStore!
            var model: CoreDataObjectModel!
            var subject: CoreDataDefaultStorage!
            
            beforeEach {
                store = CoreDataStore.named("test")
                let bundle = Bundle(for: self.classForCoder)
                model = CoreDataObjectModel.merged([bundle])
                subject = try! CoreDataDefaultStorage(store: store!, model: model!)
            }
            
            afterEach {
                _ = try? subject?.removeStore()
            }
            
            context("initialization") {
                
                it("should create the database") {
                    let path = store!.path().path
                    expect(FileManager.default.fileExists(atPath: path)) == true
                }
                
                it("should have the right description") {
                    expect(subject?.description) == "CoreDataDefaultStorage"
                }
                
                it("should have the right type") {
                    expect(subject?.type) == .coreData
                }
                
                describe("root saving context") {
                    it("should have the persistent store coordinator as parent") {
                        expect(subject?.rootSavingContext.persistentStoreCoordinator) == subject?.persistentStoreCoordinator
                    }
                    it("should have private concurrency type") {
                        expect(subject?.rootSavingContext.concurrencyType) == .privateQueueConcurrencyType
                    }
                }
                
                describe("save context") {
                    it("should have the root saving context as parent") {
                        expect((subject?.saveContext as! NSManagedObjectContext).parent) == subject?.rootSavingContext
                    }
                    
                    it("should have private concurrency type") {
                        expect((subject?.saveContext as! NSManagedObjectContext).concurrencyType) == NSManagedObjectContextConcurrencyType.privateQueueConcurrencyType
                    }
                    
                }
                
                describe("memory context") {
                    it("should have the root saving context as parent") {
                        expect((subject?.memoryContext as! NSManagedObjectContext).parent) == subject?.rootSavingContext
                    }
                    
                    it("should have private concurrency type") {
                        expect((subject?.memoryContext as! NSManagedObjectContext).concurrencyType) == NSManagedObjectContextConcurrencyType.privateQueueConcurrencyType
                    }
                }
                
                describe("main context") {
                    it("should have the root saving context as parent") {
                        expect((subject?.mainContext as! NSManagedObjectContext).parent) == subject?.rootSavingContext
                    }
                    
                    it("should have main concurrency type") {
                        expect((subject?.mainContext as! NSManagedObjectContext).concurrencyType) == NSManagedObjectContextConcurrencyType.mainQueueConcurrencyType
                    }
                }
            }
            
            context("removal") {
                it("should properly remove the store") {
                    _ = try? subject?.removeStore()
                    let path = store!.path().path
                    expect(FileManager.default.fileExists(atPath: path)) == false
                }
            }
            
            context("persistence") {
                
                it("shouldn't persist changes if we save the memory context") {
                    waitUntil(action: { (done) -> Void in
                        let memoryContext = subject!.memoryContext as! NSManagedObjectContext!
                        let _: Track = try! memoryContext!.create()
                        try! memoryContext?.save()
                        _ = try? subject?.operation({ (context, save) -> Void in
                            let resultsCount = try! context.request(Track.self).fetch().count
                            expect(resultsCount) == 0
                            done()
                        })
                    })
                }
                
                it("should persist the changes if it's save context") {
                    waitUntil(action: { (done) -> Void in
                        _ = try? subject?.operation({ (context, save) -> Void in
                            let _: Track = try! context.create()
                            save()
                        })
                        let tracksCount: Int? = try! subject?.mainContext.request(Track.self).fetch().count
                        expect(tracksCount) == 1
                        done()
                    })
                }
            }
            
            describe("-operation:") {
                it("should return the inner value from the operation") {
                    waitUntil(action: { (done) -> Void in
                        let result: String = try! subject.operation({ (context, save) -> String in
                            let issue: Track = try! context.create()
                            issue.name = "trackName"
                            save()
                            return issue.name!
                        })
                        expect(result) == "trackName"
                        done()

                    })
                }
            }
            
            describe("-backgroundOperation") {
                it("should complete") {
                    waitUntil { (_done) in
                        subject.backgroundOperation({ (_, done) in
                            // Do nothing
                            done()
                        }, completion: { (error) in
                            _done()
                        })
                    }
                }
                it("it shouldn't call the completion block in the main thread") {
                    waitUntil { (done) in
                        subject.backgroundOperation({ (_, _done) in
                            _done()
                        }, completion: { (_) in
                            XCTAssertFalse(Thread.isMainThread)
                            done()
                        })
                    }
                }
            }
            
         
            describe("-observable:") {
                
                var request: FetchRequest<Track>!
                var observable: CoreDataObservable<Track>!
                
                beforeEach {
                    request = FetchRequest<Track>().filtered(with: "name", equalTo: "test")
                        .sorted(with: "name", ascending: true)
                    observable = subject.observable(request: request) as! CoreDataObservable<Track>
                }
                
                it("should have the correct request predicate") {
                    expect(observable.fetchRequest.predicate) == request.predicate
                }
                
                it("should have the correct request sort descriptor") {
                    expect(observable.fetchRequest.sortDescriptors) == [request.sortDescriptor!]
                }
                
                it("should have the correct context") {
                    expect(observable.fetchedResultsController.managedObjectContext) == subject.mainContext! as? NSManagedObjectContext
                }
                
            }
        }
    
    }
}
