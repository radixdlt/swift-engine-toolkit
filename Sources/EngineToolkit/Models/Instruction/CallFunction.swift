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
    public let arguments: [Value]
    
    // =============
    // Constructors
    // =============
    
    public init(
        packageAddress: PackageAddress,
        blueprintName: String_,
        functionName: String_,
        arguments: [Value] = []
    ) {
        self.packageAddress = packageAddress
        self.blueprintName = blueprintName
        self.functionName = functionName
        self.arguments = arguments
    }
}

public extension CallFunction {
    
    // =======================
    // Coding Keys Definition
    // =======================
    private enum CodingKeys: String, CodingKey {
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
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(Self.kind, forKey: .type)
        
        try container.encode(packageAddress, forKey: .packageAddress)
        try container.encode(blueprintName, forKey: .blueprintName)
        try container.encode(functionName, forKey: .functionName)
        try container.encode(arguments, forKey: .arguments)
    }
    
    init(from decoder: Decoder) throws {
        // Checking for type discriminator
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let kind = try container.decode(InstructionKind.self, forKey: .type)
        if kind != Self.kind {
            throw InternalDecodingFailure.instructionTypeDiscriminatorMismatch(expected: Self.kind, butGot: kind)
        }
        
        let packageAddress = try container.decode(PackageAddress.self, forKey: .packageAddress)
        let blueprintName = try container.decode(String_.self, forKey: .blueprintName)
        let functionName = try container.decode(String_.self, forKey: .functionName)
        let arguments = try container.decode([Value].self, forKey: .arguments)
        
        self.init(
            packageAddress: packageAddress,
            blueprintName: blueprintName,
            functionName: functionName,
            arguments: arguments
        )
    }
}
