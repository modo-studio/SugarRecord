import Foundation
import Nimble
import Quick
import CoreData

@testable import SugarRecord

class ObjectModelTests: QuickSpec {
    
    override func spec() {
        
        describe("data model generation") { () -> Void in
            
            context("merged", {
                it("should take the provided bundle data model", closure: { () -> () in
                    let bundle = Bundle(for: self.classForCoder)
                    expect(CoreDataObjectModel.merged([bundle]).model()).toNot(beNil())
                })
                it("should return the models in the main bundle", closure: {
                    expect(CoreDataObjectModel.merged(nil).model()?.entities.count) == 0
                })
            })
            
            context("named", {
                it("should return the object model", closure: {
                    expect(CoreDataObjectModel.named("DataModel", Bundle(for: self.classForCoder)).model()?.entities.count) == 1
                })
            })
            
            context("url", { () -> Void in
                it("should return an object model if the url is valid") {
                    let url = Bundle(for: self.classForCoder).url(forResource: "DataModel", withExtension: "momd")
                    expect(CoreDataObjectModel.url(url!).model()?.entities.count) == 1
                }
            })
            
        }
        
    }
    
}
