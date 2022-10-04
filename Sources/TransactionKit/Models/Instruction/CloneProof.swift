import Foundation

public struct CloneProof: Sendable, Codable, Hashable {
    // Type name, used as a discriminator
    public static let kind: InstructionKind = .cloneProof
    
    // ===============
    // Struct members
    // ===============
    
    public let proof: Proof
    public let intoProof: Proof
    
    // =============
    // Constructors
    // =============
    
    public init(from proof: Proof, intoProof: Proof) {
        self.proof = proof
        self.intoProof = intoProof
    }
}

public extension CloneProof {
    
    // =======================
    // Coding Keys Definition
    // =======================
    private enum CodingKeys : String, CodingKey {
        case type = "instruction"
        case proof
        case intoProof = "into_proof"
    }
    
    // ======================
    // Encoding and Decoding
    // ======================
    func encode(to encoder: Encoder) throws {
        var container: KeyedEncodingContainer = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(Self.kind, forKey: .type)
        
        try container.encode(proof, forKey: .proof)
        try container.encode(intoProof, forKey: .intoProof)
    }
    
    init(from decoder: Decoder) throws {
        // Checking for type discriminator
        let values: KeyedDecodingContainer = try decoder.container(keyedBy: CodingKeys.self)
        let kind: InstructionKind = try values.decode(InstructionKind.self, forKey: .type)
        if kind != Self.kind {
            throw DecodeError.instructionTypeDiscriminatorMismatch(Self.kind, kind)
        }
        
        let proof: Proof = try values.decode(Proof.self, forKey: .proof)
        let intoProof: Proof = try values.decode(Proof.self, forKey: .intoProof)
        
        self = Self(from: proof, intoProof: intoProof)
    }
}
