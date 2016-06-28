import Foundation
import Quick
import Nimble

@testable import SugarRecordCoreData

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
    private override func framework() -> String! {
        return "4.0.0"
    }
    private override func github(completion: String -> Void) {
        completion("4.0.1")
    }
}

private class MockLogger: Logger {
    private var logged: Bool! = false
    private override func log(message: String) {
        self.logged = true
    }
}