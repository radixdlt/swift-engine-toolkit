import Foundation

public struct TakeFromWorktopByIds: Sendable, Codable, Hashable {
    // Type name, used as a discriminator
    public static let kind: InstructionKind = .takeFromWorktopByIds
    
    // ===============
    // Struct members
    // ===============
    
    public let resourceAddress: ResourceAddress
    public let ids: Set<NonFungibleId>
    public let intoBucket: Bucket
    
    // =============
    // Constructors
    // =============
    
    public init(from resourceAddress: ResourceAddress, ids: Set<NonFungibleId>, intoBucket: Bucket) {
        self.resourceAddress = resourceAddress
        self.ids = ids
        self.intoBucket = intoBucket
    }

}

public extension TakeFromWorktopByIds {
    
    // =======================
    // Coding Keys Definition
    // =======================
    private enum CodingKeys: String, CodingKey {
        case type = "instruction"
        case ids
        case resourceAddress = "resource_address"
        case intoBucket = "into_bucket"
    }
    
    // ======================
    // Encoding and Decoding
    // ======================
    func encode(to encoder: Encoder) throws {
        var container: KeyedEncodingContainer = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(Self.kind, forKey: .type)
        
        try container.encode(resourceAddress, forKey: .resourceAddress)
        try container.encode(ids, forKey: .ids)
        try container.encode(intoBucket, forKey: .intoBucket)
    }
    
    init(from decoder: Decoder) throws {
        // Checking for type discriminator
        let values: KeyedDecodingContainer = try decoder.container(keyedBy: CodingKeys.self)
        let kind: InstructionKind = try values.decode(InstructionKind.self, forKey: .type)
        if kind != Self.kind {
            throw DecodeError.instructionTypeDiscriminatorMismatch(Self.kind, kind)
        }
        
        let resourceAddress: ResourceAddress = try values.decode(ResourceAddress.self, forKey: .resourceAddress)
        let ids: Set<NonFungibleId> = try values.decode(Set<NonFungibleId>.self, forKey: .ids)
        let intoBucket: Bucket = try values.decode(Bucket.self, forKey: .intoBucket)
        
        self = Self(from: resourceAddress, ids: ids, intoBucket: intoBucket)
    }
}
