import Foundation

public struct CreateResource: Sendable, Codable, Hashable {
    // Type name, used as a discriminator
    public static let kind: InstructionKind = .createResource
    
    // ===============
    // Struct members
    // ===============
    
    public let args: Array<Value>
    
    // =============
    // Constructors
    // =============
    
    public init(from args: Array<Value>) {
        self.args = args
    }

}

public extension CreateResource {
    
    // =======================
    // Coding Keys Definition
    // =======================
    private enum CodingKeys : String, CodingKey {
        case type = "instruction"
        case args
    }
    
    // ======================
    // Encoding and Decoding
    // ======================
    func encode(to encoder: Encoder) throws {
        var container: KeyedEncodingContainer = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(Self.kind, forKey: .type)
        
        try container.encode(args, forKey: .args)
    }
    
    init(from decoder: Decoder) throws {
        // Checking for type discriminator
        let values: KeyedDecodingContainer = try decoder.container(keyedBy: CodingKeys.self)
        let kind: InstructionKind = try values.decode(InstructionKind.self, forKey: .type)
        if kind != Self.kind {
            throw DecodeError.instructionTypeDiscriminatorMismatch(Self.kind, kind)
        }
        
        let args: Array<Value> = try values.decode(Array<Value>.self, forKey: .args)
        
        self = Self(from: args)
    }
}
