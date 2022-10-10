@testable import EngineToolkit

final class DecompileNotarizedTransactionIntentTests: TestCase {
    
    func test__decompile_notarized_transaction_intent_does_not_throw() throws {
        let testTransaction = try testTransaction(signerCount: 5)
        let request = DecompileNotarizedTransactionIntentRequest(
            compiledNotarizedIntent: testTransaction.compiledNotarizedTransactionIntent,
            manifestInstructionsOutputFormat: .string
        )
        XCTAssertNoThrow(try sut.decompileNotarizedTransactionIntentRequest(request: request).get())
    }
}
