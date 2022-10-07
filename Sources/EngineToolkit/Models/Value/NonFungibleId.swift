import Foundation

public struct NonFungibleId: Codable, Hashable, Sendable, ExpressibleByStringLiteral {
    // Type name, used as a discriminator
    public static let kind: ValueKind = .nonFungibleId
    
    // ===============
    // Struct members
    // ===============
    
    public let bytes: [UInt8]
    
    // =============
    // Constructors
    // =============
    
    public init(bytes: [UInt8]) {
        self.bytes = bytes
    }
}

public extension NonFungibleId {
    
    init(hex: String) throws {
        try self.init(bytes: [UInt8](hex: hex))
    }

    // FIXME maybe we wanna move `ExpressibleByStringLiteral` to test since this can fatalError.
    init(stringLiteral hexString: String) {
        guard let bytes = try? [UInt8](hex: hexString) else {
            fatalError("Failed to create \(Self.self) from string, invalid hex.")
        }
        self.init(bytes: bytes)
    }
}

public extension NonFungibleId {
    
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
        
        try container.encode(bytes.toHexString(), forKey: .value)
    }
    
    init(from decoder: Decoder) throws {
        // Checking for type discriminator
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let kind: ValueKind = try container.decode(ValueKind.self, forKey: .type)
        if kind != Self.kind {
            throw InternalDecodingFailure.valueTypeDiscriminatorMismatch(expected: Self.kind, butGot: kind)
        }
        
        // Decoding `value`
        try self.init(hex: container.decode(String.self, forKey: .value))
    }
}
