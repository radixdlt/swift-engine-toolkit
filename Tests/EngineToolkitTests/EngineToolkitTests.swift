import EngineToolkit
import XCTest

class EngineToolkitTests: XCTestCase {
    func test_address_from_string() throws {
        let address = try Address(address: "account_tdx_e_128vkt2fur65p4hqhulfv3h0cknrppwtjsstlttkfamj4jnnpm82gsw")
        XCTAssertEqual(address.networkId(), 0x0e)
    }
}
