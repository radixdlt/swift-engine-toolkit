import Foundation

public struct Boolean: ValueProtocol, ExpressibleByBooleanLiteral {
    // Type name, used as a discriminator
    public static let kind: ValueKind = .bool
    public func embedValue() -> Value {
        .boolean(self)
    }
    
    // ===============
    // Struct members
    // ===============
    public let value: Bool
    
    // =============
    // Constructors
    // =============
    
    public init(value: Bool) {
        self.value = value
    }
    
    public init(booleanLiteral value: Bool) {
        self.init(value: value)
    }
}

public extension Boolean {
    
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
        
        try container.encode(value, forKey: .value)
    }
    
    init(from decoder: Decoder) throws {
        // Checking for type discriminator
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let kind: ValueKind = try container.decode(ValueKind.self, forKey: .type)
        if kind != Self.kind {
            throw InternalDecodingFailure.valueTypeDiscriminatorMismatch(expected: Self.kind, butGot: kind)
        }
        
        // Decoding `value`
        try self.init(value: container.decode(Bool.self, forKey: .value))
    }
}
