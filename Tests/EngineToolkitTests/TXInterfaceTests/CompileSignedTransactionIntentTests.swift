@testable import EngineToolkit

final class CompileSignedTransactionIntentTests: TestCase {
    
    func test__compile_signed_transaction_intent_does_not_throw() throws {
        let request = try testTransaction(signerCount: 0).notarizedTransaction.signedIntent
        XCTAssertNoThrow(try sut.compileSignedTransactionIntentRequest(request: request).get())
    }
}
