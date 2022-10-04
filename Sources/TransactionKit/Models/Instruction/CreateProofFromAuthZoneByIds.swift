import Foundation

public struct CreateProofFromAuthZoneByIds: Sendable, Codable, Hashable {
    // Type name, used as a discriminator
    public static let kind: InstructionKind = InstructionKind.CreateProofFromAuthZoneByIds
    
    // ===============
    // Struct members
    // ===============
    
    public let resourceAddress: ResourceAddress
    public let ids: Set<NonFungibleId>
    public let intoProof: Proof
    
    // =============
    // Constructors
    // =============
    
    init(from resourceAddress: ResourceAddress, ids: Set<NonFungibleId>, intoProof: Proof) {
        self.resourceAddress = resourceAddress
        self.ids = ids
        self.intoProof = intoProof
    }

}

public extension CreateProofFromAuthZoneByIds {
    
    // =======================
    // Coding Keys Definition
    // =======================
    private enum CodingKeys : String, CodingKey {
        case type = "instruction"
        case ids
        case resourceAddress = "resource_address"
        case intoProof = "into_proof"
    }
    
    // ======================
    // Encoding and Decoding
    // ======================
    func encode(to encoder: Encoder) throws {
        var container: KeyedEncodingContainer = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(Self.kind, forKey: .type)
        
        try container.encode(resourceAddress, forKey: .resourceAddress)
        try container.encode(ids, forKey: .ids)
        try container.encode(intoProof, forKey: .intoProof)
    }
    
    init(from decoder: Decoder) throws {
        // Checking for type discriminator
        let values: KeyedDecodingContainer = try decoder.container(keyedBy: CodingKeys.self)
        let kind: InstructionKind = try values.decode(InstructionKind.self, forKey: .type)
        if kind != Self.kind {
            throw DecodeError.InstructionTypeDiscriminatorMismatch(Self.kind, kind)
        }
        
        let resourceAddress: ResourceAddress = try values.decode(ResourceAddress.self, forKey: .resourceAddress)
        let ids: Set<NonFungibleId> = try values.decode(Set<NonFungibleId>.self, forKey: .ids)
        let intoProof: Proof = try values.decode(Proof.self, forKey: .intoProof)
        
        self = Self(from: resourceAddress, ids: ids, intoProof: intoProof)
    }
}
