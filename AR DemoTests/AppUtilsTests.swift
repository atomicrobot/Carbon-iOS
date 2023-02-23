
import SwiftUI
import XCTest
@testable import ARDemo

class AppUtilsTests: XCTestCase {
    // This isn't a super amazing test because it's very possible the values change... however, I wanted to make sure
    // our `AppUtils.localizedString` was correctly translating
    func testLocalizedString() {
        XCTAssertEqual("Loading", AppUtils.localizedString("loading"))
    }
}
