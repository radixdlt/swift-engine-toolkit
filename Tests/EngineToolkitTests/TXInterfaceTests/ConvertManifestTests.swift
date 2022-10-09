@testable import EngineToolkit

final class ConvertManifestTests: TestCase {
	
    
    func test__convertManifest_from_string_to_json_does_not_throw() throws {
		let request = makeRequest(outputFormat: .json)
        XCTAssertNoThrow(try sut.convertManifest(request: request).get())
    }
	
	func test__convertManifest_from_string_to_string_returns_the_same_manifest() throws {
        let manifest: TransactionManifest = .complex
		let request = makeRequest(outputFormat: .string, manifest: manifest)
        let converted = try sut.convertManifest(request: request).get()
		XCTAssertEqual(manifest, converted)
	}
    
   
}

func makeRequest(
    outputFormat: ManifestInstructionsKind = .json,
    manifest: TransactionManifest = .complex
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
