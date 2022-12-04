@testable import EngineToolkit

final class DeriveNonFungibleAddressFromPublicKeyRequestTests: TestCase {
    
    func test__encodeDecodeAddressRequest() throws {
        try TestSuite.vectors.forEach { try doTest(vector: $0) }
    }
}

private extension DeriveNonFungibleAddressFromPublicKeyRequestTests {
    func doTest(
        vector: DeriveNonFungibleAddressFromPublicKeyTestVectors.Vector,
        networkID: NetworkID = .simulator,
        line: UInt = #line
    ) throws {
   
        let derivedNonfungibleAddress = try sut.deriveNonFungibleAddressFromPublicKeyRequest(request: vector.publicKey).get()
        XCTAssertEqual(derivedNonfungibleAddress.nonFungibleAddress, vector.nonFungibleAddress, line: line)
        
    }
    typealias TestSuite = DeriveNonFungibleAddressFromPublicKeyTestVectors
}

// NOTE: We will need to update these test vectors if SBOR gets updated.
enum DeriveNonFungibleAddressFromPublicKeyTestVectors {
    typealias Vector = (publicKey: Engine.PublicKey, nonFungibleAddress: NonFungibleAddress)
    static let vectors: [Vector] = [
        (
            publicKey: try! Engine.PublicKey.ecdsaSecp256k1(Engine.EcdsaSecp256k1PublicKey(hex: "03d01115d548e7561b15c38f004d734633687cf4419620095bc5b0f47070afe85a")),
            nonFungibleAddress: try! NonFungibleAddress(hex: "00b91737ee8a4de59d49dad40de5560e5754466ac84cf5432ea95d5c20071a63535ec6738f7afe1984c128398182a5046cb006f4b6e89af817")
        ),
        (
            publicKey: try! Engine.PublicKey.eddsaEd25519(Engine.EddsaEd25519PublicKey(hex: "1262bc6d5408a3c4e025aa0c15e64f69197cdb38911be5ad344a949779df3da6")),
            nonFungibleAddress: try! NonFungibleAddress(hex: "000f8e920aa79f53349d0a99746e17b59241bd51e19abb50ad6b6a5c20071a3a2c2851b7730c6ebe6940c1ee7aa07fea4a83a3923f0708ace5")
        )
    ]
}
