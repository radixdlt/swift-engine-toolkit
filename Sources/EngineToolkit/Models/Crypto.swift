import Foundation

public struct EcdsaSecp256k1SignatureString: Sendable, Codable, Hashable {
    // MARK: Stored properties
    public let bytes: [UInt8]
    
    // MARK: Init
    
    public init(bytes: [UInt8]) {
        self.bytes = bytes
    }
    
    public init(hex: String) throws {
        try self.init(bytes: .init(hex: hex))
    }
}

public extension EcdsaSecp256k1SignatureString {
    
    // MARK: CodingKeys
    private enum CodingKeys: String, CodingKey {
        case value, type
    }
    
    // MARK: Codable
    func encode(to encoder: Encoder) throws {
        var container: SingleValueEncodingContainer = encoder.singleValueContainer()
        try container.encode(bytes.toHexString())
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        try self.init(hex: container.decode(String.self))
    }
}

public struct EcdsaSecp256k1PublicKeyString: Sendable, Codable, Hashable {
    // MARK: Stored properties
    public let bytes: [UInt8]
    
    // MARK: Init
    
    public init(bytes: [UInt8]) {
        self.bytes = bytes
    }
    
    public init(hex: String) throws {
        // TODO: Validation of length of array
        try self.init(bytes: [UInt8](hex: hex))
    }
}

public extension EcdsaSecp256k1PublicKeyString {
    
    // MARK: CodingKeys
    private enum CodingKeys: String, CodingKey {
        case value, type
    }
    
    // MARK: Codable
    func encode(to encoder: Encoder) throws {
        var container: SingleValueEncodingContainer = encoder.singleValueContainer()
        try container.encode(bytes.toHexString())
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        try self.init(hex: container.decode(String.self))
    }
}

public struct EddsaEd25519SignatureString: Sendable, Codable, Hashable {
    // MARK: Stored properties
    public let bytes: [UInt8]
    
    // MARK: Init
    
    public init(bytes: [UInt8]) {
        self.bytes = bytes
    }
    
    public init(hex: String) throws {
        try self.init(bytes: [UInt8](hex: hex))
    }
}

public extension EddsaEd25519SignatureString {
    
    // MARK: CodingKeys
    private enum CodingKeys: String, CodingKey {
        case value, type
    }
    
    // MARK: Codable
    func encode(to encoder: Encoder) throws {
        var container: SingleValueEncodingContainer = encoder.singleValueContainer()
        try container.encode(bytes.toHexString())
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        try self.init(hex: container.decode(String.self))
    }
}

public struct EddsaEd25519PublicKeyString: Sendable, Codable, Hashable {
    // MARK: Stored properties
    public let bytes: [UInt8]
    
    // MARK: Init
    
    public init(bytes: [UInt8]) {
        self.bytes = bytes
    }
    
    public init(hex: String) throws {
        try self.init(bytes: [UInt8](hex: hex))
    }
  
}

public extension EddsaEd25519PublicKeyString {
    
    // MARK: CodingKeys
    private enum CodingKeys: String, CodingKey {
        case value, type
    }
    
    // MARK: Codable
    func encode(to encoder: Encoder) throws {
        var container: SingleValueEncodingContainer = encoder.singleValueContainer()
        try container.encode(bytes.toHexString())
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        try self.init(hex: container.decode(String.self))
    }
}

public enum PublicKey: Sendable, Codable, Hashable {
    // ==============
    // Enum Variants
    // ==============
    
    case ecdsaSecp256k1(EcdsaSecp256k1PublicKeyString)
    case eddsaEd25519(EddsaEd25519PublicKeyString)
}

public extension PublicKey {
    // MARK: CodingKeys
    private enum CodingKeys: String, CodingKey {
        case type
        case publicKey = "public_key"
    }
    
