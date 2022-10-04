import Foundation

public struct KeyValueStore: Sendable, Codable, Hashable {
    // Type name, used as a discriminator
    public static let kind: ValueKind = ValueKind.KeyValueStore
    
    // ===============
    // Struct members
    // ===============
    
    public let identifier: String
    
    // =============
    // Constructors
    // =============
    
    init(from identifier: String) {
        self.identifier = identifier
    }
}

public extension KeyValueStore {
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
            throw DecodeError.ValueTypeDiscriminatorMismatch(Self.kind, kind)
        }
        
        // Decoding `identifier`
        identifier = try values.decode(String.self, forKey: .identifier)
    }
}
