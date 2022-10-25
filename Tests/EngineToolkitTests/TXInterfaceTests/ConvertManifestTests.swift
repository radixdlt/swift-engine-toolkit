@testable import EngineToolkit

final class ConvertManifestTests: TestCase {
	
    override func setUp() {
        debugPrint = true
        super.setUp()
    }
    
    func test__convertManifest_from_string_to_json_does_not_throw_ed25519() throws {
        let request = makeRequest(outputFormat: .json, manifest: try testTransactionEd25519(signerCount: 0).notarizedTransaction.signedIntent.intent.manifest)
        XCTAssertNoThrow(try sut.convertManifest(request: request).get())
    }
	
	func test__convertManifest_from_string_to_string_returns_the_same_manifest_ed25519() throws {
        let manifest: TransactionManifest = try testTransactionEd25519(signerCount: 0).notarizedTransaction.signedIntent.intent.manifest
		let request = makeRequest(outputFormat: .string, manifest: manifest)
        let converted = try sut.convertManifest(request: request).get()
		XCTAssertEqual(manifest, converted)
	}
    
    
    func test__convertManifest_from_string_to_json_does_not_throw_secp256k1() throws {
        let request = makeRequest(outputFormat: .json, manifest: try testTransactionSecp256k1(signerCount: 0).notarizedTransaction.signedIntent.intent.manifest)
        XCTAssertNoThrow(try sut.convertManifest(request: request).get())
    }
    
    func test__convertManifest_from_string_to_string_returns_the_same_manifest_secp256k1() throws {
        let manifest: TransactionManifest = try testTransactionSecp256k1(signerCount: 0).notarizedTransaction.signedIntent.intent.manifest
        let request = makeRequest(outputFormat: .string, manifest: manifest)
        let converted = try sut.convertManifest(request: request).get()
        XCTAssertEqual(manifest, converted)
    }
}

func makeRequest(
    outputFormat: ManifestInstructionsKind = .json,
    manifest: TransactionManifest
) -> ConvertManifestRequest {
    ConvertManifestRequest(
        transactionVersion: 1,
        manifest: manifest,
        outputFormat: outputFormat,
        networkId: .simulator
    )
}

extension ResourceAddress {
    static let mock: Self = .init(address: "resource_sim1qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqshxgp7h")
}
