@testable import EngineToolkit

final class DecompileSignedTransactionIntentTests: TestCase {
    
    func test__decompile_signed_transaction_intent_does_not_throw() throws {
        let testTransaction = try testTransaction(signerCount: 5)
        let request = DecompileSignedTransactionIntentRequest(
            compiledSignedIntent: testTransaction.compiledSignedTransactionIntent,
            manifestInstructionsOutputFormat: .string
        )
        XCTAssertNoThrow(try sut.decompileSignedTransactionIntentRequest(request: request).get())
    }
}
