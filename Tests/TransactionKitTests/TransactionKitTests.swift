import XCTest
@testable import TransactionKit

final class TransactionKitTests: XCTestCase {

    func testExample() throws {
        let information = TX.information_()
        XCTAssertEqual(information, .init(packageVersion: "0.1.0"))
    }
}
