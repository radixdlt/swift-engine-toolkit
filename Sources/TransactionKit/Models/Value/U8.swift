import Foundation

public struct U8: Sendable, Codable, Hashable {
    // Type name, used as a discriminator
    public static let kind: ValueKind = .u8
    
    // ===============
    // Struct members
    // ===============
    public let value: UInt8
    
    // =============
    // Constructors
    // =============
    
    public init(from value: UInt8) {
        self.value = value
    }
}

public extension U8 {
    
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
        var container: KeyedEncodingContainer = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(Self.kind, forKey: .type)
        
        try container.encode(String(value), forKey: .value)
    }
    
    init(from decoder: Decoder) throws {
        // Checking for type discriminator
        let values: KeyedDecodingContainer = try decoder.container(keyedBy: CodingKeys.self)
        let kind: ValueKind = try values.decode(ValueKind.self, forKey: .type)
        if kind != Self.kind {
            throw DecodeError.valueTypeDiscriminatorMismatch(Self.kind, kind)
        }
        
        // Decoding `value`
        let valueString: String = try values.decode(String.self, forKey: .value)
        if let value = UInt8(valueString) {
            self.value = value
        } else {
            throw DecodeError.parsingError
        }
    }
}
