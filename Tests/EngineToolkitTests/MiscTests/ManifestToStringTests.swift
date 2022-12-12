@testable import EngineToolkit
import CryptoKit

final class ManifestToStringTests: TestCase {
    
    override func setUp() {
        debugPrint = false
        super.setUp()
    }
    
    func test_transactionManifest_toString_on_multiple_packages() throws {
        let packages = [
            (
				name: "hello",
                code: try resource(named: "hello", extension: "code"),
                abi: try resource(named: "hello", extension: "abi")
            ),
            (
				name: "hello_world",
                code: try resource(named: "hello_world", extension: "code"),
                abi: try resource(named: "hello_world", extension: "abi")
            ),
            (
				name: "RaDEX",
                code: try resource(named: "RaDEX", extension: "code"),
                abi: try resource(named: "RaDEX", extension: "abi")
            ),
            (
				name: "account",
                code: try resource(named: "account", extension: "code"),
                abi: try resource(named: "account", extension: "abi")
            ),
            (
				name: "faucet",
                code: try resource(named: "faucet", extension: "code"),
                abi: try resource(named: "faucet", extension: "abi")
            )
        ]
        
        for package in packages {
            let manifestInstructions = try TransactionManifest {
                try CallMethod(
                    receiver: ComponentAddress("account_tdx_24_1qlglqrjvu4tppmvmq289pjthcqcm86mcmr5v7yk3z2gqj7vayk"),
                    methodName: "lock_fee"
                ) { try Decimal_(string: "100") }
                
                PublishPackageWithOwner(
                    code: Blob(data: sha256(data: package.code)),
                    abi: Blob(data: sha256(data: package.abi)),
                    ownerBadge: NonFungibleAddress(
                        resourceAddress: .init(address: "resource_tdx_b_1qzxcrac59cy2v9lpcpmf82qel3cjj25v3k5m09rxurgqujd9fe"),
                        nonFungibleId: .u32(12)
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
                    networkId: NetworkID.nebunet
				)).get().toString(networkID: NetworkID.nebunet), "\(package) package failed")
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
