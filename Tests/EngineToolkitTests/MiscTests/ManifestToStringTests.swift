@testable import EngineToolkit
import CryptoKit

final class ManifestToStringTests: TestCase {
    
    override func setUp() {
        debugPrint = true
        super.setUp()
    }
    
    func test_transactionManifest_toString_on_multiple_packages() throws {
        let packages = [
            (
                code: try resource(named: "hello", extension: "code"),
                abi: try resource(named: "hello", extension: "abi")
            ),
            (
                code: try resource(named: "hello_world", extension: "code"),
                abi: try resource(named: "hello_world", extension: "abi")
            ),
            (
                code: try resource(named: "RaDEX", extension: "code"),
                abi: try resource(named: "RaDEX", extension: "abi")
            ),
            (
                code: try resource(named: "account", extension: "code"),
                abi: try resource(named: "account", extension: "abi")
            ),
            (
                code: try resource(named: "faucet", extension: "code"),
                abi: try resource(named: "faucet", extension: "abi")
            )
        ]
        
        for package in packages {
            let manifestInstructions = try TransactionManifest {
                try CallMethod(
                    receiver: ComponentAddress("account_sim1qdfapg25xjpned3q5k8vcku6vdp55rs493lqtjeky9wqse9w34"),
                    methodName: "lock_fee"
                ) { try Decimal_(string: "100") }
                
                PublishPackageWithOwner(
                    code: Blob(data: sha256(data: package.code)),
                    abi: Blob(data: sha256(data: package.abi)),
                    ownerBadge: try! NonFungibleAddress(hex: "00b91737ee8a4de59d49dad40de5560e5754466ac84cf5432ea95d5c20071a63535ec6738f7afe1984c128398182a5046cb006f4b6e89af817"
                    )
                )
            }.instructions
            
            let transactionManifest = TransactionManifest(
                instructions: manifestInstructions,
                blobs: [
                    [UInt8](package.code),
                    [UInt8](package.abi)
                ]
            )
            
            for outputInstructionKind in [ManifestInstructionsKind.json, ManifestInstructionsKind.string] {
                XCTAssertNoThrow(try sut.convertManifest(request: ConvertManifestRequest(
                    transactionVersion: 0x01,
                    manifest: transactionManifest,
                    outputFormat: outputInstructionKind,
                    networkId: 0xF2
                )).get().toString(networkID: 0xF2))
            }
        }
    }
}

func resource(
    named fileName: String,
    extension fileExtension: String
) throws -> Data {
    let fileURL = Bundle.module.url(forResource: fileName, withExtension: fileExtension)
    return try Data(contentsOf: fileURL!)
}

func sha256(data : Data) -> Data {
    return SHA256.hash(data: data).data
}
