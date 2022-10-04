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
    
    init(from proof: Proof) {
        self.proof = proof
    }
}

public extension PushToAuthZone {
    
    // =======================
    // Coding Keys Definition
    // =======================
    private enum CodingKeys : String, CodingKey {
        case type = "instruction"
        case proof
    }
    
    // ======================
    // Encoding and Decoding
    // ======================
    func encode(to encoder: Encoder) throws {
        var container: KeyedEncodingContainer = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(Self.kind, forKey: .type)
        
        try container.encode(proof, forKey: .proof)
    }
    
    init(from decoder: Decoder) throws {
        // Checking for type discriminator
        let values: KeyedDecodingContainer = try decoder.container(keyedBy: CodingKeys.self)
        let kind: InstructionKind = try values.decode(InstructionKind.self, forKey: .type)
        if kind != Self.kind {
            throw DecodeError.instructionTypeDiscriminatorMismatch(Self.kind, kind)
        }
        
        let proof: Proof = try values.decode(Proof.self, forKey: .proof)
        
        self = Self(from: proof)
    }
}
