import Foundation
import Quick
import Nimble
import CoreData

@testable import SugarRecordCoreData

class CoreDataDefaultStorageTests: QuickSpec {
    override func spec() {
        
        describe("storage") { () -> Void in
            
            var store: CoreData.Store?
            var model: CoreData.ObjectModel?
            var defaultStorage: CoreDataDefaultStorage?
            
            beforeEach {
                store = CoreData.Store.Named("test")
                let bundle = NSBundle(forClass: self.classForCoder)
                model = CoreData.ObjectModel.Merged([bundle])
                defaultStorage = try! CoreDataDefaultStorage(store: store!, model: model!)
            }
            
            afterEach {
                _ = try? defaultStorage?.removeStore()
            }
            
            context("initialization") {
                
                it("should create the database") {
                    let path = store!.path().path!
                    expect(NSFileManager.defaultManager().fileExistsAtPath(path)) == true
                }
                
                it("should have the right description") {
                    expect(defaultStorage?.description) == "CoreDataDefaultStorage"
                }
                
                it("should have the right type") {
                    expect(defaultStorage?.type) == .CoreData
                }
                
                describe("root saving context") {
                    it("should have the persistent store coordinator as parent") {
                        expect(defaultStorage?.rootSavingContext.persistentStoreCoordinator) == defaultStorage?.persistentStoreCoordinator
                    }
                    it("should have private concurrency type") {
                        expect(defaultStorage?.rootSavingContext.concurrencyType) == .PrivateQueueConcurrencyType
                    }
                }
                
                describe("save context") {
                    it("should have the root saving context as parent") {
                        expect((defaultStorage?.saveContext as! NSManagedObjectContext).parentContext) == defaultStorage?.rootSavingContext
                    }
                    
                    it("should have private concurrency type") {
                        expect((defaultStorage?.saveContext as! NSManagedObjectContext).concurrencyType) == NSManagedObjectContextConcurrencyType.PrivateQueueConcurrencyType
                    }
                    
                }
                
                describe("memory context") {
                    it("should have the root saving context as parent") {
                        expect((defaultStorage?.memoryContext as! NSManagedObjectContext).parentContext) == defaultStorage?.rootSavingContext
                    }
                    
                    it("should have private concurrency type") {
                        expect((defaultStorage?.memoryContext as! NSManagedObjectContext).concurrencyType) == NSManagedObjectContextConcurrencyType.PrivateQueueConcurrencyType
                    }
                }
                
                describe("main context") {
                    it("should have the root saving context as parent") {
                        expect((defaultStorage?.mainContext as! NSManagedObjectContext).parentContext) == defaultStorage?.rootSavingContext
                    }
                    
                    it("should have main concurrency type") {
                        expect((defaultStorage?.mainContext as! NSManagedObjectContext).concurrencyType) == NSManagedObjectContextConcurrencyType.MainQueueConcurrencyType
                    }
                }
            }
            
            context("removal") {
                it("should properly remove the store") {
                    _ = try? defaultStorage?.removeStore()
                    let path = store!.path().path!
                    expect(NSFileManager.defaultManager().fileExistsAtPath(path)) == false
                }
            }
            
            context("persistence") {
                
                it("shouldn't persist changes if we save the memory context") {
                    waitUntil(action: { (done) -> Void in
                        let memoryContext = defaultStorage!.memoryContext as! NSManagedObjectContext!
                        let _: Track = try! memoryContext.create()
                        try! memoryContext.save()
                        _ = try? defaultStorage?.operation({ (context, save) -> Void in
                            let resultsCount = try! context.request(Track.self).fetch().count
                            expect(resultsCount) == 0
                            done()
                        })
                    })
                }
                
                it("should persist the changes if it's save context") {
                    waitUntil(action: { (done) -> Void in
                        _ = try? defaultStorage?.operation({ (context, save) -> Void in
                            let _: Track = try! context.create()
                            save()
                        })
                        let tracksCount: Int? = try! defaultStorage?.mainContext.request(Track.self).fetch().count
                        expect(tracksCount) == 1
                        done()
                    })
                }
            }
            
        }
    
    }
}