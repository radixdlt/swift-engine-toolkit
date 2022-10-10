@testable import EngineToolkit

final class DecompileUnknownTransactionIntentTests: TestCase {
    
    func test__decompile_unknown_transaction_intent_does_not_throw_on_a_transaction_intent() throws {
        let testTransaction = try testTransaction(signerCount: 5)
        let request = DecompileUnknownTransactionIntentRequest(
            compiledUnknownIntent: testTransaction.compiledTransactionIntent,
            manifestInstructionsOutputFormat: .string
        )
        XCTAssertNoThrow(try sut.decompileUnknownTransactionIntentRequest(request: request).get())
    }
    
    func test__decompile_unknown_transaction_intent_does_not_throw_on_a_signed_transaction_intent() throws {
        let testTransaction = try testTransaction(signerCount: 5)
        let request = DecompileUnknownTransactionIntentRequest(
            compiledUnknownIntent: testTransaction.compiledSignedTransactionIntent,
            manifestInstructionsOutputFormat: .string
        )
        XCTAssertNoThrow(try sut.decompileUnknownTransactionIntentRequest(request: request).get())
    }
    
    func test__decompile_unknown_transaction_intent_does_not_throw_on_a_notarized_transaction_intent() throws {
        let testTransaction = try testTransaction(signerCount: 5)
        let request = DecompileUnknownTransactionIntentRequest(
            compiledUnknownIntent: testTransaction.compiledNotarizedTransactionIntent,
            manifestInstructionsOutputFormat: .string
        )
        XCTAssertNoThrow(try sut.decompileUnknownTransactionIntentRequest(request: request).get())
    }
}
