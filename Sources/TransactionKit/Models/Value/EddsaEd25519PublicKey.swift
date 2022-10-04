import Foundation

public struct EddsaEd25519PublicKey: Sendable, Codable, Hashable {
    // Type name, used as a discriminator
    public static let kind: ValueKind = .eddsaEd25519PublicKey
    
    // ===============
    // Struct members
    // ===============
    
    public let publicKey: Array<UInt8>
    
    // =============
    // Constructors
    // =============
    
    init(from publicKey: Array<UInt8>) {
        self.publicKey = publicKey
    }
    
    init(from publicKey: String) throws {
        // TODO: Validation of length of array
        self.publicKey = Array<UInt8>(hex: publicKey)
    }

}

public extension EddsaEd25519PublicKey {
    
    // =======================
    // Coding Keys Definition
    // =======================
    private enum CodingKeys : String, CodingKey {
        case publicKey = "public_key", type
    }
    
    // ======================
    // Encoding and Decoding
    // ======================
    func encode(to encoder: Encoder) throws {
        var container: KeyedEncodingContainer = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(Self.kind, forKey: .type)
        
        try container.encode(publicKey.toHexString(), forKey: .publicKey)
    }
    
    init(from decoder: Decoder) throws {
        // Checking for type discriminator
        let values: KeyedDecodingContainer = try decoder.container(keyedBy: CodingKeys.self)
        let kind: ValueKind = try values.decode(ValueKind.self, forKey: .type)
        if kind != Self.kind {
            throw DecodeError.valueTypeDiscriminatorMismatch(Self.kind, kind)
        }
        
        // Decoding `publicKey`
        self = try Self(from: try values.decode(String.self, forKey: .publicKey))
    }
}
