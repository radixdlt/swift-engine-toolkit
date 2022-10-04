import Foundation

public struct EcdsaSecp256k1SignatureString: Sendable, Codable, Hashable {
    // ===============
    // Struct members
    // ===============
    
    public let value: Array<UInt8>
    
    // =============
    // Constructors
    // =============
    
    init(from value: Array<UInt8>) {
        self.value = value
    }
    
    init(from value: String) throws {
        // TODO: Validation of length of array
        self.value = Array<UInt8>(hex: value)
    }
}

public extension EcdsaSecp256k1SignatureString {
    
    // =======================
    // Coding Keys Definition
    // =======================
    private enum CodingKeys : String, CodingKey {
        case value, type
    }
    
    // ======================
    // Encoding and Decoding
    // ======================
    func encode(to encoder: Encoder) throws {
        var container: SingleValueEncodingContainer = encoder.singleValueContainer()
        try container.encode(value.toHexString())
    }
    
    init(from decoder: Decoder) throws {
        let values: SingleValueDecodingContainer = try decoder.singleValueContainer()
        self = try Self(from: try values.decode(String.self))
    }
}

public struct EcdsaSecp256k1PublicKeyString: Sendable, Codable, Hashable {
    // ===============
    // Struct members
    // ===============
    
    public let value: Array<UInt8>
    
    // =============
    // Constructors
    // =============
    
    init(from value: Array<UInt8>) {
        self.value = value
    }
    
    init(from value: String) throws {
        // TODO: Validation of length of array
        self.value = Array<UInt8>(hex: value)
    }
}

public extension EcdsaSecp256k1PublicKeyString {
    
    // =======================
    // Coding Keys Definition
    // =======================
    private enum CodingKeys : String, CodingKey {
        case value, type
    }
    
    // ======================
    // Encoding and Decoding
    // ======================
    func encode(to encoder: Encoder) throws {
        var container: SingleValueEncodingContainer = encoder.singleValueContainer()
        try container.encode(value.toHexString())
    }
    
    init(from decoder: Decoder) throws {
        let values: SingleValueDecodingContainer = try decoder.singleValueContainer()
        self = try Self(from: try values.decode(String.self))
    }
}

public struct EddsaEd25519SignatureString: Sendable, Codable, Hashable {
    // ===============
    // Struct members
    // ===============
    
    public let value: Array<UInt8>
    
    // =============
    // Constructors
    // =============
    
    init(from value: Array<UInt8>) {
        self.value = value
    }
    
    init(from value: String) throws {
        // TODO: Validation of length of array
        self.value = Array<UInt8>(hex: value)
    }
}

public extension EddsaEd25519SignatureString {
    
    // =======================
    // Coding Keys Definition
    // =======================
    private enum CodingKeys : String, CodingKey {
        case value, type
    }
    
    // ======================
    // Encoding and Decoding
    // ======================
    func encode(to encoder: Encoder) throws {
        var container: SingleValueEncodingContainer = encoder.singleValueContainer()
        try container.encode(value.toHexString())
    }
    
    init(from decoder: Decoder) throws {
        let values: SingleValueDecodingContainer = try decoder.singleValueContainer()
        self = try Self(from: try values.decode(String.self))
    }
}

public struct EddsaEd25519PublicKeyString: Sendable, Codable, Hashable {
    // ===============
    // Struct members
    // ===============
    
    public let value: Array<UInt8>
    
    // =============
    // Constructors
    // =============
    
    init(from value: Array<UInt8>) {
        self.value = value
    }
    
    init(from value: String) throws {
        // TODO: Validation of length of array
        self.value = Array<UInt8>(hex: value)
    }
  
}

public extension EddsaEd25519PublicKeyString {
    
    // =======================
    // Coding Keys Definition
    // =======================
    private enum CodingKeys : String, CodingKey {
        case value, type
    }
    
    // ======================
    // Encoding and Decoding
    // ======================
    func encode(to encoder: Encoder) throws {
        var container: SingleValueEncodingContainer = encoder.singleValueContainer()
        try container.encode(value.toHexString())
    }
    
    init(from decoder: Decoder) throws {
        let values: SingleValueDecodingContainer = try decoder.singleValueContainer()
        self = try Self(from: try values.decode(String.self))
    }
}

public enum PublicKey: Sendable, Codable, Hashable {
    // ==============
    // Enum Variants
    // ==============
    
    case EcdsaSecp256k1(EcdsaSecp256k1PublicKeyString)
    case EddsaEd25519(EddsaEd25519PublicKeyString)
}

public extension PublicKey {
    // =======================
    // Coding Keys Definition
    // =======================
    private enum CodingKeys : String, CodingKey {
        case type
        case publicKey = "public_key"
    }
    
