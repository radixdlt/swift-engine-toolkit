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
   
        let nonFungibleAddress = try NonFungibleAddress(from: vector.nonFungibleAddress)
        
        let request = DeriveNonFungibleAddressRequest(from: vector.resourceAddress, nonFungibleId: vector.nonFungibleId)
        let derivedNonfungibleAddress = try sut.deriveNonFungibleAddressRequest(request: request).get()
        XCTAssertEqual(derivedNonfungibleAddress.nonFungibleAddress, nonFungibleAddress.address.toHexString(), line: line)
        
    }
    typealias TestSuite = DeriveNonFungibleAddressTestVectors
}

// NOTE: We will need to update these test vectors if SBOR gets updated.
enum DeriveNonFungibleAddressTestVectors {
    typealias Vector = (resourceAddress: String, nonFungibleId: String, nonFungibleAddress: String)
    static let vectors: [Vector] = [
        (
            resourceAddress: "resource_sim1qplejpntdzfnxytqq7q56al3rzyhw4tr8p08k9tnd4hqfjsyfu",
            nonFungibleId: "0000",
            nonFungibleAddress: "007f99066b689333116007814d77f11889775563385e7b15736d6e0000"
        ),
        (
            resourceAddress: "resource_sim1qplejpntdzfnxytqq7q56al3rzyhw4tr8p08k9tnd4hqfjsyfu",
            nonFungibleId: "0100",
            nonFungibleAddress: "007f99066b689333116007814d77f11889775563385e7b15736d6e0100"
        ),
        (
            resourceAddress: "resource_sim1qplejpntdzfnxytqq7q56al3rzyhw4tr8p08k9tnd4hqfjsyfu",
            nonFungibleId: "0101",
            nonFungibleAddress: "007f99066b689333116007814d77f11889775563385e7b15736d6e0101"
        ),

        (
            resourceAddress: "resource_sim1qplejpntdzfnxytqq7q56al3rzyhw4tr8p08k9tnd4hqfjsyfu",
            nonFungibleId: "0701",
            nonFungibleAddress: "007f99066b689333116007814d77f11889775563385e7b15736d6e0701"
        ),
        (
            resourceAddress: "resource_sim1qplejpntdzfnxytqq7q56al3rzyhw4tr8p08k9tnd4hqfjsyfu",
            nonFungibleId: "080200",
            nonFungibleAddress: "007f99066b689333116007814d77f11889775563385e7b15736d6e080200"
        ),
        (
            resourceAddress: "resource_sim1qplejpntdzfnxytqq7q56al3rzyhw4tr8p08k9tnd4hqfjsyfu",
            nonFungibleId: "0903000000",
            nonFungibleAddress: "007f99066b689333116007814d77f11889775563385e7b15736d6e0903000000"
        ),
        (
            resourceAddress: "resource_sim1qplejpntdzfnxytqq7q56al3rzyhw4tr8p08k9tnd4hqfjsyfu",
            nonFungibleId: "0a0400000000000000",
            nonFungibleAddress: "007f99066b689333116007814d77f11889775563385e7b15736d6e0a0400000000000000"
        ),
        (
            resourceAddress: "resource_sim1qplejpntdzfnxytqq7q56al3rzyhw4tr8p08k9tnd4hqfjsyfu",
            nonFungibleId: "0b05000000000000000000000000000000",
            nonFungibleAddress: "007f99066b689333116007814d77f11889775563385e7b15736d6e0b05000000000000000000000000000000"
        ),

        (
            resourceAddress: "resource_sim1qplejpntdzfnxytqq7q56al3rzyhw4tr8p08k9tnd4hqfjsyfu",
            nonFungibleId: "0206",
            nonFungibleAddress: "007f99066b689333116007814d77f11889775563385e7b15736d6e0206"
        ),
        (
            resourceAddress: "resource_sim1qplejpntdzfnxytqq7q56al3rzyhw4tr8p08k9tnd4hqfjsyfu",
            nonFungibleId: "030700",
            nonFungibleAddress: "007f99066b689333116007814d77f11889775563385e7b15736d6e030700"
        ),
        (
            resourceAddress: "resource_sim1qplejpntdzfnxytqq7q56al3rzyhw4tr8p08k9tnd4hqfjsyfu",
            nonFungibleId: "0408000000",
            nonFungibleAddress: "007f99066b689333116007814d77f11889775563385e7b15736d6e0408000000"
        ),
        (
            resourceAddress: "resource_sim1qplejpntdzfnxytqq7q56al3rzyhw4tr8p08k9tnd4hqfjsyfu",
            nonFungibleId: "050900000000000000",
            nonFungibleAddress: "007f99066b689333116007814d77f11889775563385e7b15736d6e050900000000000000"
        ),
        (
            resourceAddress: "resource_sim1qplejpntdzfnxytqq7q56al3rzyhw4tr8p08k9tnd4hqfjsyfu",
            nonFungibleId: "060a000000000000000000000000000000",
            nonFungibleAddress: "007f99066b689333116007814d77f11889775563385e7b15736d6e060a000000000000000000000000000000"
        ),

        (
            resourceAddress: "resource_sim1qplejpntdzfnxytqq7q56al3rzyhw4tr8p08k9tnd4hqfjsyfu",
            nonFungibleId: "0c0c00000048656c6c6f20576f726c6421",
            nonFungibleAddress: "007f99066b689333116007814d77f11889775563385e7b15736d6e0c0c00000048656c6c6f20576f726c6421"
        ),

        (
            resourceAddress: "resource_sim1qplejpntdzfnxytqq7q56al3rzyhw4tr8p08k9tnd4hqfjsyfu",
            nonFungibleId: "1002000000070c0c050000005261646978",
            nonFungibleAddress: "007f99066b689333116007814d77f11889775563385e7b15736d6e1002000000070c0c050000005261646978"
        ),
        (
            resourceAddress: "resource_sim1qplejpntdzfnxytqq7q56al3rzyhw4tr8p08k9tnd4hqfjsyfu",
            nonFungibleId: "11070000004661737443617202000000070c0c050000005261646978",
            nonFungibleAddress: "007f99066b689333116007814d77f11889775563385e7b15736d6e11070000004661737443617202000000070c0c050000005261646978"
        ),

        (
            resourceAddress: "resource_sim1qplejpntdzfnxytqq7q56al3rzyhw4tr8p08k9tnd4hqfjsyfu",
            nonFungibleId: "12000764",
            nonFungibleAddress: "007f99066b689333116007814d77f11889775563385e7b15736d6e12000764"
        ),
        (
            resourceAddress: "resource_sim1qplejpntdzfnxytqq7q56al3rzyhw4tr8p08k9tnd4hqfjsyfu",
            nonFungibleId: "1201",
            nonFungibleAddress: "007f99066b689333116007814d77f11889775563385e7b15736d6e1201"
        ),

        (
            resourceAddress: "resource_sim1qplejpntdzfnxytqq7q56al3rzyhw4tr8p08k9tnd4hqfjsyfu",
            nonFungibleId: "13000000",
            nonFungibleAddress: "007f99066b689333116007814d77f11889775563385e7b15736d6e13000000"
        ),
        (
            resourceAddress: "resource_sim1qplejpntdzfnxytqq7q56al3rzyhw4tr8p08k9tnd4hqfjsyfu",
            nonFungibleId: "13010000",
            nonFungibleAddress: "007f99066b689333116007814d77f11889775563385e7b15736d6e13010000"
        ),

        (
            resourceAddress: "resource_sim1qplejpntdzfnxytqq7q56al3rzyhw4tr8p08k9tnd4hqfjsyfu",
            nonFungibleId: "2007020000000c00",
            nonFungibleAddress: "007f99066b689333116007814d77f11889775563385e7b15736d6e2007020000000c00"
        ),
        (
            resourceAddress: "resource_sim1qplejpntdzfnxytqq7q56al3rzyhw4tr8p08k9tnd4hqfjsyfu",
            nonFungibleId: "3107020000000c00",
            nonFungibleAddress: "007f99066b689333116007814d77f11889775563385e7b15736d6e3107020000000c00"
        ),
        (
            resourceAddress: "resource_sim1qplejpntdzfnxytqq7q56al3rzyhw4tr8p08k9tnd4hqfjsyfu",
            nonFungibleId: "3007020000000c00",
            nonFungibleAddress: "007f99066b689333116007814d77f11889775563385e7b15736d6e3007020000000c00"
        ),
        (
            resourceAddress: "resource_sim1qplejpntdzfnxytqq7q56al3rzyhw4tr8p08k9tnd4hqfjsyfu",
            nonFungibleId: "2102000000070c0700",
            nonFungibleAddress: "007f99066b689333116007814d77f11889775563385e7b15736d6e2102000000070c0700"
        ),
        (
            resourceAddress: "resource_sim1qplejpntdzfnxytqq7q56al3rzyhw4tr8p08k9tnd4hqfjsyfu",
            nonFungibleId: "320707010000000c00",
            nonFungibleAddress: "007f99066b689333116007814d77f11889775563385e7b15736d6e320707010000000c00"
        ),
    ]
}
