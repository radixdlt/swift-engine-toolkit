import Foundation

public struct PopFromAuthZone: Sendable, Codable, Hashable {
    // Type name, used as a discriminator
    public static let kind: InstructionKind = .popFromAuthZone
    
    // ===============
    // Struct members
    // ===============
    
    public let intoProof: Proof
    
    // =============
    // Constructors
    // =============
    
    public init(from intoProof: Proof) {
        self.intoProof = intoProof
    }

}

public extension PopFromAuthZone {
    
    // =======================
    // Coding Keys Definition
    // =======================
    private enum CodingKeys: String, CodingKey {
        case type = "instruction"
        case intoProof = "into_proof"
    }
    
    // ======================
    // Encoding and Decoding
    // ======================
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(Self.kind, forKey: .type)
        
        try container.encode(intoProof, forKey: .intoProof)
    }
    
    init(from decoder: Decoder) throws {
        // Checking for type discriminator
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let kind: InstructionKind = try container.decode(InstructionKind.self, forKey: .type)
        if kind != Self.kind {
            throw DecodeError.instructionTypeDiscriminatorMismatch(Self.kind, kind)
        }
        
        let intoProof: Proof = try container.decode(Proof.self, forKey: .intoProof)
        
        self = Self(from: intoProof)
    }
}
