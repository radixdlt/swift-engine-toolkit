import Foundation

public struct CreateResource: InstructionProtocol, ExpressibleByRadixEngineValues {
    // Type name, used as a discriminator
    public static let kind: InstructionKind = .createResource
    public func embed() -> Instruction {
        .createResource(self)
    }
    
    // ===============
    // Struct members
    // ===============
    
    public let values: [Value]
    
    // =============
    // Constructors
    // =============
    
    public init(values: [Value]) {
        self.values = values
    }
}

public extension CreateResource {
    
    // =======================
    // Coding Keys Definition
    // =======================
    private enum CodingKeys: String, CodingKey {
        case type = "instruction"
        case args
    }
    
    // ======================
    // Encoding and Decoding
    // ======================
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(Self.kind, forKey: .type)
        
        try container.encode(values, forKey: .args)
    }
    
    init(from decoder: Decoder) throws {
        // Checking for type discriminator
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let kind: InstructionKind = try container.decode(InstructionKind.self, forKey: .type)
        if kind != Self.kind {
            throw InternalDecodingFailure.instructionTypeDiscriminatorMismatch(expected: Self.kind, butGot: kind)
        }
        
        try self.init(values: container.decode([Value].self, forKey: .args))
    }
}
