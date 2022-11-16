@testable import EngineToolkit

final class DeriveVirtualAccountAddressRequestTests: TestCase {
    
    override func setUp() {
        debugPrint = true
        super.setUp()
        continueAfterFailure = false
    }
    
    func test__encodeDecodeAddressRequest() throws {
        try TestSuite.vectors.forEach { try doTest(vector: $0) }
    }
}

private extension DeriveVirtualAccountAddressRequestTests {
    func doTest(
        vector: DeriveVirtualAccountAddressTestVectors.Vector,
        networkID: NetworkID = .simulator,
        line: UInt = #line
    ) throws {
   
        let expectedVirtualAccountComponentAddress = ComponentAddress(address: vector.virtualAccountComponentAddress)
        let publicKey = try Engine.PublicKey.ecdsaSecp256k1(Engine.EcdsaSecp256k1PublicKey(hex: vector.publicKey))
        
        let derivedVirtualAccountAddress = try sut.deriveVirtualAccountAddressRequest(
            request: DeriveVirtualAccountAddressRequest(
                publicKey: publicKey,
                networkId: NetworkID(0xF2)
            )
        ).get()
        XCTAssertEqual(
            derivedVirtualAccountAddress.componentAddress(),
            expectedVirtualAccountComponentAddress,
            line: line
        )
        
    }
    typealias TestSuite = DeriveVirtualAccountAddressTestVectors
}

enum DeriveVirtualAccountAddressTestVectors {
    typealias Vector = (publicKey: String, virtualAccountComponentAddress: String)
    static let vectors: [Vector] = [
        (
            publicKey: "0279be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798",
            virtualAccountComponentAddress: "account_sim1q5hdx2tctnhjnetz7u6g3j9zhwwmc4cqkdsa2jumq42qhrv6m0"
        ),
    ]
}
