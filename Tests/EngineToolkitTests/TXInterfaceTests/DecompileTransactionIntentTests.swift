@testable import EngineToolkit

final class DecompileTransactionIntentTests: TestCase {
    
    func test__decompile_transaction_intent_does_not_throw() throws {
        let testTransaction = try testTransaction(signerCount: 5)
        let request = DecompileTransactionIntentRequest(
            compiledIntent: testTransaction.compiledTransactionIntent,
            manifestInstructionsOutputFormat: .string
        )
        XCTAssertNoThrow(try sut.decompileTransactionIntentRequest(request: request).get())
    }
}
