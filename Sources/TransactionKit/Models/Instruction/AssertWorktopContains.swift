import Foundation

public struct AssertWorktopContains: Sendable, Codable, Hashable {
    // Type name, used as a discriminator
    public static let kind: InstructionKind = .assertWorktopContains
    
    // ===============
    // Struct members
    // ===============
    
    public let resourceAddress: ResourceAddress
    
    // =============
    // Constructors
    // =============
    
    public init(from resourceAddress: ResourceAddress) {
        self.resourceAddress = resourceAddress
    }
}

public extension AssertWorktopContains {
    
    // =======================
    // Coding Keys Definition
    // =======================
    private enum CodingKeys : String, CodingKey {
        case type = "instruction"
        case resourceAddress = "resource_address"
    }
    
    // ======================
    // Encoding and Decoding
    // ======================
    func encode(to encoder: Encoder) throws {
        var container: KeyedEncodingContainer = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(Self.kind, forKey: .type)
        
        try container.encode(resourceAddress, forKey: .resourceAddress)
    }
    
    init(from decoder: Decoder) throws {
        // Checking for type discriminator
        let values: KeyedDecodingContainer = try decoder.container(keyedBy: CodingKeys.self)
        let kind: InstructionKind = try values.decode(InstructionKind.self, forKey: .type)
        if kind != Self.kind {
            throw DecodeError.instructionTypeDiscriminatorMismatch(Self.kind, kind)
        }
        
        let resourceAddress: ResourceAddress = try values.decode(ResourceAddress.self, forKey: .resourceAddress)
        
        self = Self(from: resourceAddress)
    }
}
