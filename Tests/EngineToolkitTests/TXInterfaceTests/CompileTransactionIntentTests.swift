@testable import EngineToolkit

final class CompileTransactionIntentTests: TestCase {
    
    func test__compile_transaction_intent_does_not_throw() throws {
        let request = try testTransaction(signerCount: 0).notarizedTransaction.signedIntent.transactionIntent
        XCTAssertNoThrow(try sut.compileTransactionIntentRequest(request: request).get())
    }
}
