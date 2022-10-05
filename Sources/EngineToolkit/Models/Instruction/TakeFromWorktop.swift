import Foundation

public struct TakeFromWorktop: Sendable, Codable, Hashable {
    // Type name, used as a discriminator
    public static let kind: InstructionKind = .takeFromWorktop
    
    // ===============
    // Struct members
    // ===============
    
    public let resourceAddress: ResourceAddress
    public let intoBucket: Bucket
    
    // =============
    // Constructors
    // =============
    
    public init(from resourceAddress: ResourceAddress, intoBucket: Bucket) {
        self.resourceAddress = resourceAddress
        self.intoBucket = intoBucket
    }

}

public extension TakeFromWorktop {
    
    // =======================
    // Coding Keys Definition
    // =======================
    private enum CodingKeys: String, CodingKey {
        case type = "instruction"
        case resourceAddress = "resource_address"
        case intoBucket = "into_bucket"
    }
    
    // ======================
    // Encoding and Decoding
    // ======================
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(Self.kind, forKey: .type)
        
        try container.encode(resourceAddress, forKey: .resourceAddress)
        try container.encode(intoBucket, forKey: .intoBucket)
    }
    
    init(from decoder: Decoder) throws {
        // Checking for type discriminator
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let kind: InstructionKind = try container.decode(InstructionKind.self, forKey: .type)
        if kind != Self.kind {
            throw DecodeError.instructionTypeDiscriminatorMismatch(expected: Self.kind, butGot: kind)
        }
        
        let resourceAddress: ResourceAddress = try container.decode(ResourceAddress.self, forKey: .resourceAddress)
        let intoBucket: Bucket = try container.decode(Bucket.self, forKey: .intoBucket)
        
        self = Self(from: resourceAddress, intoBucket: intoBucket)
    }
}
