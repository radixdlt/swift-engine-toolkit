import Foundation

public indirect enum Instruction: Sendable, Codable, Hashable {
    // ==============
    // Enum Variants
    // ==============
    
    case CallFunctionType(CallFunction)
    case CallMethodType(CallMethod)
    
    case TakeFromWorktopType(TakeFromWorktop)
    case TakeFromWorktopByAmountType(TakeFromWorktopByAmount)
    case TakeFromWorktopByIdsType(TakeFromWorktopByIds)
    
    case ReturnToWorktopType(ReturnToWorktop)
    
    case AssertWorktopContainsType(AssertWorktopContains)
    case AssertWorktopContainsByAmountType(AssertWorktopContainsByAmount)
    case AssertWorktopContainsByIdsType(AssertWorktopContainsByIds)
    
    case PopFromAuthZoneType(PopFromAuthZone)
    case PushToAuthZoneType(PushToAuthZone)
    case ClearAuthZoneType(ClearAuthZone)
    
    case CreateProofFromAuthZoneType(CreateProofFromAuthZone)
    case CreateProofFromAuthZoneByAmountType(CreateProofFromAuthZoneByAmount)
    case CreateProofFromAuthZoneByIdsType(CreateProofFromAuthZoneByIds)
    case CreateProofFromBucketType(CreateProofFromBucket)
    
    case CloneProofType(CloneProof)
    
    case DropProofType(DropProof)
    case DropAllProofsType(DropAllProofs)
    
    case PublishPackageType(PublishPackage)
    
    case CreateResourceType(CreateResource)
    case BurnBucketType(BurnBucket)
    case MintFungibleType(MintFungible)
}

public extension Instruction {
    // =============
    // Constructors
    // =============
    
    init (from instruction: CallFunction) {
        self = Self.CallFunctionType(instruction)
    }
    init (from instruction: CallMethod) {
        self = Self.CallMethodType(instruction)
    }
    
    init (from instruction: TakeFromWorktop) {
        self = Self.TakeFromWorktopType(instruction)
    }
    init (from instruction: TakeFromWorktopByAmount) {
        self = Self.TakeFromWorktopByAmountType(instruction)
    }
    init (from instruction: TakeFromWorktopByIds) {
        self = Self.TakeFromWorktopByIdsType(instruction)
    }
    
    init (from instruction: ReturnToWorktop) {
        self = Self.ReturnToWorktopType(instruction)
    }
    
    init (from instruction: AssertWorktopContains) {
        self = Self.AssertWorktopContainsType(instruction)
    }
    init (from instruction: AssertWorktopContainsByAmount) {
        self = Self.AssertWorktopContainsByAmountType(instruction)
    }
    init (from instruction: AssertWorktopContainsByIds) {
        self = Self.AssertWorktopContainsByIdsType(instruction)
    }
    
    init (from instruction: PopFromAuthZone) {
        self = Self.PopFromAuthZoneType(instruction)
    }
    init (from instruction: PushToAuthZone) {
        self = Self.PushToAuthZoneType(instruction)
    }
    
    init (from instruction: ClearAuthZone) {
        self = Self.ClearAuthZoneType(instruction)
    }
    
    init (from instruction: CreateProofFromAuthZone) {
        self = Self.CreateProofFromAuthZoneType(instruction)
    }
    init (from instruction: CreateProofFromAuthZoneByAmount) {
        self = Self.CreateProofFromAuthZoneByAmountType(instruction)
    }
    init (from instruction: CreateProofFromAuthZoneByIds) {
        self = Self.CreateProofFromAuthZoneByIdsType(instruction)
    }
    init (from instruction: CreateProofFromBucket) {
        self = Self.CreateProofFromBucketType(instruction)
    }
    
    init (from instruction: CloneProof) {
        self = Self.CloneProofType(instruction)
    }
    init (from instruction: DropProof) {
        self = Self.DropProofType(instruction)
    }
    init (from instruction: DropAllProofs) {
        self = Self.DropAllProofsType(instruction)
    }
    
