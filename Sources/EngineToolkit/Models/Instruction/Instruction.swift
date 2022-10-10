import Foundation

/// Simple protocol for instructions.
public protocol InstructionProtocol: Sendable, Codable, Hashable {
    static var kind: InstructionKind { get }
    func embed() -> Instruction
}

public indirect enum Instruction: Sendable, Codable, Hashable {
    // ==============
    // Enum Variants
    // ==============
    
    case callFunction(CallFunction)
    case callMethod(CallMethod)
    
    case takeFromWorktop(TakeFromWorktop)
    case takeFromWorktopByAmount(TakeFromWorktopByAmount)
    case takeFromWorktopByIds(TakeFromWorktopByIds)
    
    case returnToWorktop(ReturnToWorktop)
    
    case assertWorktopContains(AssertWorktopContains)
    case assertWorktopContainsByAmount(AssertWorktopContainsByAmount)
    case assertWorktopContainsByIds(AssertWorktopContainsByIds)
    
    case popFromAuthZone(PopFromAuthZone)
    case pushToAuthZone(PushToAuthZone)
    case clearAuthZone(ClearAuthZone)
    
    case createProofFromAuthZone(CreateProofFromAuthZone)
    case createProofFromAuthZoneByAmount(CreateProofFromAuthZoneByAmount)
    case createProofFromAuthZoneByIds(CreateProofFromAuthZoneByIds)
    case createProofFromBucket(CreateProofFromBucket)
    
    case cloneProof(CloneProof)
    
    case dropProof(DropProof)
    case dropAllProofs(DropAllProofs)
    
    case publishPackage(PublishPackage)
    
    case createResource(CreateResource)
    case burnBucket(BurnBucket)
    case mintFungible(MintFungible)
}

public extension Instruction {
    // =============
    // Constructors
    // =============
    
    init(from instruction: CallFunction) {
        self = .callFunction(instruction)
    }
    init(from instruction: CallMethod) {
        self = .callMethod(instruction)
    }
    
    init(from instruction: TakeFromWorktop) {
        self = .takeFromWorktop(instruction)
    }
    init(from instruction: TakeFromWorktopByAmount) {
        self = .takeFromWorktopByAmount(instruction)
    }
    init(from instruction: TakeFromWorktopByIds) {
        self = .takeFromWorktopByIds(instruction)
    }
    
    init(from instruction: ReturnToWorktop) {
        self = .returnToWorktop(instruction)
    }
    
    init(from instruction: AssertWorktopContains) {
        self = .assertWorktopContains(instruction)
    }
    init(from instruction: AssertWorktopContainsByAmount) {
        self = .assertWorktopContainsByAmount(instruction)
    }
    init(from instruction: AssertWorktopContainsByIds) {
        self = .assertWorktopContainsByIds(instruction)
    }
    
    init(from instruction: PopFromAuthZone) {
        self = .popFromAuthZone(instruction)
    }
    init(from instruction: PushToAuthZone) {
        self = .pushToAuthZone(instruction)
    }
    
    init(from instruction: ClearAuthZone) {
        self = .clearAuthZone(instruction)
    }
    
    init(from instruction: CreateProofFromAuthZone) {
        self = .createProofFromAuthZone(instruction)
    }
    init(from instruction: CreateProofFromAuthZoneByAmount) {
        self = .createProofFromAuthZoneByAmount(instruction)
    }
    init(from instruction: CreateProofFromAuthZoneByIds) {
        self = .createProofFromAuthZoneByIds(instruction)
    }
    init(from instruction: CreateProofFromBucket) {
        self = .createProofFromBucket(instruction)
    }
    
    init(from instruction: CloneProof) {
        self = .cloneProof(instruction)
    }
    init(from instruction: DropProof) {
        self = .dropProof(instruction)
    }
    init(from instruction: DropAllProofs) {
        self = .dropAllProofs(instruction)
    }
    
    init(from instruction: PublishPackage) {
        self = .publishPackage(instruction)
    }
    
