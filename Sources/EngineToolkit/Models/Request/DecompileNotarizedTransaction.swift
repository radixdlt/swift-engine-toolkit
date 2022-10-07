public struct DecompileNotarizedTransactionIntentRequest: Sendable, Codable, Hashable {
    // ===============
    // Struct members
    // ===============
    public let compiledNotarizedIntent: [UInt8]
    public let manifestInstructionsOutputFormat: ManifestInstructionsKind
    
    // =============
    // Constructors
    // =============
    
    public init(compiledNotarizedIntent: [UInt8], manifestInstructionsOutputFormat: ManifestInstructionsKind) {
        self.compiledNotarizedIntent = compiledNotarizedIntent
        self.manifestInstructionsOutputFormat = manifestInstructionsOutputFormat
    }
    
    public init(compiledNotarizedIntentHex: String, manifestInstructionsOutputFormat: ManifestInstructionsKind) throws {
        try self.init(
            compiledNotarizedIntent: [UInt8](hex: compiledNotarizedIntentHex),
            manifestInstructionsOutputFormat: manifestInstructionsOutputFormat
        )
    }

}
public extension DecompileNotarizedTransactionIntentRequest {
    
    // =======================
    // Coding Keys Definition
    // =======================
    private enum CodingKeys: String, CodingKey {
        case compiledNotarizedIntent = "compiled_notarized_intent"
        case manifestInstructionsOutputFormat = "manifest_instructions_output_format"
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
        
        try self.init(
            compiledNotarizedIntentHex: container.decode(String.self, forKey: .compiledNotarizedIntent),
            manifestInstructionsOutputFormat: container.decode(ManifestInstructionsKind.self, forKey: .manifestInstructionsOutputFormat)
        )
    }
}

public typealias DecompileNotarizedTransactionIntentResponse = NotarizedTransaction
