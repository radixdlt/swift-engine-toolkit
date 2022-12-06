@testable import EngineToolkit

final class CompileNotarizedTransactionIntentTests: TestCase {
    
    override func setUp() {
        debugPrint = false
        super.setUp()
    }
    
    func test__compile_notarized_transaction_intent_does_not_throw_ed25519() throws {
        let request = try testTransactionEd25519(signerCount: 0).notarizedTransaction
        XCTAssertNoThrow(try sut.compileNotarizedTransactionIntentRequest(request: request).get())
    }
    
    func test__compile_notarized_transaction_intent_does_not_throw_secp256k1() throws {
        let request = try testTransactionSecp256k1(signerCount: 0).notarizedTransaction
        XCTAssertNoThrow(try sut.compileNotarizedTransactionIntentRequest(request: request).get())
    }
}
