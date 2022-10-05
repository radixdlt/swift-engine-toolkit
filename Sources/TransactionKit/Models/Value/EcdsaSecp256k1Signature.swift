import Foundation

public struct EcdsaSecp256k1Signature: Sendable, Codable, Hashable {
    // Type name, used as a discriminator
    public static let kind: ValueKind = .ecdsaSecp256k1Signature
    
    // ===============
    // Struct members
    // ===============
    
    public let signature: Array<UInt8>
    
    // =============
    // Constructors
    // =============
    
    public init(from signature: Array<UInt8>) {
        self.signature = signature
    }
    
    public init(from signature: String) throws {
        // TODO: Validation of length of array
        self.signature = Array<UInt8>(hex: signature)
    }

}

public extension EcdsaSecp256k1Signature {
    
    // =======================
    // Coding Keys Definition
    // =======================
    private enum CodingKeys: String, CodingKey {
        case signature, type
    }
    
    // ======================
    // Encoding and Decoding
    // ======================
    func encode(to encoder: Encoder) throws {
        var container: KeyedEncodingContainer = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(Self.kind, forKey: .type)
        
        try container.encode(signature.toHexString(), forKey: .signature)
    }
    
    init(from decoder: Decoder) throws {
        // Checking for type discriminator
        let values: KeyedDecodingContainer = try decoder.container(keyedBy: CodingKeys.self)
        let kind: ValueKind = try values.decode(ValueKind.self, forKey: .type)
        if kind != Self.kind {
            throw DecodeError.valueTypeDiscriminatorMismatch(Self.kind, kind)
        }
        
        // Decoding `signature`
        self = try Self(from: try values.decode(String.self, forKey: .signature))
    }
}
