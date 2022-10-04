import Foundation

public struct Bucket: Sendable, Codable, Hashable {
    // Type name, used as a discriminator
    public static let kind: ValueKind = .bucket
    
    // ===============
    // Struct members
    // ===============
    
    public let identifier: Identifier
    
    // =============
    // Constructors
    // =============
    
    init(from identifier: Identifier) {
        self.identifier = identifier
    }
    
    init(from identifier: String) {
        self.identifier = .string(identifier)
    }
    
    init(from identifier: UInt32) {
        self.identifier = .u32(identifier)
    }

}

public extension Bucket {
    
    // =======================
    // Coding Keys Definition
    // =======================
    private enum CodingKeys : String, CodingKey {
        case identifier, type
    }
    
    // ======================
    // Encoding and Decoding
    // ======================
    func encode(to encoder: Encoder) throws {
        var container: KeyedEncodingContainer = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(Self.kind, forKey: .type)
        
        try container.encode(identifier, forKey: .identifier)
    }
    
    init(from decoder: Decoder) throws {
        // Checking for type discriminator
        let values: KeyedDecodingContainer = try decoder.container(keyedBy: CodingKeys.self)
        let kind: ValueKind = try values.decode(ValueKind.self, forKey: .type)
        if kind != Self.kind {
            throw DecodeError.valueTypeDiscriminatorMismatch(Self.kind, kind)
        }
        
        // Decoding `identifier`
        self = Self(from: try values.decode(Identifier.self, forKey: .identifier))
    }
}
