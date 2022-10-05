import Foundation

public struct DropAllProofs: Sendable, Codable, Hashable {
    // Type name, used as a discriminator
    public static let kind: InstructionKind = .dropAllProofs

}

public extension DropAllProofs {
    
    // =======================
    // Coding Keys Definition
    // =======================
    private enum CodingKeys: String, CodingKey {
        case type = "instruction"
    }
    
    // ======================
    // Encoding and Decoding
    // ======================
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(Self.kind, forKey: .type)
    }
    
    init(from decoder: Decoder) throws {
        // Checking for type discriminator
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let kind: InstructionKind = try container.decode(InstructionKind.self, forKey: .type)
        if kind != Self.kind {
            throw DecodeError.instructionTypeDiscriminatorMismatch(expected: Self.kind, butGot: kind)
        }
    }
}
