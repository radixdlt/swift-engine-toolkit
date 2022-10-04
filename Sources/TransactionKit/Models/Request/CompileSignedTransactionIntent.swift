public typealias CompileSignedTransactionIntentRequest = SignedTransactionIntent

public struct CompileSignedTransactionIntentResponse: Sendable, Codable, Hashable {
    // ===============
    // Struct members
    // ===============
    public let compiledSignedIntent: Array<UInt8>
    
    // =============
    // Constructors
    // =============
    
    init(from compiledIntent: Array<UInt8>) {
        self.compiledSignedIntent = compiledIntent
    }
    
    init(from compiledIntent: String) throws {
        self.compiledSignedIntent = Array<UInt8>(hex: compiledIntent)
    }
}

public extension CompileSignedTransactionIntentResponse {
    
    // =======================
    // Coding Keys Definition
    // =======================
    private enum CodingKeys : String, CodingKey {
        case compiledSignedIntent = "compiled_signed_intent"
    }
    
    // ======================
    // Encoding and Decoding
    // ======================
    func encode(to encoder: Encoder) throws {
        var container: KeyedEncodingContainer = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(compiledSignedIntent.toHexString(), forKey: .compiledSignedIntent)
    }
    
    init(from decoder: Decoder) throws {
        // Checking for type discriminator
        let values: KeyedDecodingContainer = try decoder.container(keyedBy: CodingKeys.self)
        self = try Self(from: try values.decode(String.self, forKey: .compiledSignedIntent))
    }
}
