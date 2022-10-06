import Foundation

public struct PreciseDecimal: Sendable, Codable, Hashable {
    // Type name, used as a discriminator
    public static let kind: ValueKind = .preciseDecimal
    
    // ===============
    // Struct members
    // ===============
    
    // TODO: Convert this to a better numerical type
    public let value: String
    
    // =============
    // Constructors
    // =============
    
    public init(from value: String) {
        self.value = value
    }
}

public extension PreciseDecimal {
    
    // =======================
    // Coding Keys Definition
    // =======================
    private enum CodingKeys: String, CodingKey {
        case value, type
    }
    
    // ======================
    // Encoding and Decoding
    // ======================
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(Self.kind, forKey: .type)
        
        try container.encode(String(value), forKey: .value)
    }
    
    init(from decoder: Decoder) throws {
        // Checking for type discriminator
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let kind: ValueKind = try container.decode(ValueKind.self, forKey: .type)
        if kind != Self.kind {
            throw DecodeError.valueTypeDiscriminatorMismatch(expected: Self.kind, butGot: kind)
        }
        
        // Decoding `value`
        value = try container.decode(String.self, forKey: .value)
    }
}
