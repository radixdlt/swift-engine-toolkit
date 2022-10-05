import Foundation

public indirect enum Instruction: Sendable, Codable, Hashable {
    // ==============
    // Enum Variants
    // ==============
    
    case callFunctionType(CallFunction)
    case callMethodType(CallMethod)
    
    case takeFromWorktopType(TakeFromWorktop)
    case takeFromWorktopByAmountType(TakeFromWorktopByAmount)
    case takeFromWorktopByIdsType(TakeFromWorktopByIds)
    
    case returnToWorktopType(ReturnToWorktop)
    
    case assertWorktopContainsType(AssertWorktopContains)
    case assertWorktopContainsByAmountType(AssertWorktopContainsByAmount)
    case assertWorktopContainsByIdsType(AssertWorktopContainsByIds)
    
    case popFromAuthZoneType(PopFromAuthZone)
    case pushToAuthZoneType(PushToAuthZone)
    case clearAuthZoneType(ClearAuthZone)
    
    case createProofFromAuthZoneType(CreateProofFromAuthZone)
    case createProofFromAuthZoneByAmountType(CreateProofFromAuthZoneByAmount)
    case createProofFromAuthZoneByIdsType(CreateProofFromAuthZoneByIds)
    case createProofFromBucketType(CreateProofFromBucket)
    
    case cloneProofType(CloneProof)
    
    case dropProofType(DropProof)
    case dropAllProofsType(DropAllProofs)
    
    case publishPackageType(PublishPackage)
    
    case createResourceType(CreateResource)
    case burnBucketType(BurnBucket)
    case mintFungibleType(MintFungible)
}

public extension Instruction {
    // =============
    // Constructors
    // =============
    
    init(from instruction: CallFunction) {
        self = .callFunctionType(instruction)
    }
    init(from instruction: CallMethod) {
        self = .callMethodType(instruction)
    }
    
    init(from instruction: TakeFromWorktop) {
        self = .takeFromWorktopType(instruction)
    }
    init(from instruction: TakeFromWorktopByAmount) {
        self = .takeFromWorktopByAmountType(instruction)
    }
    init(from instruction: TakeFromWorktopByIds) {
        self = .takeFromWorktopByIdsType(instruction)
    }
    
    init(from instruction: ReturnToWorktop) {
        self = .returnToWorktopType(instruction)
    }
    
    init(from instruction: AssertWorktopContains) {
        self = .assertWorktopContainsType(instruction)
    }
    init(from instruction: AssertWorktopContainsByAmount) {
        self = .assertWorktopContainsByAmountType(instruction)
    }
    init(from instruction: AssertWorktopContainsByIds) {
        self = .assertWorktopContainsByIdsType(instruction)
    }
    
    init(from instruction: PopFromAuthZone) {
        self = .popFromAuthZoneType(instruction)
    }
    init(from instruction: PushToAuthZone) {
        self = .pushToAuthZoneType(instruction)
    }
    
    init(from instruction: ClearAuthZone) {
        self = .clearAuthZoneType(instruction)
    }
    
    init(from instruction: CreateProofFromAuthZone) {
        self = .createProofFromAuthZoneType(instruction)
    }
    init(from instruction: CreateProofFromAuthZoneByAmount) {
        self = .createProofFromAuthZoneByAmountType(instruction)
    }
    init(from instruction: CreateProofFromAuthZoneByIds) {
        self = .createProofFromAuthZoneByIdsType(instruction)
    }
    init(from instruction: CreateProofFromBucket) {
        self = .createProofFromBucketType(instruction)
    }
    
    init(from instruction: CloneProof) {
        self = .cloneProofType(instruction)
    }
    init(from instruction: DropProof) {
        self = .dropProofType(instruction)
    }
    init(from instruction: DropAllProofs) {
        self = .dropAllProofsType(instruction)
    }
    
    init(from instruction: PublishPackage) {
        self = .publishPackageType(instruction)
    }
    
    init(from instruction: CreateResource) {
        self = .createResourceType(instruction)
    }
    init(from instruction: BurnBucket) {
        self = .burnBucketType(instruction)
    }
    init(from instruction: MintFungible) {
        self = .mintFungibleType(instruction)
    }
}

public extension Instruction {
    
    
    // =================
    // Instruction Kind
    // =================
    
    func kind() -> InstructionKind {
        switch self {
        case .callFunctionType(_):
            return .callFunction
        case .callMethodType(_):
            return .callMethod
            
        case .takeFromWorktopType(_):
            return .takeFromWorktop
        case .takeFromWorktopByAmountType(_):
            return .takeFromWorktopByAmount
        case .takeFromWorktopByIdsType(_):
            return .takeFromWorktopByIds
            
        case .returnToWorktopType(_):
            return .returnToWorktop
            
        case .assertWorktopContainsType(_):
            return .assertWorktopContains
        case .assertWorktopContainsByAmountType(_):
            return .assertWorktopContainsByAmount
        case .assertWorktopContainsByIdsType(_):
            return .assertWorktopContainsByIds
            
        case .popFromAuthZoneType(_):
            return .popFromAuthZone
        case .pushToAuthZoneType(_):
            return .pushToAuthZone
            
        case .clearAuthZoneType(_):
            return .clearAuthZone
            
        case .createProofFromAuthZoneType(_):
            return .createProofFromAuthZone
        case .createProofFromAuthZoneByAmountType(_):
            return .createProofFromAuthZoneByAmount
        case .createProofFromAuthZoneByIdsType(_):
            return .createProofFromAuthZoneByIds
        case .createProofFromBucketType(_):
            return .createProofFromBucket
            
        case .cloneProofType(_):
            return .cloneProof
        case .dropProofType(_):
            return .dropProof
        case .dropAllProofsType(_):
            return .dropAllProofs
            
        case .publishPackageType(_):
            return .publishPackage
            
        case .createResourceType(_):
            return .createResource
        case .burnBucketType(_):
            return .burnBucket
        case .mintFungibleType(_):
            return .mintFungible
        }
    }
}

