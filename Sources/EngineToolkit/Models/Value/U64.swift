import Foundation

public struct U64: Sendable, Codable, Hashable {
    // Type name, used as a discriminator
    public static let kind: ValueKind = .u64
    
    // ===============
    // Struct members
    // ===============
    public let value: UInt64
    
    // =============
    // Constructors
    // =============
    
    public init(from value: UInt64) {
        self.value = value
    }

}

public extension U64 {
    
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
            throw InternalDecodingFailure.valueTypeDiscriminatorMismatch(expected: Self.kind, butGot: kind)
        }
        
        // Decoding `value`
        let valueString: String = try container.decode(String.self, forKey: .value)
        if let value = UInt64(valueString) {
            self.value = value
        } else {
            throw InternalDecodingFailure.parsingError
        }
    }
}
