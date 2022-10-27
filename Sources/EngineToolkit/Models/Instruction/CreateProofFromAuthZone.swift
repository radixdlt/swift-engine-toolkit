import Foundation

public struct CreateProofFromAuthZone: InstructionProtocol {
    // Type name, used as a discriminator
    public static let kind: InstructionKind = .createProofFromAuthZone
    public func embed() -> Instruction {
        .createProofFromAuthZone(self)
    }
    
    // MARK: Stored properties
    public let resourceAddress: ResourceAddress
    public let intoBucket: Bucket
    
    // MARK: Init
    
    public init(resourceAddress: ResourceAddress, intoBucket: Bucket) {
        self.resourceAddress = resourceAddress
        self.intoBucket = intoBucket
    }

}

public extension CreateProofFromAuthZone {
    
    // MARK: CodingKeys
    private enum CodingKeys: String, CodingKey {
        case type = "instruction"
        case resourceAddress = "resource_address"
        case intoBucket = "into_bucket"
    }
    
    // MARK: Codable
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
            throw InternalDecodingFailure.instructionTypeDiscriminatorMismatch(expected: Self.kind, butGot: kind)
        }
        
        try self.init(
            resourceAddress: container.decode(ResourceAddress.self, forKey: .resourceAddress),
            intoBucket: container.decode(Bucket.self, forKey: .intoBucket)
        )
    }
}
