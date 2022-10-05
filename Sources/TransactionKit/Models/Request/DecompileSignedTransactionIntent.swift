public struct DecompileSignedTransactionIntentRequest: Sendable, Codable, Hashable {
    // ===============
    // Struct members
    // ===============
    public let compiledSignedIntent: Array<UInt8>
    public let manifestInstructionsOutputFormat: ManifestInstructionsKind
    
    // =============
    // Constructors
    // =============
    
    public init(from compiledSignedIntent: Array<UInt8>, manifestInstructionsOutputFormat: ManifestInstructionsKind) {
        self.compiledSignedIntent = compiledSignedIntent
        self.manifestInstructionsOutputFormat = manifestInstructionsOutputFormat
    }
    
    public init(from compiledSignedIntent: String, manifestInstructionsOutputFormat: ManifestInstructionsKind) throws {
        self.compiledSignedIntent = Array<UInt8>(hex: compiledSignedIntent)
        self.manifestInstructionsOutputFormat = manifestInstructionsOutputFormat
    }
}

public extension DecompileSignedTransactionIntentRequest {
    
    // =======================
    // Coding Keys Definition
    // =======================
    private enum CodingKeys: String, CodingKey {
        case compiledSignedIntent = "compiled_signed_intent"
        case manifestInstructionsOutputFormat = "manifest_instructions_output_format"
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
        self = try Self(from: try values.decode(String.self, forKey: .compiledSignedIntent), manifestInstructionsOutputFormat: try values.decode(ManifestInstructionsKind.self, forKey: .manifestInstructionsOutputFormat))
    }
}

public typealias DecompileSignedTransactionIntentResponse = SignedTransactionIntent