    init (from instruction: PublishPackage) {
        self = Self.PublishPackageType(instruction)
    }
    
    init (from instruction: CreateResource) {
        self = Self.CreateResourceType(instruction)
    }
    init (from instruction: BurnBucket) {
        self = Self.BurnBucketType(instruction)
    }
    init (from instruction: MintFungible) {
        self = Self.MintFungibleType(instruction)
    }
}

public extension Instruction {
    
    
    // =================
    // Instruction Kind
    // =================
    
    func kind() -> InstructionKind {
        switch self {
        case .CallFunctionType(_):
            return InstructionKind.CallFunction
        case .CallMethodType(_):
            return InstructionKind.CallMethod
            
        case .TakeFromWorktopType(_):
            return InstructionKind.TakeFromWorktop
        case .TakeFromWorktopByAmountType(_):
            return InstructionKind.TakeFromWorktopByAmount
        case .TakeFromWorktopByIdsType(_):
            return InstructionKind.TakeFromWorktopByIds
            
        case .ReturnToWorktopType(_):
            return InstructionKind.ReturnToWorktop
            
        case .AssertWorktopContainsType(_):
            return InstructionKind.AssertWorktopContains
        case .AssertWorktopContainsByAmountType(_):
            return InstructionKind.AssertWorktopContainsByAmount
        case .AssertWorktopContainsByIdsType(_):
            return InstructionKind.AssertWorktopContainsByIds
            
        case .PopFromAuthZoneType(_):
            return InstructionKind.PopFromAuthZone
        case .PushToAuthZoneType(_):
            return InstructionKind.PushToAuthZone
            
        case .ClearAuthZoneType(_):
            return InstructionKind.ClearAuthZone
            
        case .CreateProofFromAuthZoneType(_):
            return InstructionKind.CreateProofFromAuthZone
        case .CreateProofFromAuthZoneByAmountType(_):
            return InstructionKind.CreateProofFromAuthZoneByAmount
        case .CreateProofFromAuthZoneByIdsType(_):
            return InstructionKind.CreateProofFromAuthZoneByIds
        case .CreateProofFromBucketType(_):
            return InstructionKind.CreateProofFromBucket
            
        case .CloneProofType(_):
            return InstructionKind.CloneProof
        case .DropProofType(_):
            return InstructionKind.DropProof
        case .DropAllProofsType(_):
            return InstructionKind.DropAllProofs
            
        case .PublishPackageType(_):
            return InstructionKind.PublishPackage
            
        case .CreateResourceType(_):
            return InstructionKind.CreateResource
        case .BurnBucketType(_):
            return InstructionKind.BurnBucket
        case .MintFungibleType(_):
            return InstructionKind.MintFungible
        }
    }
}

public extension Instruction {
    
    // =======================
    // Coding Keys Definition
    // =======================
    private enum CodingKeys : String, CodingKey {
        case type = "instruction"
    }
    