    // MARK: Codable
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        switch self {
            case .ecdsaSecp256k1(let publicKey):
                try container.encode("EcdsaSecp256k1", forKey: .type)
                try container.encode(publicKey, forKey: .publicKey)
            case .eddsaEd25519(let publicKey):
                try container.encode("EddsaEd25519", forKey: .type)
                try container.encode(publicKey, forKey: .publicKey)
         }
    }
    
    init(from decoder: Decoder) throws {
        // Checking for type discriminator
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type: String = try container.decode(String.self, forKey: .type)
        
        switch type {
            case "EcdsaSecp256k1":
                self = .ecdsaSecp256k1(try container.decode(EcdsaSecp256k1PublicKeyString.self, forKey: .publicKey))
            case "EddsaEd25519":
                self = .eddsaEd25519(try container.decode(EddsaEd25519PublicKeyString.self, forKey: .publicKey))
            default:
                // TODO: Temporary error. Need a better one
                throw InternalDecodingFailure.parsingError
        }
    }
}

public enum Signature: Sendable, Codable, Hashable {
    // ==============
    // Enum Variants
    // ==============
    
    case ecdsaSecp256k1(EcdsaSecp256k1SignatureString)
    case eddsaEd25519(EddsaEd25519SignatureString)
}

internal enum CurveDiscriminator: String, Codable {
    case ecdsaSecp256k1 = "EcdsaSecp256k1"
    case eddsaEd25519 = "EddsaEd25519"
}

private extension Signature {
   
    var discriminator: CurveDiscriminator {
        switch self {
        case .ecdsaSecp256k1: return .ecdsaSecp256k1
        case .eddsaEd25519: return .eddsaEd25519
        }
    }
}

public extension Signature {
    
    // MARK: CodingKeys
    private enum CodingKeys: String, CodingKey {
        case type
        case signature
    }
    
    
    // MARK: Codable
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(discriminator, forKey: .type)
        
        switch self {
            case .ecdsaSecp256k1(let signature):
                try container.encode(signature, forKey: .signature)
            case .eddsaEd25519(let signature):
                try container.encode(signature, forKey: .signature)
         }
    }
    
    init(from decoder: Decoder) throws {
        // Checking for type discriminator
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let discriminator = try container.decode(CurveDiscriminator.self, forKey: .type)
        
        switch discriminator {
        case .ecdsaSecp256k1:
            self = .ecdsaSecp256k1(try container.decode(EcdsaSecp256k1SignatureString.self, forKey: .signature))
        case .eddsaEd25519:
            self = .eddsaEd25519(try container.decode(EddsaEd25519SignatureString.self, forKey: .signature))
        }
    }
}

public enum SignatureWithPublicKey: Sendable, Codable, Hashable {
    // ==============
    // Enum Variants
    // ==============
    
    case ecdsaSecp256k1(EcdsaSecp256k1SignatureString)
    case eddsaEd25519(EddsaEd25519PublicKeyString, EddsaEd25519SignatureString)
}
public extension SignatureWithPublicKey {
    var signature: Signature {
        switch self {
        case let .eddsaEd25519(_, signature):
            return .eddsaEd25519(signature)
        case let .ecdsaSecp256k1(signature):
            return .ecdsaSecp256k1(signature)
        }
    }
}

private extension SignatureWithPublicKey {
   
    var discriminator: CurveDiscriminator {
        switch self {
        case .ecdsaSecp256k1: return .ecdsaSecp256k1
        case .eddsaEd25519: return .eddsaEd25519
        }
    }
}


public extension SignatureWithPublicKey {
    
    // MARK: CodingKeys
    private enum CodingKeys: String, CodingKey {
        case type
        case publicKey = "public_key"
        case signature
    }
    
    // MARK: Codable
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(discriminator, forKey: .type)
        
        switch self {
            case .ecdsaSecp256k1(let signature):
                try container.encode(signature, forKey: .signature)
            case .eddsaEd25519(let publicKey, let signature):
                try container.encode(publicKey, forKey: .publicKey)
                try container.encode(signature, forKey: .signature)
         }
    }
    
    init(from decoder: Decoder) throws {
        // Checking for type discriminator
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let discriminator = try container.decode(CurveDiscriminator.self, forKey: .type)
        
        switch discriminator {
        case .ecdsaSecp256k1:
            self = .ecdsaSecp256k1(try container.decode(EcdsaSecp256k1SignatureString.self, forKey: .signature))
        case .eddsaEd25519:
            self = .eddsaEd25519(
                try container.decode(EddsaEd25519PublicKeyString.self, forKey: .publicKey),
                try container.decode(EddsaEd25519SignatureString.self, forKey: .signature)
            )
        }
    }
}
