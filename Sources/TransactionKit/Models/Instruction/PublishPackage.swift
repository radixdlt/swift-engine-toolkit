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
    private enum CodingKeys : String, CodingKey {
        case type = "instruction"
        case code
        case abi
    }
    
    // ======================
    // Encoding and Decoding
    // ======================
    func encode(to encoder: Encoder) throws {
        var container: KeyedEncodingContainer = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(Self.kind, forKey: .type)
        
        try container.encode(code, forKey: .code)
        try container.encode(abi, forKey: .abi)
    }
    
    init(from decoder: Decoder) throws {
        // Checking for type discriminator
        let values: KeyedDecodingContainer = try decoder.container(keyedBy: CodingKeys.self)
        let kind: InstructionKind = try values.decode(InstructionKind.self, forKey: .type)
        if kind != Self.kind {
            throw DecodeError.instructionTypeDiscriminatorMismatch(Self.kind, kind)
        }
        
        let code: Blob = try values.decode(Blob.self, forKey: .code)
        let abi: Blob = try values.decode(Blob.self, forKey: .abi)
        
        self = Self(from: code, abi: abi)
    }
}
