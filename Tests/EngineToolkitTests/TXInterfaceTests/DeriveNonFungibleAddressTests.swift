@testable import EngineToolkit

final class DeriveNonFungibleAddressRequestTests: TestCase {
    
    func test__encodeDecodeAddressRequest() throws {
        try TestSuite.vectors.forEach { try doTest(vector: $0) }
    }
}

private extension DeriveNonFungibleAddressRequestTests {
    func doTest(
        vector: DeriveNonFungibleAddressTestVectors.Vector,
        networkID: NetworkID = .simulator,
        line: UInt = #line
    ) throws {
           
        let request = DeriveNonFungibleAddressRequest(resourceAddress: vector.resourceAddress, nonFungibleId: vector.nonFungibleId)
        let derivedNonfungibleAddress = try sut.deriveNonFungibleAddressRequest(request: request).get()
        XCTAssertEqual(derivedNonfungibleAddress.nonFungibleAddress, vector.nonFungibleAddress, line: line)
        
    }
    typealias TestSuite = DeriveNonFungibleAddressTestVectors
}

// Note: The swift side is not meant to test the full functionality of the toolkit. It is meant
// to check that the communication happens with no issues between it and the toolkit.
enum DeriveNonFungibleAddressTestVectors {
    typealias Vector = (resourceAddress: ResourceAddress, nonFungibleId: NonFungibleId, nonFungibleAddress: NonFungibleAddress)
    static let vectors: [Vector] = [
        (
            resourceAddress: .init(address: "resource_sim1qplejpntdzfnxytqq7q56al3rzyhw4tr8p08k9tnd4hqfjsyfu"),
            nonFungibleId: try! .init(hex: "5cb7065c0913000000"),
            nonFungibleAddress: try! .init(hex: "007f99066b689333116007814d77f11889775563385e7b15736d6e5c0913000000")
        ),
    ]
}