public extension Instruction {
    
    // =======================
    // Coding Keys Definition
    // =======================
    private enum CodingKeys: String, CodingKey {
        case type = "instruction"
    }
    
    // ======================
    // Encoding and Decoding
    // ======================
    func encode(to encoder: Encoder) throws {
        switch self {
            case .callFunctionType(let instruction):
                try instruction.encode(to: encoder)
            case .callMethodType(let instruction):
                try instruction.encode(to: encoder)

            case .takeFromWorktopType(let instruction):
                try instruction.encode(to: encoder)
            case .takeFromWorktopByAmountType(let instruction):
                try instruction.encode(to: encoder)
            case .takeFromWorktopByIdsType(let instruction):
                try instruction.encode(to: encoder)

            case .returnToWorktopType(let instruction):
                try instruction.encode(to: encoder)

            case .assertWorktopContainsType(let instruction):
                try instruction.encode(to: encoder)
            case .assertWorktopContainsByAmountType(let instruction):
                try instruction.encode(to: encoder)
            case .assertWorktopContainsByIdsType(let instruction):
                try instruction.encode(to: encoder)

            case .popFromAuthZoneType(let instruction):
                try instruction.encode(to: encoder)
            case .pushToAuthZoneType(let instruction):
                try instruction.encode(to: encoder)

            case .clearAuthZoneType(let instruction):
                try instruction.encode(to: encoder)

            case .createProofFromAuthZoneType(let instruction):
                try instruction.encode(to: encoder)
            case .createProofFromAuthZoneByAmountType(let instruction):
                try instruction.encode(to: encoder)
            case .createProofFromAuthZoneByIdsType(let instruction):
                try instruction.encode(to: encoder)
            case .createProofFromBucketType(let instruction):
                try instruction.encode(to: encoder)

            case .cloneProofType(let instruction):
                try instruction.encode(to: encoder)
            case .dropProofType(let instruction):
                try instruction.encode(to: encoder)
            case .dropAllProofsType(let instruction):
                try instruction.encode(to: encoder)

            case .publishPackageType(let instruction):
                try instruction.encode(to: encoder)

            case .createResourceType(let instruction):
                try instruction.encode(to: encoder)
            case .burnBucketType(let instruction):
                try instruction.encode(to: encoder)
            case .mintFungibleType(let instruction):
                try instruction.encode(to: encoder)
        }
    }
    
    init(from decoder: Decoder) throws {
        // Checking for type discriminator
        let values: KeyedDecodingContainer = try decoder.container(keyedBy: CodingKeys.self)
        let kind: InstructionKind = try values.decode(InstructionKind.self, forKey: .type)
        
        switch kind {
            case .callFunction:
                self = Self(from: try CallFunction(from: decoder))
            case .callMethod:
                self = Self(from: try CallMethod(from: decoder))

            case .takeFromWorktop:
                self = Self(from: try TakeFromWorktop(from: decoder))
            case .takeFromWorktopByAmount:
                self = Self(from: try TakeFromWorktopByAmount(from: decoder))
            case .takeFromWorktopByIds:
                self = Self(from: try TakeFromWorktopByIds(from: decoder))

            case .returnToWorktop:
                self = Self(from: try ReturnToWorktop(from: decoder))

            case .assertWorktopContains:
                self = Self(from: try AssertWorktopContains(from: decoder))
            case .assertWorktopContainsByAmount:
                self = Self(from: try AssertWorktopContainsByAmount(from: decoder))
            case .assertWorktopContainsByIds:
                self = Self(from: try AssertWorktopContainsByIds(from: decoder))

            case .popFromAuthZone:
                self = Self(from: try PopFromAuthZone(from: decoder))
            case .pushToAuthZone:
                self = Self(from: try PushToAuthZone(from: decoder))

            case .clearAuthZone:
                self = Self(from: try ClearAuthZone(from: decoder))

            case .createProofFromAuthZone:
                self = Self(from: try CreateProofFromAuthZone(from: decoder))
            case .createProofFromAuthZoneByAmount:
                self = Self(from: try CreateProofFromAuthZoneByAmount(from: decoder))
            case .createProofFromAuthZoneByIds:
                self = Self(from: try CreateProofFromAuthZoneByIds(from: decoder))
            case .createProofFromBucket:
                self = Self(from: try CreateProofFromBucket(from: decoder))

            case .cloneProof:
                self = Self(from: try CloneProof(from: decoder))
            case .dropProof:
                self = Self(from: try DropProof(from: decoder))
            case .dropAllProofs:
                self = Self(from: try DropAllProofs(from: decoder))

            case .publishPackage:
                self = Self(from: try PublishPackage(from: decoder))

            case .createResource:
                self = Self(from: try CreateResource(from: decoder))
            case .burnBucket:
                self = Self(from: try BurnBucket(from: decoder))
            case .mintFungible:
                self = Self(from: try MintFungible(from: decoder))
        }
    }
}
