import Foundation
import Quick
import Nimble

@testable import SugarRecordCoreData

class CoreDataChangeTests: QuickSpec {
    
    override func spec() {
        
        context("Insert") {
            var change: CoreDataChange<String>!
            
            beforeSuite {
                change = .Insert(0, "insert")
            }
            
            describe("-object") {
                it("should return the correct object") {
                    expect(change.object()) == "insert"
                }
            }
            
            describe("-isDeletion") {
                it("should return false") {
                    expect(change.isDeletion()) == false
                }
            }
            
            describe("-isUpdate") {
                it("should return false") {
                    expect(change.isUpdate()) == false
                }
            }
            
            describe("-isInsertion") {
                it("should return true") {
                    expect(change.isInsertion()) == true
                }
            }
        }
        
        context("Update") {
            var change: CoreDataChange<String>!
            
            beforeSuite {
                change = .Update(0, "update")
            }
            
            describe("-object") {
                it("should return the correct object") {
                    expect(change.object()) == "update"
                }
            }
            
            describe("-isDeletion") {
                it("should return false") {
                    expect(change.isDeletion()) == false
                }
            }
            
            describe("-isUpdate") {
                it("should return true") {
                    expect(change.isUpdate()) == true
                }
            }
            
            describe("-isInsertion") {
                it("should return false") {
                    expect(change.isInsertion()) == false
                }
            }
        }
        
        context("Delete") {
            
            var change: CoreDataChange<String>!
            
            beforeSuite {
                change = .Delete(0, "delete")
            }
            
            describe("-object") {
                it("should return the correct object") {
                    expect(change.object()) == "delete"
                }
            }
            
            describe("-isDeletion") {
                it("should return true") {
                    expect(change.isDeletion()) == true
                }
            }
            
            describe("-isUpdate") {
                it("should return false") {
                    expect(change.isUpdate()) == false
                }
            }
            
            describe("-isInsertion") {
                it("should return false") {
                    expect(change.isInsertion()) == false
                }
            }
        }
    
    }
    
}