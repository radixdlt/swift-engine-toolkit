@testable import EngineToolkit

final class ConvertManifestTests: TestCase {
	
    override func setUp() {
        debugPrint = true
        super.setUp()
    }
    
    func test__convertManifest_from_string_to_json_does_not_throw() throws {
        let request = makeRequest(outputFormat: .json, manifest: try testTransaction(signerCount: 0).notarizedTransaction.signedIntent.intent.manifest)
        XCTAssertNoThrow(try sut.convertManifest(request: request).get())
    }
	
	func test__convertManifest_from_string_to_string_returns_the_same_manifest() throws {
        let manifest: TransactionManifest = try testTransaction(signerCount: 0).notarizedTransaction.signedIntent.intent.manifest
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