    init(from instruction: CreateResource) {
        self = .createResource(instruction)
    }
    init(from instruction: BurnBucket) {
        self = .burnBucket(instruction)
    }
    init(from instruction: MintFungible) {
        self = .mintFungible(instruction)
    }
}

public extension Instruction {
    
    
    // =================
    // Instruction Kind
    // =================
    
    func kind() -> InstructionKind {
        switch self {
        case .callFunction:
            return .callFunction
        case .callMethod:
            return .callMethod
            
        case .takeFromWorktop:
            return .takeFromWorktop
        case .takeFromWorktopByAmount:
            return .takeFromWorktopByAmount
        case .takeFromWorktopByIds:
            return .takeFromWorktopByIds
            
        case .returnToWorktop:
            return .returnToWorktop
            
        case .assertWorktopContains:
            return .assertWorktopContains
        case .assertWorktopContainsByAmount:
            return .assertWorktopContainsByAmount
        case .assertWorktopContainsByIds:
            return .assertWorktopContainsByIds
            
        case .popFromAuthZone:
            return .popFromAuthZone
        case .pushToAuthZone:
            return .pushToAuthZone
            
        case .clearAuthZone:
            return .clearAuthZone
            
        case .createProofFromAuthZone:
            return .createProofFromAuthZone
        case .createProofFromAuthZoneByAmount:
            return .createProofFromAuthZoneByAmount
        case .createProofFromAuthZoneByIds:
            return .createProofFromAuthZoneByIds
        case .createProofFromBucket:
            return .createProofFromBucket
            
        case .cloneProof:
            return .cloneProof
        case .dropProof:
            return .dropProof
        case .dropAllProofs:
            return .dropAllProofs
            
        case .publishPackage:
            return .publishPackage
            
        case .createResource:
            return .createResource
        case .burnBucket:
            return .burnBucket
        case .mintFungible:
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
            case .callFunction(let instruction):
                try instruction.encode(to: encoder)
            case .callMethod(let instruction):
                try instruction.encode(to: encoder)

            case .takeFromWorktop(let instruction):
                try instruction.encode(to: encoder)
            case .takeFromWorktopByAmount(let instruction):
                try instruction.encode(to: encoder)
            case .takeFromWorktopByIds(let instruction):
                try instruction.encode(to: encoder)

            case .returnToWorktop(let instruction):
                try instruction.encode(to: encoder)

            case .assertWorktopContains(let instruction):
                try instruction.encode(to: encoder)
            case .assertWorktopContainsByAmount(let instruction):
                try instruction.encode(to: encoder)
            case .assertWorktopContainsByIds(let instruction):
                try instruction.encode(to: encoder)

            case .popFromAuthZone(let instruction):
                try instruction.encode(to: encoder)
            case .pushToAuthZone(let instruction):
                try instruction.encode(to: encoder)

            case .clearAuthZone(let instruction):
                try instruction.encode(to: encoder)

            case .createProofFromAuthZone(let instruction):
                try instruction.encode(to: encoder)
            case .createProofFromAuthZoneByAmount(let instruction):
                try instruction.encode(to: encoder)
            case .createProofFromAuthZoneByIds(let instruction):
                try instruction.encode(to: encoder)
            case .createProofFromBucket(let instruction):
                try instruction.encode(to: encoder)

            case .cloneProof(let instruction):
                try instruction.encode(to: encoder)
            case .dropProof(let instruction):
                try instruction.encode(to: encoder)
            case .dropAllProofs(let instruction):
                try instruction.encode(to: encoder)

            case .publishPackage(let instruction):
                try instruction.encode(to: encoder)

            case .createResource(let instruction):
                try instruction.encode(to: encoder)
            case .burnBucket(let instruction):
                try instruction.encode(to: encoder)
            case .mintFungible(let instruction):
                try instruction.encode(to: encoder)
        }
    }
    
    init(from decoder: Decoder) throws {
        // Checking for type discriminator
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let kind: InstructionKind = try container.decode(InstructionKind.self, forKey: .type)
        
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
