import Foundation

public struct Blob: Sendable, Codable, Hashable {
    // Type name, used as a discriminator
    public static let kind: ValueKind = .blob
    
    // ===============
    // Struct members
    // ===============
    
    public let hash: Array<UInt8>
    
    // =============
    // Constructors
    // =============
    
    public init(from hash: Array<UInt8>) {
        self.hash = hash
    }
    
    public init(from hash: String) throws {
        // TODO: Validation of length of Hash
        self.hash = Array<UInt8>(hex: hash)
    }

}

public extension Blob {
    
    // =======================
    // Coding Keys Definition
    // =======================
    private enum CodingKeys : String, CodingKey {
        case hash, type
    }
    
    // ======================
    // Encoding and Decoding
    // ======================
    func encode(to encoder: Encoder) throws {
        var container: KeyedEncodingContainer = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(Self.kind, forKey: .type)
        
        try container.encode(hash.toHexString(), forKey: .hash)
    }
    
    init(from decoder: Decoder) throws {
        // Checking for type discriminator
        let values: KeyedDecodingContainer = try decoder.container(keyedBy: CodingKeys.self)
        let kind: ValueKind = try values.decode(ValueKind.self, forKey: .type)
        if kind != Self.kind {
            throw DecodeError.valueTypeDiscriminatorMismatch(Self.kind, kind)
        }
        
        // Decoding `hash`
        self = try Self(from: try values.decode(String.self, forKey: .hash))
    }
}
