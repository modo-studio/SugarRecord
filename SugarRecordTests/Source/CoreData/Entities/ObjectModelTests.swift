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
                    let bundle = NSBundle(forClass: self.classForCoder)
                    expect(CoreData.ObjectModel.Merged([bundle]).model()).toNot(beNil())
                })
                it("should return nil managed object model if no bundle is passed", closure: {
                    expect(CoreData.ObjectModel.Merged(nil).model()?.entities.count) == 0
                })
            })
            
            context("named", {
                it("should return the object model", closure: {
                    expect(CoreData.ObjectModel.Named("DataModel", NSBundle(forClass: self.classForCoder)).model()?.entities.count) == 1
                })
            })
            
            context("url", { () -> Void in
                it("should return an object model if the url is valid") {
                    let url = NSBundle(forClass: self.classForCoder).URLForResource("DataModel", withExtension: "momd")
                    expect(CoreData.ObjectModel.URL(url!).model()?.entities.count) == 1
                }
            })
            
        }
        
    }
    
}