    // ======================
    // Encoding and Decoding
    // ======================
    func encode(to encoder: Encoder) throws {
        switch self {
            case .CallFunctionType(let instruction):
                try instruction.encode(to: encoder)
            case .CallMethodType(let instruction):
                try instruction.encode(to: encoder)

            case .TakeFromWorktopType(let instruction):
                try instruction.encode(to: encoder)
            case .TakeFromWorktopByAmountType(let instruction):
                try instruction.encode(to: encoder)
            case .TakeFromWorktopByIdsType(let instruction):
                try instruction.encode(to: encoder)

            case .ReturnToWorktopType(let instruction):
                try instruction.encode(to: encoder)

            case .AssertWorktopContainsType(let instruction):
                try instruction.encode(to: encoder)
            case .AssertWorktopContainsByAmountType(let instruction):
                try instruction.encode(to: encoder)
            case .AssertWorktopContainsByIdsType(let instruction):
                try instruction.encode(to: encoder)

            case .PopFromAuthZoneType(let instruction):
                try instruction.encode(to: encoder)
            case .PushToAuthZoneType(let instruction):
                try instruction.encode(to: encoder)

            case .ClearAuthZoneType(let instruction):
                try instruction.encode(to: encoder)

            case .CreateProofFromAuthZoneType(let instruction):
                try instruction.encode(to: encoder)
            case .CreateProofFromAuthZoneByAmountType(let instruction):
                try instruction.encode(to: encoder)
            case .CreateProofFromAuthZoneByIdsType(let instruction):
                try instruction.encode(to: encoder)
            case .CreateProofFromBucketType(let instruction):
                try instruction.encode(to: encoder)

            case .CloneProofType(let instruction):
                try instruction.encode(to: encoder)
            case .DropProofType(let instruction):
                try instruction.encode(to: encoder)
            case .DropAllProofsType(let instruction):
                try instruction.encode(to: encoder)

            case .PublishPackageType(let instruction):
                try instruction.encode(to: encoder)

            case .CreateResourceType(let instruction):
                try instruction.encode(to: encoder)
            case .BurnBucketType(let instruction):
                try instruction.encode(to: encoder)
            case .MintFungibleType(let instruction):
                try instruction.encode(to: encoder)
        }
    }
    
    init(from decoder: Decoder) throws {
        // Checking for type discriminator
        let values: KeyedDecodingContainer = try decoder.container(keyedBy: CodingKeys.self)
        let kind: InstructionKind = try values.decode(InstructionKind.self, forKey: .type)
        
        switch kind {
            case .CallFunction:
                self = Self(from: try CallFunction(from: decoder))
            case .CallMethod:
                self = Self(from: try CallMethod(from: decoder))

            case .TakeFromWorktop:
                self = Self(from: try TakeFromWorktop(from: decoder))
            case .TakeFromWorktopByAmount:
                self = Self(from: try TakeFromWorktopByAmount(from: decoder))
            case .TakeFromWorktopByIds:
                self = Self(from: try TakeFromWorktopByIds(from: decoder))

            case .ReturnToWorktop:
                self = Self(from: try ReturnToWorktop(from: decoder))

            case .AssertWorktopContains:
                self = Self(from: try AssertWorktopContains(from: decoder))
            case .AssertWorktopContainsByAmount:
                self = Self(from: try AssertWorktopContainsByAmount(from: decoder))
            case .AssertWorktopContainsByIds:
                self = Self(from: try AssertWorktopContainsByIds(from: decoder))

            case .PopFromAuthZone:
                self = Self(from: try PopFromAuthZone(from: decoder))
            case .PushToAuthZone:
                self = Self(from: try PushToAuthZone(from: decoder))

            case .ClearAuthZone:
                self = Self(from: try ClearAuthZone(from: decoder))

            case .CreateProofFromAuthZone:
                self = Self(from: try CreateProofFromAuthZone(from: decoder))
            case .CreateProofFromAuthZoneByAmount:
                self = Self(from: try CreateProofFromAuthZoneByAmount(from: decoder))
            case .CreateProofFromAuthZoneByIds:
                self = Self(from: try CreateProofFromAuthZoneByIds(from: decoder))
            case .CreateProofFromBucket:
                self = Self(from: try CreateProofFromBucket(from: decoder))

            case .CloneProof:
                self = Self(from: try CloneProof(from: decoder))
            case .DropProof:
                self = Self(from: try DropProof(from: decoder))
            case .DropAllProofs:
                self = Self(from: try DropAllProofs(from: decoder))

            case .PublishPackage:
                self = Self(from: try PublishPackage(from: decoder))

            case .CreateResource:
                self = Self(from: try CreateResource(from: decoder))
            case .BurnBucket:
                self = Self(from: try BurnBucket(from: decoder))
            case .MintFungible:
                self = Self(from: try MintFungible(from: decoder))
        }
    }
}
