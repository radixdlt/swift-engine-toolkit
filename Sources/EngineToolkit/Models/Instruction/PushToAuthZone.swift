import Foundation

public struct PushToAuthZone: Sendable, Codable, Hashable {
    // Type name, used as a discriminator
    public static let kind: InstructionKind = .pushToAuthZone
    
    // ===============
    // Struct members
    // ===============
    
    public let proof: Proof
    
    // =============
    // Constructors
    // =============
    
    public init(from proof: Proof) {
        self.proof = proof
    }
}

public extension PushToAuthZone {
    
    // =======================
    // Coding Keys Definition
    // =======================
    private enum CodingKeys: String, CodingKey {
        case type = "instruction"
        case proof
    }
    
    // ======================
    // Encoding and Decoding
    // ======================
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(Self.kind, forKey: .type)
        
        try container.encode(proof, forKey: .proof)
    }
    
    init(from decoder: Decoder) throws {
        // Checking for type discriminator
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let kind: InstructionKind = try container.decode(InstructionKind.self, forKey: .type)
        if kind != Self.kind {
            throw DecodeError.instructionTypeDiscriminatorMismatch(Self.kind, kind)
        }
        
        let proof: Proof = try container.decode(Proof.self, forKey: .proof)
        
        self = Self(from: proof)
    }
}
