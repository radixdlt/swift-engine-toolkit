import Foundation

public struct CallMethod: Sendable, Codable, Hashable {
    // Type name, used as a discriminator
    public static let kind: InstructionKind = InstructionKind.CallMethod
    
    // ===============
    // Struct members
    // ===============
    
    public let componentAddress: ComponentAddress
    public let methodName: String_
    public let arguments: Array<Value>
    
    // =============
    // Constructors
    // =============
    
    init(from componentAddress: ComponentAddress, methodName: String_, arguments: Array<Value>?) {
        self.componentAddress = componentAddress
        self.methodName = methodName
        self.arguments = arguments ?? Array<Value>([])
    }
}

public extension CallMethod {
    
    // =======================
    // Coding Keys Definition
    // =======================
    private enum CodingKeys : String, CodingKey {
        case type = "instruction"
        case componentAddress = "component_address"
        case methodName = "method_name"
        case arguments
    }
    
    // ======================
    // Encoding and Decoding
    // ======================
    func encode(to encoder: Encoder) throws {
        var container: KeyedEncodingContainer = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(Self.kind, forKey: .type)
        
        try container.encode(componentAddress, forKey: .componentAddress)
        try container.encode(methodName, forKey: .methodName)
        try container.encode(arguments, forKey: .arguments)
    }
    
    init(from decoder: Decoder) throws {
        // Checking for type discriminator
        let values: KeyedDecodingContainer = try decoder.container(keyedBy: CodingKeys.self)
        let kind: InstructionKind = try values.decode(InstructionKind.self, forKey: .type)
        if kind != Self.kind {
            throw DecodeError.InstructionTypeDiscriminatorMismatch(Self.kind, kind)
        }
        
        let componentAddress: ComponentAddress = try values.decode(ComponentAddress.self, forKey: .componentAddress)
        let methodName: String_ = try values.decode(String_.self, forKey: .methodName)
        let arguments: Array<Value> = try values.decode(Array<Value>.self, forKey: .arguments)
        
        self = Self(from: componentAddress, methodName: methodName, arguments: arguments)
    }
}
