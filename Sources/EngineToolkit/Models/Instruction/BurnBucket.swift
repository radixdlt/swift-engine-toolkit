import Foundation

public struct BurnBucket: InstructionProtocol {
    // Type name, used as a discriminator
    public static let kind: InstructionKind = .burnBucket
    public func embed() -> Instruction {
        .burnBucket(self)
    }
    
    // MARK: Stored properties
    public let bucket: Bucket
    
    // MARK: Init
    public init(from bucket: Bucket) {
        self.bucket = bucket
    }
}

public extension BurnBucket {
    
    // MARK: CodingKeys
    private enum CodingKeys: String, CodingKey {
        case type = "instruction"
        case bucket
    }
    
    // MARK: Codable
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(Self.kind, forKey: .type)
        
        try container.encode(bucket, forKey: .bucket)
    }
    
    init(from decoder: Decoder) throws {
        // Checking for type discriminator
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let kind: InstructionKind = try container.decode(InstructionKind.self, forKey: .type)
        if kind != Self.kind {
            throw InternalDecodingFailure.instructionTypeDiscriminatorMismatch(expected: Self.kind, butGot: kind)
        }
        
        let bucket: Bucket = try container.decode(Bucket.self, forKey: .bucket)
        
        self = Self(from: bucket)
    }
}