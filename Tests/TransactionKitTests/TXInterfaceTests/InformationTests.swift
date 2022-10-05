import XCTest
@testable import TransactionKit

final class InformationTests: XCTestCase {

    func test__information() throws {
        let information = try TX.information()
        XCTAssertEqual(information, .init(packageVersion: "0.1.0"))
    }
}
