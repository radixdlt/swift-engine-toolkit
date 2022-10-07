import Foundation

public struct KeyValueStore: Sendable, Codable, Hashable {
    // Type name, used as a discriminator
    public static let kind: ValueKind = .keyValueStore
    
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

public extension KeyValueStore {
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
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(Self.kind, forKey: .type)
        
        try container.encode(identifier, forKey: .identifier)
    }
    
    init(from decoder: Decoder) throws {
        // Checking for type discriminator
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let kind: ValueKind = try container.decode(ValueKind.self, forKey: .type)
        if kind != Self.kind {
            throw InternalDecodingFailure.valueTypeDiscriminatorMismatch(expected: Self.kind, butGot: kind)
        }
        
        // Decoding `identifier`
        identifier = try container.decode(String.self, forKey: .identifier)
    }
}
