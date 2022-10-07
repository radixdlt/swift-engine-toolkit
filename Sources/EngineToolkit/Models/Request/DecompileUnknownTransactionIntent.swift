public struct DecompileUnknownTransactionIntentRequest: Sendable, Codable, Hashable {
    // ===============
    // Struct members
    // ===============
    public let compiledUnknownIntent: [UInt8]
    public let manifestInstructionsOutputFormat: ManifestInstructionsKind
    
    // =============
    // Constructors
    // =============
    
    public init(compiledUnknownIntent: [UInt8], manifestInstructionsOutputFormat: ManifestInstructionsKind) {
        self.compiledUnknownIntent = compiledUnknownIntent
        self.manifestInstructionsOutputFormat = manifestInstructionsOutputFormat
    }
    
    public init(compiledUnknownIntentHex: String, manifestInstructionsOutputFormat: ManifestInstructionsKind) throws {
        try self.init(
            compiledUnknownIntent: [UInt8](hex: compiledUnknownIntentHex),
            manifestInstructionsOutputFormat: manifestInstructionsOutputFormat
        )
    }
}

public extension DecompileUnknownTransactionIntentRequest {
    
    // =======================
    // Coding Keys Definition
    // =======================
    private enum CodingKeys: String, CodingKey {
        case compiledUnknownIntent = "compiled_unknown_intent"
        case manifestInstructionsOutputFormat = "manifest_instructions_output_format"
    }
    
    // ======================
    // Encoding and Decoding
    // ======================
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(compiledUnknownIntent.toHexString(), forKey: .compiledUnknownIntent)
    }
    
    init(from decoder: Decoder) throws {
        // Checking for type discriminator
        let container = try decoder.container(keyedBy: CodingKeys.self)
       
        try self.init(
            compiledUnknownIntentHex:  container.decode(String.self, forKey: .compiledUnknownIntent),
            manifestInstructionsOutputFormat: container.decode(ManifestInstructionsKind.self, forKey: .manifestInstructionsOutputFormat)
        )
    }
}

public enum DecompileUnknownTransactionIntentResponse: Sendable, Codable, Hashable {
    // ==============
    // Enum Variants
    // ==============
    
    case transactionIntent(DecompileTransactionIntentResponse)
    case signedTransactionIntent(DecompileSignedTransactionIntentResponse)
    case notarizedTransactionIntent(DecompileNotarizedTransactionIntentResponse)
}

public extension DecompileUnknownTransactionIntentResponse {
    // =======================
    // Coding Keys Definition
    // =======================
    private enum CodingKeys: String, CodingKey {
        case variant
        case type
        case field
    }
    
    // ======================
    // Encoding and Decoding
    // ======================
    func encode(to encoder: Encoder) throws {
        var container: SingleValueEncodingContainer = encoder.singleValueContainer()
        
        switch self {
            case .transactionIntent(let intent):
                try container.encode(intent)
            case .signedTransactionIntent(let intent):
                try container.encode(intent)
            case .notarizedTransactionIntent(let intent):
                try container.encode(intent)
        }
    }
    
    init(from decoder: Decoder) throws {
        // Checking for type discriminator
        let container = try decoder.singleValueContainer()
        
        do {
            self = .transactionIntent(try container.decode(DecompileTransactionIntentResponse.self))
        } catch {
            do {
                self = .signedTransactionIntent(try container.decode(DecompileSignedTransactionIntentResponse.self))
            } catch {
                self = .notarizedTransactionIntent(try container.decode(DecompileNotarizedTransactionIntentResponse.self))
            }
        }
    }
}
