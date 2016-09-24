import Foundation
import Quick
import Nimble

@testable import SugarRecord

class CoreDataChangeTests: QuickSpec {
    
    override func spec() {
        
        context("Insert") {
            var change: CoreDataChange<String>!
            
            beforeSuite {
                change = .insert(0, "insert")
            }
            
            describe("-object") {
                it("should return the correct object") {
                    expect(change.object()) == "insert"
                }
            }
            
            describe("-isDeletion") {
                it("should return false") {
                    expect(change.isDeletion) == false
                }
            }
            
            describe("-isUpdate") {
                it("should return false") {
                    expect(change.isUpdate) == false
                }
            }
            
            describe("-isInsertion") {
                it("should return true") {
                    expect(change.isInsertion) == true
                }
            }
            
            describe("-index") {
                it("should return the correct index") {
                    expect(change.index()) == 0
                }
            }
        }
        
        context("Update") {
            var change: CoreDataChange<String>!
            
            beforeSuite {
                change = .update(1, "update")
            }
            
            describe("-object") {
                it("should return the correct object") {
                    expect(change.object()) == "update"
                }
            }
            
            describe("-isDeletion") {
                it("should return false") {
                    expect(change.isDeletion) == false
                }
            }
            
            describe("-isUpdate") {
                it("should return true") {
                    expect(change.isUpdate) == true
                }
            }
            
            describe("-isInsertion") {
                it("should return false") {
                    expect(change.isInsertion) == false
                }
            }
            
            describe("-index") {
                it("should return the correct index") {
                    expect(change.index()) == 1
                }
            }
        }
        
        context("Delete") {
            
            var change: CoreDataChange<String>!
            
            beforeSuite {
                change = .delete(3, "delete")
            }
            
            describe("-object") {
                it("should return the correct object") {
                    expect(change.object()) == "delete"
                }
            }
            
            describe("-isDeletion") {
                it("should return true") {
                    expect(change.isDeletion) == true
                }
            }
            
            describe("-isUpdate") {
                it("should return false") {
                    expect(change.isUpdate) == false
                }
            }
            
            describe("-isInsertion") {
                it("should return false") {
                    expect(change.isInsertion) == false
                }
            }
            
            describe("-index") {
                it("should return the correct index") {
                    expect(change.index()) == 3
                }
            }
        }
    
    }
    
}
