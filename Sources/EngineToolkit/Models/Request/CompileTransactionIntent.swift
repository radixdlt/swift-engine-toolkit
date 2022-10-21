public typealias CompileTransactionIntentRequest = TransactionIntent

public struct CompileTransactionIntentResponse: Sendable, Codable, Hashable {
    // MARK: Stored properties
    public let compiledIntent: [UInt8]
    
    // MARK: Init
    
    public init(from compiledIntent: [UInt8]) {
        self.compiledIntent = compiledIntent
    }
    
    public init(from compiledIntent: String) throws {
        self.compiledIntent = try [UInt8](hex: compiledIntent)
    }
}

public extension CompileTransactionIntentResponse {
    
    // MARK: CodingKeys
    private enum CodingKeys: String, CodingKey {
        case compiledIntent = "compiled_intent"
    }
    
    // MARK: Codable
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(compiledIntent.toHexString(), forKey: .compiledIntent)
    }
    
    init(from decoder: Decoder) throws {
        // Checking for type discriminator
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self = try Self(from: try container.decode(String.self, forKey: .compiledIntent))
    }
}