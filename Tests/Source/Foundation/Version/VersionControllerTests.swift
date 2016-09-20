import Foundation
import Quick
import Nimble

@testable import SugarRecord

class VersionControllerTests: QuickSpec {
    override func spec() {
        var provider: MockVersionProvider!
        var logger: MockLogger!
        var subject: VersionController!
        
        beforeSuite {
            provider = MockVersionProvider()
            logger = MockLogger()
            subject = VersionController(provider: provider, logger: logger)
        }
        
        it("should log when there's a new version") {
            subject.check()
            expect(logger.logged) == true
        }
    }
}


// MARK: - Mocking

private class MockVersionProvider: VersionProvider {
    fileprivate override func framework() -> String! {
        return "4.0.0"
    }
    fileprivate override func github(_ completion: @escaping (String) -> Void) {
        completion("4.0.1")
    }
}

private class MockLogger: Logger {
    fileprivate var logged: Bool! = false
    fileprivate override func log(_ message: String) {
        self.logged = true
    }
}
