import Foundation

public struct CallMethod: InstructionProtocol {
    // Type name, used as a discriminator
    public static let kind: InstructionKind = .callMethod
    public func embed() -> Instruction {
        .callMethod(self)
    }
    
    // MARK: Stored properties
    public let componentAddress: ComponentAddress
    public let methodName: String
    public let arguments: [Value]
    
    // MARK: Init
    
    public init(componentAddress: ComponentAddress, methodName: String, arguments: [Value] = []) {
        self.componentAddress = componentAddress
        self.methodName = methodName
        self.arguments = arguments
    }
    
    public init(
        componentAddress: ComponentAddress,
        methodName: String,
        @ValuesBuilder buildValues: () throws -> [any ValueProtocol]
    ) rethrows {
        self.init(
            componentAddress: componentAddress,
            methodName: methodName,
            arguments: try buildValues().map { $0.embedValue() }
        )
    }
    
    public init(
        componentAddress: ComponentAddress,
        methodName: String,
        @SpecificValuesBuilder buildValues: () throws -> [Value]
    ) rethrows {
        self.init(
            componentAddress: componentAddress,
            methodName: methodName,
            arguments: try buildValues()
        )
    }
    
    public init(
        componentAddress: ComponentAddress,
        methodName: String,
        @SpecificValuesBuilder buildValue: () throws -> Value
    ) rethrows {
        self.init(
            componentAddress: componentAddress,
            methodName: methodName,
            arguments: [try buildValue()]
        )
    }
 
}

public extension CallMethod {
    
    // MARK: CodingKeys
    private enum CodingKeys: String, CodingKey {
        case type = "instruction"
        case componentAddress = "component_address"
        case methodName = "method_name"
        case arguments
    }
    
    // MARK: Codable
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(Self.kind, forKey: .type)
        
        try container.encode(componentAddress, forKey: .componentAddress)
        try container.encode(methodName.proxyEncodable, forKey: .methodName)
        try container.encode(arguments, forKey: .arguments)
    }
    
    init(from decoder: Decoder) throws {
        // Checking for type discriminator
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let kind: InstructionKind = try container.decode(InstructionKind.self, forKey: .type)
        if kind != Self.kind {
            throw InternalDecodingFailure.instructionTypeDiscriminatorMismatch(expected: Self.kind, butGot: kind)
        }
        
        let componentAddress = try container.decode(ComponentAddress.self, forKey: .componentAddress)
        let methodName = try container.decode(String.ProxyDecodable.self, forKey: .methodName).decoded
        let arguments = try container.decode([Value].self, forKey: .arguments)
        
        self.init(
            componentAddress: componentAddress,
            methodName: methodName,
            arguments: arguments
        )
    }
}
