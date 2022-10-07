import Foundation

public struct CreateProofFromAuthZoneByAmount: Sendable, Codable, Hashable {
    // Type name, used as a discriminator
    public static let kind: InstructionKind = .createProofFromAuthZoneByAmount
    
    // ===============
    // Struct members
    // ===============
    
    public let resourceAddress: ResourceAddress
    public let amount: Decimal_
    public let intoProof: Proof
    
    // =============
    // Constructors
    // =============
    
    public init(from resourceAddress: ResourceAddress, amount: Decimal_, intoProof: Proof) {
        self.resourceAddress = resourceAddress
        self.amount = amount
        self.intoProof = intoProof
    }

}

public extension CreateProofFromAuthZoneByAmount {
    
    // =======================
    // Coding Keys Definition
    // =======================
    private enum CodingKeys: String, CodingKey {
        case type = "instruction"
        case amount
        case resourceAddress = "resource_address"
        case intoProof = "into_proof"
    }
    
    // ======================
    // Encoding and Decoding
    // ======================
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(Self.kind, forKey: .type)
        
        try container.encode(resourceAddress, forKey: .resourceAddress)
        try container.encode(amount, forKey: .amount)
        try container.encode(intoProof, forKey: .intoProof)
    }
    
    init(from decoder: Decoder) throws {
        // Checking for type discriminator
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let kind: InstructionKind = try container.decode(InstructionKind.self, forKey: .type)
        if kind != Self.kind {
            throw InternalDecodingFailure.instructionTypeDiscriminatorMismatch(expected: Self.kind, butGot: kind)
        }
        
        let resourceAddress: ResourceAddress = try container.decode(ResourceAddress.self, forKey: .resourceAddress)
        let amount: Decimal_ = try container.decode(Decimal_.self, forKey: .amount)
        let intoProof: Proof = try container.decode(Proof.self, forKey: .intoProof)
        
        self = Self(from: resourceAddress, amount: amount, intoProof: intoProof)
    }
}
