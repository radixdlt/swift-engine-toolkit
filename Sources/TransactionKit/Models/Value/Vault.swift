import Foundation

public struct Vault: Sendable, Codable, Hashable {
    // Type name, used as a discriminator
    public static let kind: ValueKind = .vault
    
    // ===============
    // Struct members
    // ===============
    
    public let identifier: String
    
    // =============
    // Constructors
    // =============
    
    public init(from identifier: String) {
        self.identifier = identifier
    }
}

public extension Vault {
    // =======================
    // Coding Keys Definition
    // =======================
    private enum CodingKeys: String, CodingKey {
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
        identifier = try values.decode(String.self, forKey: .identifier)
    }
}
