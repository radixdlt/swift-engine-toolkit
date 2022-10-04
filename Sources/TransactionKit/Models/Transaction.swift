import Foundation

public enum ManifestInstructionsKind: String, Codable, Hashable, Sendable {
    case string
    case json
}

public enum ManifestInstructions: Sendable, Codable, Hashable {
    // ==============
    // Enum Variants
    // ==============
    
    case stringInstructions(String)
    case jsonInstructions(Array<Instruction>)
}

public extension ManifestInstructions {
    
    // =======================
    // Coding Keys Definition
    // =======================
    private enum CodingKeys : String, CodingKey {
        case type
        case value
    }
    
    // ======================
    // Encoding and Decoding
    // ======================
    func encode(to encoder: Encoder) throws {
        var container: KeyedEncodingContainer = encoder.container(keyedBy: CodingKeys.self)
        
        switch self {
            case .stringInstructions(let value):
                try container.encode(ManifestInstructionsKind.string, forKey: .type)
                try container.encode(value, forKey: .value)
            case .jsonInstructions(let value):
                try container.encode(ManifestInstructionsKind.json, forKey: .type)
                try container.encode(value, forKey: .value)
        }
    }
    
    init(from decoder: Decoder) throws {
        // Checking for type discriminator
        let values: KeyedDecodingContainer = try decoder.container(keyedBy: CodingKeys.self)
        let manifestInstructionsKind: ManifestInstructionsKind = try values.decode(ManifestInstructionsKind.self, forKey: .type)
        
        switch manifestInstructionsKind {
            case .string:
                let manifestInstructions: String = try values.decode(String.self, forKey: .value)
                self = Self.stringInstructions(manifestInstructions)
            case .json:
                let manifestInstructions: Array<Instruction> = try values.decode(Array<Instruction>.self, forKey: .value)
                self = Self.jsonInstructions(manifestInstructions)
        }
    }
}

public struct TransactionManifest: Sendable, Codable, Hashable {
    // ===============
    // Struct members
    // ===============
    
    public let instructions: ManifestInstructions
    public let blobs: Array<Array<UInt8>>
    
    // =============
    // Constructors
    // =============
    
    init(from instructions: ManifestInstructions, blobs: Array<Array<UInt8>>) {
        self.instructions = instructions
        self.blobs = blobs
    }
    
    // =======================
    // Coding Keys Definition
    // =======================
    private enum CodingKeys : String, CodingKey {
        case type
        case instructions
        case blobs
    }
}

public extension TransactionManifest {
    
    // ======================
    // Encoding and Decoding
    // ======================
    func encode(to encoder: Encoder) throws {
        var container: KeyedEncodingContainer = encoder.container(keyedBy: CodingKeys.self)
        let hexBlobs: Array<String> = blobs.map { $0.toHexString() }
        
        try container.encode(instructions, forKey: .instructions)
        try container.encode(hexBlobs, forKey: .blobs)
    }
    
    init(from decoder: Decoder) throws {
        // Checking for type discriminator
        let values: KeyedDecodingContainer = try decoder.container(keyedBy: CodingKeys.self)
        
        let instructions: ManifestInstructions = try values.decode(ManifestInstructions.self, forKey: .instructions)
        let hexBlobs: Array<String>;
        do {
            hexBlobs = try values.decode(Array<String>.self, forKey: .blobs)
        } catch {
            hexBlobs = Array<String>()
        }
        let blobs: Array<Array<UInt8>> = hexBlobs.map { Array<UInt8>(hex: $0) }
        
        self = Self(from: instructions, blobs: blobs)
    }
}

public struct TransactionHeader: Sendable, Codable, Hashable {
    public let version: UInt8
    public let networkId: UInt8
    public let startEpochInclusive: UInt64
    public let endEpochExclusive: UInt64
    public let nonce: UInt64
    public let publicKey: PublicKey
    public let notaryAsSignature: Bool
    public let costUnitLimit: UInt32
    public let tipPercentage: UInt32
    
    private enum CodingKeys : String, CodingKey {
        case version = "version"
        case networkId = "network_id"
        case startEpochInclusive = "start_epoch_inclusive"
        case endEpochExclusive = "end_epoch_exclusive"
        case nonce = "nonce"
        case publicKey = "notary_public_key"
        case notaryAsSignature = "notary_as_signatory"
        case costUnitLimit = "cost_unit_limit"
        case tipPercentage = "tip_percentage"
    }
}

public struct TransactionIntent: Sendable, Codable, Hashable {
    public let header: TransactionHeader
    public let manifest: TransactionManifest
}

public struct SignedTransactionIntent: Sendable, Codable, Hashable {
    public let transactionIntent: TransactionIntent
    public let signatures: Array<SignatureWithPublicKey>
    
    private enum CodingKeys : String, CodingKey {
        case transactionIntent = "transaction_intent"
        case signatures = "signatures"
    }
}

public struct NotarizedTransaction: Sendable, Codable, Hashable {
    public let signedIntent: SignedTransactionIntent
    public let notarySignature: Signature
    
    private enum CodingKeys : String, CodingKey {
        case signedIntent = "signed_intent"
        case notarySignature = "notary_signature"
    }
}
