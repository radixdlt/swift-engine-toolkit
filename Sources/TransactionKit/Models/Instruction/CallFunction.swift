import Foundation

public struct CallFunction: Sendable, Codable, Hashable {
    // Type name, used as a discriminator
    public static let kind: InstructionKind = .callFunction
    
    // ===============
    // Struct members
    // ===============
    
    public let packageAddress: PackageAddress
    public let blueprintName: String_
    public let functionName: String_
    public let arguments: Array<Value>
    
    // =============
    // Constructors
    // =============
    
    public init(from packageAddress: PackageAddress, blueprintName: String_, functionName: String_, arguments: Array<Value>?) {
        self.packageAddress = packageAddress
        self.blueprintName = blueprintName
        self.functionName = functionName
        self.arguments = arguments ?? Array<Value>([])
    }
}

public extension CallFunction {
    
    // =======================
    // Coding Keys Definition
    // =======================
    private enum CodingKeys : String, CodingKey {
        case type = "instruction"
        case packageAddress = "package_address"
        case blueprintName = "blueprint_name"
        case functionName = "function_name"
        case arguments
    }
    
    // ======================
    // Encoding and Decoding
    // ======================
    func encode(to encoder: Encoder) throws {
        var container: KeyedEncodingContainer = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(Self.kind, forKey: .type)
        
        try container.encode(packageAddress, forKey: .packageAddress)
        try container.encode(blueprintName, forKey: .blueprintName)
        try container.encode(functionName, forKey: .functionName)
        try container.encode(arguments, forKey: .arguments)
    }
    
    init(from decoder: Decoder) throws {
        // Checking for type discriminator
        let values: KeyedDecodingContainer = try decoder.container(keyedBy: CodingKeys.self)
        let kind: InstructionKind = try values.decode(InstructionKind.self, forKey: .type)
        if kind != Self.kind {
            throw DecodeError.instructionTypeDiscriminatorMismatch(Self.kind, kind)
        }
        
        let packageAddress: PackageAddress = try values.decode(PackageAddress.self, forKey: .packageAddress)
        let blueprintName: String_ = try values.decode(String_.self, forKey: .blueprintName)
        let functionName: String_ = try values.decode(String_.self, forKey: .functionName)
        let arguments: Array<Value> = try values.decode(Array<Value>.self, forKey: .arguments)
        
        self = Self(from: packageAddress, blueprintName: blueprintName, functionName: functionName, arguments: arguments)
    }
}
