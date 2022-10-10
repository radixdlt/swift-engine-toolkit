import Foundation

public struct Vault: ValueProtocol, ExpressibleByStringLiteral {
    // Type name, used as a discriminator
    public static let kind: ValueKind = .vault
    public func embedValue() -> Value {
        .vault(self)
    }
    
    // ===============
    // Struct members
    // ===============
    
    public let identifier: String
    
    // =============
    // Constructors
    // =============
    
    public init(identifier: String) {
        self.identifier = identifier
    }
    
    public init(stringLiteral value: String) {
        self.init(identifier: value)
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
        try self.init(identifier: container.decode(String.self, forKey: .identifier))
    }
}
