@testable import EngineToolkit

final class CompileNotarizedTransactionIntentTests: TestCase {
    
    func test__compile_notarized_transaction_intent_does_not_throw() throws {
        let request = try testTransaction(signerCount: 0).notarizedTransaction
        XCTAssertNoThrow(try sut.compileNotarizedTransactionIntentRequest(request: request).get())
    }
}