    // ======================
    // Encoding and Decoding
    // ======================
    func encode(to encoder: Encoder) throws {
        var container: KeyedEncodingContainer = encoder.container(keyedBy: CodingKeys.self)
        
        switch self {
            case .EcdsaSecp256k1(let publicKey):
                try container.encode("EcdsaSecp256k1", forKey: .type)
                try container.encode(publicKey, forKey: .publicKey)
            case .EddsaEd25519(let publicKey):
                try container.encode("EddsaEd25519", forKey: .type)
                try container.encode(publicKey, forKey: .publicKey)
         }
    }
    
    init(from decoder: Decoder) throws {
        // Checking for type discriminator
        let values: KeyedDecodingContainer = try decoder.container(keyedBy: CodingKeys.self)
        let type: String = try values.decode(String.self, forKey: .type)
        
        switch type {
            case "EcdsaSecp256k1":
                self = Self.EcdsaSecp256k1(try values.decode(EcdsaSecp256k1PublicKeyString.self, forKey: .publicKey))
            case "EddsaEd25519":
                self = Self.EddsaEd25519(try values.decode(EddsaEd25519PublicKeyString.self, forKey: .publicKey))
            default:
                // TODO: Temporary error. Need a better one
                throw DecodeError.ParsingError
        }
    }
}

public enum Signature: Sendable, Codable, Hashable {
    // ==============
    // Enum Variants
    // ==============
    
    case EcdsaSecp256k1(EcdsaSecp256k1SignatureString)
    case EddsaEd25519(EddsaEd25519SignatureString)
}

public extension Signature {
    
    // =======================
    // Coding Keys Definition
    // =======================
    private enum CodingKeys : String, CodingKey {
        case type
        case signature
    }
    
    // ======================
    // Encoding and Decoding
    // ======================
    func encode(to encoder: Encoder) throws {
        var container: KeyedEncodingContainer = encoder.container(keyedBy: CodingKeys.self)
        
        switch self {
            case .EcdsaSecp256k1(let signature):
                try container.encode("EcdsaSecp256k1", forKey: .type)
                try container.encode(signature, forKey: .signature)
            case .EddsaEd25519(let signature):
                try container.encode("EddsaEd25519", forKey: .type)
                try container.encode(signature, forKey: .signature)
         }
    }
    
    init(from decoder: Decoder) throws {
        // Checking for type discriminator
        let values: KeyedDecodingContainer = try decoder.container(keyedBy: CodingKeys.self)
        let type: String = try values.decode(String.self, forKey: .type)
        
        switch type {
            case "EcdsaSecp256k1":
                self = Self.EcdsaSecp256k1(try values.decode(EcdsaSecp256k1SignatureString.self, forKey: .signature))
            case "EddsaEd25519":
                self = Self.EddsaEd25519(try values.decode(EddsaEd25519SignatureString.self, forKey: .signature))
            default:
                // TODO: Temporary error. Need a better one
                throw DecodeError.ParsingError
        }
    }
}

public enum SignatureWithPublicKey: Sendable, Codable, Hashable {
    // ==============
    // Enum Variants
    // ==============
    
    case EcdsaSecp256k1(EcdsaSecp256k1SignatureString)
    case EddsaEd25519(EddsaEd25519PublicKeyString, EddsaEd25519SignatureString)
}

public extension SignatureWithPublicKey {
    
    // =======================
    // Coding Keys Definition
    // =======================
    private enum CodingKeys : String, CodingKey {
        case type
        case publicKey = "public_key"
        case signature
    }
    
    // ======================
    // Encoding and Decoding
    // ======================
    func encode(to encoder: Encoder) throws {
        var container: KeyedEncodingContainer = encoder.container(keyedBy: CodingKeys.self)
        
        switch self {
            case .EcdsaSecp256k1(let signature):
                try container.encode("EcdsaSecp256k1", forKey: .type)
                try container.encode(signature, forKey: .signature)
            case .EddsaEd25519(let publicKey, let signature):
                try container.encode("EddsaEd25519", forKey: .type)
                try container.encode(publicKey, forKey: .publicKey)
                try container.encode(signature, forKey: .signature)
         }
    }
    
    init(from decoder: Decoder) throws {
        // Checking for type discriminator
        let values: KeyedDecodingContainer = try decoder.container(keyedBy: CodingKeys.self)
        let type: String = try values.decode(String.self, forKey: .type)
        
        switch type {
            case "EcdsaSecp256k1":
                self = Self.EcdsaSecp256k1(try values.decode(EcdsaSecp256k1SignatureString.self, forKey: .signature))
            case "EddsaEd25519":
                self = Self.EddsaEd25519(
                    try values.decode(EddsaEd25519PublicKeyString.self, forKey: .publicKey),
                    try values.decode(EddsaEd25519SignatureString.self, forKey: .signature)
                )
            default:
                // TODO: Temporary error. Need a better one
                throw DecodeError.ParsingError
        }
    }
}
