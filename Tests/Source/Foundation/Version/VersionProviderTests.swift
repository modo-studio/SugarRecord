import Foundation
import Quick
import Nimble
import OHHTTPStubs

@testable import SugarRecord

class VersionProviderTests: QuickSpec {
    override func spec() {
        
        var subject: VersionProvider!
        
        beforeEach {
            subject = VersionProvider()
            _ = stub(condition: isPath("/repos/carambalabs/sugarrecord/releases")) { _ in
                let object = [["tag_name": "3.1.0"]]
                return OHHTTPStubsResponse(jsonObject: object, statusCode: 200, headers: ["Content-Type":"application/json"])
            }
        }
        
        afterEach {
            OHHTTPStubs.removeAllStubs()
        }
        
        describe("-github:completion:") {
            it("should return the version") {
                waitUntil(timeout: 10, action: { (done) in
                    subject.github({ (version) in
                        expect(version) == "3.1.0"
                        done()
                    })
                })
            }
        }
        
        describe("-framework") {
            it("should return a value") {
                expect(subject.framework()).toNot(beNil())
            }
            it("should have the correct format") {
                let regex = try! NSRegularExpression(pattern: "\\d+\\.\\d+\\.\\d+", options: [.caseInsensitive])
                let version = subject.framework()
                let correctFormat = regex.firstMatch(in: version!, options: [], range: NSMakeRange(0, version!.characters.count)) != nil
                expect(correctFormat) == true
            }
        }
    }
}
