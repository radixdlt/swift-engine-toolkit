public typealias CompileSignedTransactionIntentRequest = SignedTransactionIntent

public struct CompileSignedTransactionIntentResponse: Sendable, Codable, Hashable {
    // ===============
    // Struct members
    // ===============
    public let compiledSignedIntent: [UInt8]
    
    // =============
    // Constructors
    // =============
    
    public init(from compiledIntent: [UInt8]) {
        self.compiledSignedIntent = compiledIntent
    }
    
    public init(from compiledIntent: String) throws {
        self.compiledSignedIntent = try [UInt8](hex: compiledIntent)
    }
}

public extension CompileSignedTransactionIntentResponse {
    
    // =======================
    // Coding Keys Definition
    // =======================
    private enum CodingKeys: String, CodingKey {
        case compiledSignedIntent = "compiled_signed_intent"
    }
    
    // ======================
    // Encoding and Decoding
    // ======================
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(compiledSignedIntent.toHexString(), forKey: .compiledSignedIntent)
    }
    
    init(from decoder: Decoder) throws {
        // Checking for type discriminator
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self = try Self(from: try container.decode(String.self, forKey: .compiledSignedIntent))
    }
}
