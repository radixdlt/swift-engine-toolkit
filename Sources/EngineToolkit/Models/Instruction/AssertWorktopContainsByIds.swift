import Foundation

public struct AssertWorktopContainsByIds: InstructionProtocol {
    // Type name, used as a discriminator
    public static let kind: InstructionKind = .assertWorktopContainsByIds
    public func embed() -> Instruction {
        .assertWorktopContainsByIds(self)
    }
    
    // ===============
    // Struct members
    // ===============
    
    public let resourceAddress: ResourceAddress
    public let ids: Set<NonFungibleId>
    
    // =============
    // Constructors
    // =============
    
    public init(from resourceAddress: ResourceAddress, ids: Set<NonFungibleId>) {
        self.resourceAddress = resourceAddress
        self.ids = ids
    }
}

public extension AssertWorktopContainsByIds {
    
    // =======================
    // Coding Keys Definition
    // =======================
    private enum CodingKeys: String, CodingKey {
        case type = "instruction"
        case ids
        case resourceAddress = "resource_address"
    }
    
    // ======================
    // Encoding and Decoding
    // ======================
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(Self.kind, forKey: .type)
        
        try container.encode(resourceAddress, forKey: .resourceAddress)
        try container.encode(ids, forKey: .ids)
    }
    
    init(from decoder: Decoder) throws {
        // Checking for type discriminator
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let kind: InstructionKind = try container.decode(InstructionKind.self, forKey: .type)
        if kind != Self.kind {
            throw InternalDecodingFailure.instructionTypeDiscriminatorMismatch(expected: Self.kind, butGot: kind)
        }
        
        let resourceAddress: ResourceAddress = try container.decode(ResourceAddress.self, forKey: .resourceAddress)
        let ids: Set<NonFungibleId> = try container.decode(Set<NonFungibleId>.self, forKey: .ids)
        
        self = Self(from: resourceAddress, ids: ids)
    }
}
