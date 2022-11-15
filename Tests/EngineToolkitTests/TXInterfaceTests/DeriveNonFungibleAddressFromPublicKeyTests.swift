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
        XCTAssertEqual(derivedNonfungibleAddress.nonFungibleAddress, nonFungibleAddress.address.hex(), line: line)
        
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
            nonFungibleAddress: "00ed9100551d7fae91eaf413e50a3c5a59f8b96af9f1297890a8f430071a0000002ed329785cef29e562f73488c8a2bb9dbc5700b361d54b9b0554"
        ),
        (
            publicKey: "02c6047f9441ed7d6d3045406e95c07cd85c778e4b8cef3ca7abac09b95c709ee5",
            nonFungibleAddress: "00ed9100551d7fae91eaf413e50a3c5a59f8b96af9f1297890a8f430071a0000001e159887ac2c8d393a22e4476ff8212de13fe1939de2a236f0a7"
        ),
        (
            publicKey: "02f9308a019258c31049344f85f89d5229b531c845836f99b08601f113bce036f9",
            nonFungibleAddress: "00ed9100551d7fae91eaf413e50a3c5a59f8b96af9f1297890a8f430071a0000009bdad44615809cb422d2fabe9622ed706ad5d9d3ffd2cdd1c001"
        ),
        (
            publicKey: "02e493dbf1c10d80f3581e4904930b1404cc6c13900ee0758474fa94abe8c4cd13",
            nonFungibleAddress: "00ed9100551d7fae91eaf413e50a3c5a59f8b96af9f1297890a8f430071a00000051c4ae57ec1aace5f1e883d3e02a1b2c78f6909a8c0430c6fb12"
        ),
        (
            publicKey: "022f8bde4d1a07209355b4a7250a5c5128e88b84bddc619ab7cba8d569b240efe4",
            nonFungibleAddress: "00ed9100551d7fae91eaf413e50a3c5a59f8b96af9f1297890a8f430071a0000002ecc7222d8cad54a9001bb4bbdb008c43234d14678fdb1e80f1f"
        ),
        (
            publicKey: "03fff97bd5755eeea420453a14355235d382f6472f8568a18b2f057a1460297556",
            nonFungibleAddress: "00ed9100551d7fae91eaf413e50a3c5a59f8b96af9f1297890a8f430071a0000006c81be20038e5c608f2fd5d0246d8643783730df6c2bbb855cb2"
        ),
        (
            publicKey: "025cbdf0646e5db4eaa398f365f2ea7a0e3d419b7e0330e39ce92bddedcac4f9bc",
            nonFungibleAddress: "00ed9100551d7fae91eaf413e50a3c5a59f8b96af9f1297890a8f430071a0000002f2bcc0725a1682aeeeb3ac1b8e77248c34fa57fcdef29d01c53"
        ),
        (
            publicKey: "022f01e5e15cca351daff3843fb70f3c2f0a1bdd05e5af888a67784ef3e10a2a01",
            nonFungibleAddress: "00ed9100551d7fae91eaf413e50a3c5a59f8b96af9f1297890a8f430071a000000835b2a70e0bed841b4dd8926e75f6a7427ba3d90a1774beacac6"
        ),
        (
            publicKey: "03acd484e2f0c7f65309ad178a9f559abde09796974c57e714c35f110dfc27ccbe",
            nonFungibleAddress: "00ed9100551d7fae91eaf413e50a3c5a59f8b96af9f1297890a8f430071a000000143cb43a0799e67cd97a862013643287374fe91c62c6dccd9757"
        ),
        (
            publicKey: "03a0434d9e47f3c86235477c7b1ae6ae5d3442d49b1943c2b752a68e2a47e247c7",
            nonFungibleAddress: "00ed9100551d7fae91eaf413e50a3c5a59f8b96af9f1297890a8f430071a000000f45ba7568617d38ff43bf66c3fc5bb3891d751f7befb887e1537"
        ),
    ]
}
