import Foundation

public struct ReturnToWorktop: Sendable, Codable, Hashable {
    // Type name, used as a discriminator
    public static let kind: InstructionKind = .returnToWorktop
    
    // ===============
    // Struct members
    // ===============
    public let bucket: Bucket
    
    // =============
    // Constructors
    // =============
    public init(from bucket: Bucket) {
        self.bucket = bucket
    }
}

public extension ReturnToWorktop {
    // =======================
    // Coding Keys Definition
    // =======================
    private enum CodingKeys: String, CodingKey {
        case type = "instruction"
        case bucket
    }
    
    // ======================
    // Encoding and Decoding
    // ======================
    func encode(to encoder: Encoder) throws {
        var container: KeyedEncodingContainer = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(Self.kind, forKey: .type)
        
        try container.encode(bucket, forKey: .bucket)
    }
    
    init(from decoder: Decoder) throws {
        // Checking for type discriminator
        let values: KeyedDecodingContainer = try decoder.container(keyedBy: CodingKeys.self)
        let kind: InstructionKind = try values.decode(InstructionKind.self, forKey: .type)
        if kind != Self.kind {
            throw DecodeError.instructionTypeDiscriminatorMismatch(Self.kind, kind)
        }
        
        let bucket: Bucket = try values.decode(Bucket.self, forKey: .bucket)
        
        self = Self(from: bucket)
    }
}
