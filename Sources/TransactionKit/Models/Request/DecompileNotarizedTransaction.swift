public struct DecompileNotarizedTransactionIntentRequest: Sendable, Codable, Hashable {
    // ===============
    // Struct members
    // ===============
    public let compiledNotarizedIntent: Array<UInt8>
    public let manifestInstructionsOutputFormat: ManifestInstructionsKind
    
    // =============
    // Constructors
    // =============
    
    init(from compiledNotarizedIntent: Array<UInt8>, manifestInstructionsOutputFormat: ManifestInstructionsKind) {
        self.compiledNotarizedIntent = compiledNotarizedIntent
        self.manifestInstructionsOutputFormat = manifestInstructionsOutputFormat
    }
    
    init(from compiledNotarizedIntent: String, manifestInstructionsOutputFormat: ManifestInstructionsKind) throws {
        self.compiledNotarizedIntent = Array<UInt8>(hex: compiledNotarizedIntent)
        self.manifestInstructionsOutputFormat = manifestInstructionsOutputFormat
    }

}
public extension DecompileNotarizedTransactionIntentRequest {
    
    // =======================
    // Coding Keys Definition
    // =======================
    private enum CodingKeys : String, CodingKey {
        case compiledNotarizedIntent = "compiled_notarized_intent"
        case manifestInstructionsOutputFormat = "manifest_instructions_output_format"
    }
    
    // ======================
    // Encoding and Decoding
    // ======================
    func encode(to encoder: Encoder) throws {
        var container: KeyedEncodingContainer = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(compiledNotarizedIntent.toHexString(), forKey: .compiledNotarizedIntent)
    }
    
    init(from decoder: Decoder) throws {
        // Checking for type discriminator
        let values: KeyedDecodingContainer = try decoder.container(keyedBy: CodingKeys.self)
        self = try Self(from: try values.decode(String.self, forKey: .compiledNotarizedIntent), manifestInstructionsOutputFormat: try values.decode(ManifestInstructionsKind.self, forKey: .manifestInstructionsOutputFormat))
    }
}

public typealias DecompileNotarizedTransactionIntentResponse = NotarizedTransaction
