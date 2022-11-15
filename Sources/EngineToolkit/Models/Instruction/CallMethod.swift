import Foundation

public struct CallMethod: InstructionProtocol {
    // Type name, used as a discriminator
    public static let kind: InstructionKind = .callMethod
    public func embed() -> Instruction {
        .callMethod(self)
    }
    
    // MARK: Stored properties
    public let receiver: CallMethodReceiver
    public let methodName: String
    public let arguments: [Value]
    
    // MARK: Init
    
    public init<Receiver: CallMethodReceiverCompatible>(receiver: Receiver, methodName: String, arguments: [Value] = []) {
        self.receiver = receiver.toCallMethodReceiver()
        self.methodName = methodName
        self.arguments = arguments
    }
    
    public init<Receiver: CallMethodReceiverCompatible>(
        receiver: Receiver,
        methodName: String,
        @ValuesBuilder buildValues: () throws -> [any ValueProtocol]
    ) rethrows {
        self.init(
            receiver: receiver.toCallMethodReceiver(),
            methodName: methodName,
            arguments: try buildValues().map { $0.embedValue() }
        )
    }
    
    public init<Receiver: CallMethodReceiverCompatible>(
        receiver: Receiver,
        methodName: String,
        @SpecificValuesBuilder buildValues: () throws -> [Value]
    ) rethrows {
        self.init(
            receiver: receiver.toCallMethodReceiver(),
            methodName: methodName,
            arguments: try buildValues()
        )
    }
    
    public init<Receiver: CallMethodReceiverCompatible>(
        receiver: Receiver,
        methodName: String,
        @SpecificValuesBuilder buildValue: () throws -> Value
    ) rethrows {
        self.init(
            receiver: receiver.toCallMethodReceiver(),
            methodName: methodName,
            arguments: [try buildValue()]
        )
    }
 
}

public extension CallMethod {
    
    // MARK: CodingKeys
    private enum CodingKeys: String, CodingKey {
        case type = "instruction"
        case receiver = "component_address"
        case methodName = "method_name"
        case arguments
    }
    
    // MARK: Codable
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(Self.kind, forKey: .type)
        
        try container.encode(receiver, forKey: .receiver)
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
        
        let receiver = try container.decode(CallMethodReceiver.self, forKey: .receiver)
        let methodName = try container.decode(String.ProxyDecodable.self, forKey: .methodName).decoded
        var arguments: [Value] = []
        do {
            arguments = try container.decode([Value].self, forKey: .arguments)
        } catch {}
        
        self.init(
            receiver: receiver,
            methodName: methodName,
            arguments: arguments
        )
    }
}

public protocol CallMethodReceiverCompatible {
    func toCallMethodReceiver() -> CallMethodReceiver
}

public enum CallMethodReceiver: Sendable, Codable, Hashable, Equatable, CallMethodReceiverCompatible {
    case component(Component)
    case componentAddress(ComponentAddress)
}

public extension CallMethodReceiver {
    init(component: Component) {
        self = .component(component)
    }
    
    init(componentAddress: ComponentAddress) {
        self = .componentAddress(componentAddress)
    }
}

public extension CallMethodReceiver {
    
    // MARK: Codable
    func encode(to encoder: Encoder) throws {
        switch self {
        case .component(let receiver):
            try receiver.encode(to: encoder)
        case .componentAddress(let receiver):
            try receiver.encode(to: encoder)
        }
    }
    
    init(from decoder: Decoder) throws {
        do {
            self = try .componentAddress(.init(from: decoder))
        } catch {
            do {
                self = try .component(.init(from: decoder))
            } catch {
                throw DecodeError(value: "CallMethodReceiver must either be a `Component` or a `ComponentAddress`.")
            }
        }
    }
}

public extension CallMethodReceiver {
    func toCallMethodReceiver() -> CallMethodReceiver {
        return self
    }
}
