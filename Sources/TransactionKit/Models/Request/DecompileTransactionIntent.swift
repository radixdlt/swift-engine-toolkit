public struct DecompileTransactionIntentRequest: Sendable, Codable, Hashable {
    // ===============
    // Struct members
    // ===============
    public let compiledIntent: Array<UInt8>
    public let manifestInstructionsOutputFormat: ManifestInstructionsKind
    
    // =============
    // Constructors
    // =============
    
    public init(from compiledIntent: Array<UInt8>, manifestInstructionsOutputFormat: ManifestInstructionsKind) {
        self.compiledIntent = compiledIntent
        self.manifestInstructionsOutputFormat = manifestInstructionsOutputFormat
    }
    
    public init(from compiledIntent: String, manifestInstructionsOutputFormat: ManifestInstructionsKind) throws {
        self.compiledIntent = Array<UInt8>(hex: compiledIntent)
        self.manifestInstructionsOutputFormat = manifestInstructionsOutputFormat
    }
}

public extension DecompileTransactionIntentRequest {
    
    // =======================
    // Coding Keys Definition
    // =======================
    private enum CodingKeys: String, CodingKey {
        case compiledIntent = "compiled_intent"
        case manifestInstructionsOutputFormat = "manifest_instructions_output_format"
    }
    
    // ======================
    // Encoding and Decoding
    // ======================
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(compiledIntent.toHexString(), forKey: .compiledIntent)
    }
    
    init(from decoder: Decoder) throws {
        // Checking for type discriminator
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self = try Self(from: try container.decode(String.self, forKey: .compiledIntent), manifestInstructionsOutputFormat: try container.decode(ManifestInstructionsKind.self, forKey: .manifestInstructionsOutputFormat))
    }
}

public typealias DecompileTransactionIntentResponse = TransactionIntent
