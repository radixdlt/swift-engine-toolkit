import Foundation

public struct I32: ValueProtocol, Sendable, Codable, Hashable, ExpressibleByIntegerLiteral {
    // Type name, used as a discriminator
    public static let kind: ValueKind = .i32
    public func embedValue() -> Value {
        .i32(self)
    }
    
    // ===============
    // Struct members
    // ===============
    public let value: Int32
    
    // =============
    // Constructors
    // =============
    
    public init(value: Int32) {
        self.value = value
    }
    
    public init(integerLiteral value: Int32) {
        self.init(value: value)
    }

}

public extension I32 {
    
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
        if let value = Int32(valueString) {
            self.init(value: value)
        } else {
            throw InternalDecodingFailure.parsingError
        }
    }
}
