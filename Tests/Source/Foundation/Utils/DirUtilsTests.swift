import Foundation
import Quick
import Nimble

@testable import SugarRecord

class DirUtilsTests: QuickSpec {
    
    override func spec() {
        
        it("should return the proper documents directory") {
            let path = documentsDirectory()
            expect(path) == NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        }
        
    }
    
}
