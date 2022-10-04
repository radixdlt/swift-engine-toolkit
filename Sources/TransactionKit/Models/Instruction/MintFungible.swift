import Foundation

public struct MintFungible: Sendable, Codable, Hashable {
    // Type name, used as a discriminator
    public static let kind: InstructionKind = .mintFungible
    
    // ===============
    // Struct members
    // ===============
    
    public let resourceAddress: ResourceAddress
    public let amount: Decimal_
    
    // =============
    // Constructors
    // =============
    
    public init(from resourceAddress: ResourceAddress, amount: Decimal_) {
        self.resourceAddress = resourceAddress
        self.amount = amount
    }
}

public extension MintFungible {
    
    // =======================
    // Coding Keys Definition
    // =======================
    private enum CodingKeys : String, CodingKey {
        case type = "instruction"
        case amount
        case resourceAddress = "resource_address"
    }
    
    // ======================
    // Encoding and Decoding
    // ======================
    func encode(to encoder: Encoder) throws {
        var container: KeyedEncodingContainer = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(Self.kind, forKey: .type)
        
        try container.encode(resourceAddress, forKey: .resourceAddress)
        try container.encode(amount, forKey: .amount)
    }
    
    init(from decoder: Decoder) throws {
        // Checking for type discriminator
        let values: KeyedDecodingContainer = try decoder.container(keyedBy: CodingKeys.self)
        let kind: InstructionKind = try values.decode(InstructionKind.self, forKey: .type)
        if kind != Self.kind {
            throw DecodeError.instructionTypeDiscriminatorMismatch(Self.kind, kind)
        }
        
        let resourceAddress: ResourceAddress = try values.decode(ResourceAddress.self, forKey: .resourceAddress)
        let amount: Decimal_ = try values.decode(Decimal_.self, forKey: .amount)
        
        self = Self(from: resourceAddress, amount: amount)
    }
}
