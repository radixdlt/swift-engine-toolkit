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
   
        let nonFungibleAddress = try NonFungibleAddress(hex: vector.nonFungibleAddress)
        let publicKey = try Engine.PublicKey.ecdsaSecp256k1(Engine.EcdsaSecp256k1PublicKey(hex: vector.publicKey))
        
        let derivedNonfungibleAddress = try sut.deriveNonFungibleAddressFromPublicKeyRequest(request: publicKey).get()
        XCTAssertEqual(derivedNonfungibleAddress.nonFungibleAddress, nonFungibleAddress.address.toHexString(), line: line)
        
    }
    typealias TestSuite = DeriveNonFungibleAddressFromPublicKeyTestVectors
}

// NOTE: We will need to update these test vectors if SBOR gets updated.
// TODO: For now, all tests use Ecdsa Secp251k1 public keys and NonFungibleAddresses. We need to also add EdDSA Ed25519
enum DeriveNonFungibleAddressFromPublicKeyTestVectors {
    typealias Vector = (publicKey: String, nonFungibleAddress: String)
    static let vectors: [Vector] = [
        (
            publicKey: "0279be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798",
            nonFungibleAddress: "0000000000000000000000000000000000000000000000000000023007210000000279be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798"
        ),
        (
            publicKey: "02c6047f9441ed7d6d3045406e95c07cd85c778e4b8cef3ca7abac09b95c709ee5",
            nonFungibleAddress: "00000000000000000000000000000000000000000000000000000230072100000002c6047f9441ed7d6d3045406e95c07cd85c778e4b8cef3ca7abac09b95c709ee5"
        ),
        (
            publicKey: "02f9308a019258c31049344f85f89d5229b531c845836f99b08601f113bce036f9",
            nonFungibleAddress: "00000000000000000000000000000000000000000000000000000230072100000002f9308a019258c31049344f85f89d5229b531c845836f99b08601f113bce036f9"
        ),
        (
            publicKey: "02e493dbf1c10d80f3581e4904930b1404cc6c13900ee0758474fa94abe8c4cd13",
            nonFungibleAddress: "00000000000000000000000000000000000000000000000000000230072100000002e493dbf1c10d80f3581e4904930b1404cc6c13900ee0758474fa94abe8c4cd13"
        ),
        (
            publicKey: "022f8bde4d1a07209355b4a7250a5c5128e88b84bddc619ab7cba8d569b240efe4",
            nonFungibleAddress: "000000000000000000000000000000000000000000000000000002300721000000022f8bde4d1a07209355b4a7250a5c5128e88b84bddc619ab7cba8d569b240efe4"
        ),
        (
            publicKey: "03fff97bd5755eeea420453a14355235d382f6472f8568a18b2f057a1460297556",
            nonFungibleAddress: "00000000000000000000000000000000000000000000000000000230072100000003fff97bd5755eeea420453a14355235d382f6472f8568a18b2f057a1460297556"
        ),
        (
            publicKey: "025cbdf0646e5db4eaa398f365f2ea7a0e3d419b7e0330e39ce92bddedcac4f9bc",
            nonFungibleAddress: "000000000000000000000000000000000000000000000000000002300721000000025cbdf0646e5db4eaa398f365f2ea7a0e3d419b7e0330e39ce92bddedcac4f9bc"
        ),
        (
            publicKey: "022f01e5e15cca351daff3843fb70f3c2f0a1bdd05e5af888a67784ef3e10a2a01",
            nonFungibleAddress: "000000000000000000000000000000000000000000000000000002300721000000022f01e5e15cca351daff3843fb70f3c2f0a1bdd05e5af888a67784ef3e10a2a01"
        ),
        (
            publicKey: "03acd484e2f0c7f65309ad178a9f559abde09796974c57e714c35f110dfc27ccbe",
            nonFungibleAddress: "00000000000000000000000000000000000000000000000000000230072100000003acd484e2f0c7f65309ad178a9f559abde09796974c57e714c35f110dfc27ccbe"
        ),
        (
            publicKey: "03a0434d9e47f3c86235477c7b1ae6ae5d3442d49b1943c2b752a68e2a47e247c7",
            nonFungibleAddress: "00000000000000000000000000000000000000000000000000000230072100000003a0434d9e47f3c86235477c7b1ae6ae5d3442d49b1943c2b752a68e2a47e247c7"
        )
    ]
}
