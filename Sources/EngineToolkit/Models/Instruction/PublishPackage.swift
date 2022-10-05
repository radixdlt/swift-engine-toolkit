import Foundation

public struct PublishPackage: Sendable, Codable, Hashable {
    // Type name, used as a discriminator
    public static let kind: InstructionKind = .publishPackage
    
    // ===============
    // Struct members
    // ===============
    
    public let code: Blob
    public let abi: Blob
    
    // =============
    // Constructors
    // =============
    
    public init(from code: Blob, abi: Blob) {
        self.code = code
        self.abi = abi
    }

}

public extension PublishPackage {
    
    // =======================
    // Coding Keys Definition
    // =======================
    private enum CodingKeys: String, CodingKey {
        case type = "instruction"
        case code
        case abi
    }
    
    // ======================
    // Encoding and Decoding
    // ======================
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(Self.kind, forKey: .type)
        
        try container.encode(code, forKey: .code)
        try container.encode(abi, forKey: .abi)
    }
    
    init(from decoder: Decoder) throws {
        // Checking for type discriminator
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let kind: InstructionKind = try container.decode(InstructionKind.self, forKey: .type)
        if kind != Self.kind {
            throw InternalDecodingFailure.instructionTypeDiscriminatorMismatch(expected: Self.kind, butGot: kind)
        }
        
        let code: Blob = try container.decode(Blob.self, forKey: .code)
        let abi: Blob = try container.decode(Blob.self, forKey: .abi)
        
        self = Self(from: code, abi: abi)
    }
}
