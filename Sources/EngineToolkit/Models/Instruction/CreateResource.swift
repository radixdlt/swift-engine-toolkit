import Foundation

public struct CreateResource: InstructionProtocol, ExpressibleByArrayLiteral {
    // Type name, used as a discriminator
    public static let kind: InstructionKind = .createResource
    public func embed() -> Instruction {
        .createResource(self)
    }
    
    // ===============
    // Struct members
    // ===============
    
    public let args: [Value]
    
    // =============
    // Constructors
    // =============
    
    public init(_ args: [Value]) {
        self.args = args
    }
}

public extension CreateResource {
    init(arrayLiteral elements: Value...) {
        self.init(elements)
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
        
        try container.encode(args, forKey: .args)
    }
    
    init(from decoder: Decoder) throws {
        // Checking for type discriminator
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let kind: InstructionKind = try container.decode(InstructionKind.self, forKey: .type)
        if kind != Self.kind {
            throw InternalDecodingFailure.instructionTypeDiscriminatorMismatch(expected: Self.kind, butGot: kind)
        }
        
        try self.init(container.decode([Value].self, forKey: .args))
    }
}
