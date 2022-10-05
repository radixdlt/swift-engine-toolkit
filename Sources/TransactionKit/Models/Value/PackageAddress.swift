import Foundation

public struct PackageAddress: Sendable, Codable, Hashable {
    // Type name, used as a discriminator
    public static let kind: ValueKind = .packageAddress
    
    // ===============
    // Struct members
    // ===============
    
    public let address: String
    
    // =============
    // Constructors
    // =============
    
    public init(from address: String) {
        // TODO: Perform some simple Bech32m validation.
        self.address = address
    }
}

public extension PackageAddress {
    
    // =======================
    // Coding Keys Definition
    // =======================
    private enum CodingKeys: String, CodingKey {
        case address, type
    }
    
    // ======================
    // Encoding and Decoding
    // ======================
    func encode(to encoder: Encoder) throws {
        var container: KeyedEncodingContainer = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(Self.kind, forKey: .type)
        
        try container.encode(String(address), forKey: .address)
    }
    
    init(from decoder: Decoder) throws {
        // Checking for type discriminator
        let values: KeyedDecodingContainer = try decoder.container(keyedBy: CodingKeys.self)
        let kind: ValueKind = try values.decode(ValueKind.self, forKey: .type)
        if kind != Self.kind {
            throw DecodeError.valueTypeDiscriminatorMismatch(Self.kind, kind)
        }
        
        // Decoding `address`
        self = Self(from: try values.decode(String.self, forKey: .address))
    }
}
