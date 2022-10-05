import XCTest
@testable import EngineToolkit

final class InformationTests: XCTestCase {
	
	private let sut = TX()
	
    func test__information() throws {
        let information = try sut.information()
        XCTAssertEqual(information, .init(packageVersion: "0.1.0"))
    }
}
