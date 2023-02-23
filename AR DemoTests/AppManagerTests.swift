
import XCTest
@testable import ARDemo

class AppManagerTests: XCTestCase {
    func testUpdateLoading() {
        let manager = AppManager.sharedInstance

        let expectation1 = XCTestExpectation(description: "Loading state will update to `true`")

        manager.updateLoading(true)

        // Update happens on the main thread, give it a moment to process
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            expectation1.fulfill()
        }

        wait(for: [expectation1], timeout: 0.1)

        XCTAssertTrue(manager.isLoading)

        let expectation2 = XCTestExpectation(description: "Loading state will update to `false`")

        manager.updateLoading(false)

        // Update happens on the main thread, give it a moment to process
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            expectation2.fulfill()
        }

        wait(for: [expectation2], timeout: 0.1)
        XCTAssertFalse(manager.isLoading)
    }
}
