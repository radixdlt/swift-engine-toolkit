@testable import EngineToolkit

import Difference

public func XCTAssertEqual<T: Equatable>(_ expected: @autoclosure () throws -> T, _ received: @autoclosure () throws -> T, file: StaticString = #filePath, line: UInt = #line) {
    do {
        let expected = try expected()
        let received = try received()
        XCTAssertTrue(expected == received, "Found difference for \n" + diff(expected, received).joined(separator: ", "), file: file, line: line)
    }
    catch {
        XCTFail("Caught error while testing: \(error)", file: file, line: line)
    }
}

final class ConvertManifestTests: TestCase {
	
    override func setUp() {
        debugPrint = false // set before calling super.
        super.setUp()
    }
    
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
    
    // FIXME: move out of `ConvertManifestsTests` should be in a `ResultBuilderTests`.
    func test__complex_resultBuilded() throws {
        let expected = try sut.convertManifest(request: makeRequest(outputFormat: .json, manifest: .complex)).get()
        
        let built = TransactionManifest {
            
            // Withdraw XRD from account
            CallMethod(
                componentAddress: "account_sim1q02r73u7nv47h80e30pc3q6ylsj7mgvparm3pnsm780qgsy064",
                methodName: "withdraw_by_amount",
                arguments: [
                    .decimal(5.0),
                    .resourceAddress("resource_sim1qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqzqu57yag")
                ]
            )
            
            // Buy GUM with XRD
            TakeFromWorktopByAmount(
                amount: 2.0,
                resourceAddress: "resource_sim1qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqzqu57yag",
                bucket: "xrd"
            )
            CallMethod(
                componentAddress: "component_sim1q2f9vmyrmeladvz0ejfttcztqv3genlsgpu9vue83mcs835hum",
                methodName: "buy_gumball",
                arguments: [.bucket("xrd")]
            )
            AssertWorktopContainsByAmount(amount: 3.0, resourceAddress: "resource_sim1qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqzqu57yag")
            AssertWorktopContains(resourceAddress: "resource_sim1qzhdk7tq68u8msj38r6v6yqa5myc64ejx3ud20zlh9gseqtux6")
            
            // Create a proof from bucket, clone it and drop both
            TakeFromWorktop(resourceAddress: "resource_sim1qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqzqu57yag", bucket: "some_xrd")
            CreateProofFromBucket(bucket: "some_xrd", proof: "proof1")
            CloneProof(from: "proof1", to: "proof2")
            DropProof("proof1")
            DropProof("proof2")
            
            // Create a proof from account and drop it
            CallMethod(
                componentAddress: "account_sim1q02r73u7nv47h80e30pc3q6ylsj7mgvparm3pnsm780qgsy064",
                methodName: "create_proof_by_amount",
                arguments: [
                    .decimal(5.0),
                    .resourceAddress("resource_sim1qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqzqu57yag")
                ]
            )
            PopFromAuthZone(proof: "proof3")
            DropProof("proof3")
            
            // Return a bucket to worktop
            ReturnToWorktop(bucket: "some_xrd")
            TakeFromWorktopByIds([NonFungibleId("0905000000"), "0907000000"], resourceAddress: "resource_sim1qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqzqu57yag", bucket: "nfts")
            
            // Create a new fungible resource
            // FIXME: correct translation from `CREATE_RESOURCE Enum("Fungible", 0u8) Map<String, String>() Map<Enum, Tuple>() Some(Enum("Fungible", Decimal("1.0")));` ????
            CreateResource([
                .enum(.init("Fungible", fields: [.u8(0)])),
                .map(.init(keyType: .string, valueType: .string)),
                .map(.init(keyType: .enum, valueType: .tuple)),
                .option(.some(.enum(.init("Fungible", fields: [.decimal(1.0)]))))
            ])
            
            // Cancel all buckets and move resources to account
            CallMethod(componentAddress: "account_sim1q02r73u7nv47h80e30pc3q6ylsj7mgvparm3pnsm780qgsy064", methodName: "deposit_batch", arguments: [.expression("ENTIRE_WORKTOP")])
            
            // Drop all proofs
            DropAllProofs()
            
            // Complicated method that takes all of the number types
            CallMethod(componentAddress: "component_sim1q2f9vmyrmeladvz0ejfttcztqv3genlsgpu9vue83mcs835hum", methodName: "complicated_method", arguments: [.decimal(1), .preciseDecimal(2)])
        }
        
        XCTAssertEqual(built, expected)
    }
}

private extension ConvertManifestTests {
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
}

extension ResourceAddress {
    static let mock: Self = .init(address: "resource_sim1qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqshxgp7h")
}
