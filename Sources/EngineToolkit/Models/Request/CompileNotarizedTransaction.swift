public typealias CompileNotarizedTransactionIntentRequest = NotarizedTransaction

public struct CompileNotarizedTransactionIntentResponse: Sendable, Codable, Hashable {
    // ===============
    // Struct members
    // ===============
    public let compiledNotarizedIntent: [UInt8]
    
    // =============
    // Constructors
    // =============
    
    public init(from compiledNotarizedIntent: [UInt8]) {
        self.compiledNotarizedIntent = compiledNotarizedIntent
    }
    
    public init(from compiledNotarizedIntent: String) throws {
        self.compiledNotarizedIntent = try [UInt8](hex: compiledNotarizedIntent)
    }
}

public extension CompileNotarizedTransactionIntentResponse {
    
    // =======================
    // Coding Keys Definition
    // =======================
    private enum CodingKeys: String, CodingKey {
        case compiledNotarizedIntent = "compiled_notarized_intent"
    }
    
    // ======================
    // Encoding and Decoding
    // ======================
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(compiledNotarizedIntent.toHexString(), forKey: .compiledNotarizedIntent)
    }
    
    init(from decoder: Decoder) throws {
        // Checking for type discriminator
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self = try Self(from: try container.decode(String.self, forKey: .compiledNotarizedIntent))
    }
}
