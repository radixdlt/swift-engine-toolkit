import Foundation

public protocol ValueProtocol {
    static var kind: ValueKind { get }
    func embedValue() -> Value
}
public extension ValueProtocol {
    var kind: ValueKind { Self.kind }
}

public typealias Value = Value_
// We name this `Value_` to be able to disambiguate between associatedtype `Value` and this type in `ExpressibleByDictionaryLiteral` e.g. in `Map`.
public indirect enum Value_: Sendable, Codable, Hashable {
    // ==============
    // Enum Variants
    // ==============
    
    case unit(Unit)
    case boolean(Bool)
    
    case i8(Int8)
    case i16(Int16)
    case i32(Int32)
    case i64(Int64)
    case i128(I128)
    
    case u8(UInt8)
    case u16(UInt16)
    case u32(UInt32)
    case u64(UInt64)
    case u128(U128)
    
    case string(String)
    
    case `enum`(Enum)
    
    case array(Array_)
    case tuple(Tuple)
    
    case decimal(Decimal_)
    case preciseDecimal(PreciseDecimal)
    
    case component(Component)
    case packageAddress(PackageAddress)
    case componentAddress(ComponentAddress)
    case resourceAddress(ResourceAddress)
    case systemAddress(SystemAddress)
    
    case hash(Hash)
    
    case bucket(Bucket)
    case proof(Proof)
    case vault(Vault)
    
    case nonFungibleId(NonFungibleId)
    case nonFungibleAddress(NonFungibleAddress)
    
    case keyValueStore(KeyValueStore)
    
    case ecdsaSecp256k1PublicKey(EcdsaSecp256k1PublicKey)
    case ecdsaSecp256k1Signature(EcdsaSecp256k1Signature)
    case eddsaEd25519PublicKey(EddsaEd25519PublicKey)
    case eddsaEd25519Signature(EddsaEd25519Signature)
    
    case blob(Blob)
    case expression(Expression)
}

public extension Value {
    
    // ===========
    // Value Kind
    // ===========
    
    var kind: ValueKind {
        switch self {
        case .unit:
            return .unit
            
        case .boolean:
            return .bool
            
        case .i8:
            return .i8
            
        case .i16:
            return .i16
            
        case .i32:
            return .i32
            
        case .i64:
            return .i64
            
        case .i128:
            return .i128
            
        case .u8:
            return .u8
            
        case .u16:
            return .u16
            
        case .u32:
            return .u32
            
        case .u64:
            return .u64
            
        case .u128:
            return .u128
            
        case .string:
            return .string
            
        case .enum:
            return .enum
            
        case .array:
            return .array
            
        case .tuple:
            return .tuple
            
        case .decimal:
            return .decimal
            
        case .preciseDecimal:
            return .preciseDecimal
            
        case .component:
            return .component
            
        case .packageAddress:
            return .packageAddress
            
        case .componentAddress:
            return .componentAddress
            
        case .resourceAddress:
            return .resourceAddress
        
        case .systemAddress:
            return .systemAddress
            
        case .hash:
            return .hash
            
        case .bucket:
            return .bucket
        case .proof:
            return .proof
        case .vault:
            return .vault
            
        case .nonFungibleId:
            return .nonFungibleId
            
        case .nonFungibleAddress:
            return .nonFungibleAddress
            
        case .keyValueStore:
            return .keyValueStore
            
        case .ecdsaSecp256k1PublicKey:
            return .ecdsaSecp256k1PublicKey
            
        case .ecdsaSecp256k1Signature:
            return .ecdsaSecp256k1Signature
            
        case .eddsaEd25519PublicKey:
            return .eddsaEd25519PublicKey
            
        case .eddsaEd25519Signature:
            return .eddsaEd25519Signature
            
        case .blob:
            return .blob
            
        case .expression:
            return .expression
        }
    }
}

public extension Value {
    
    // MARK: CodingKeys
    private enum CodingKeys: String, CodingKey {
        case type
    }
    
    // MARK: Codable
    func encode(to encoder: Encoder) throws {
        switch self {
        
        case .unit(let value):
            try value.encode(to: encoder)
            
        case .boolean(let value):
            // `Bool` is already `Codable` so we have to go through its proxy type for JSON coding.
            try value.proxyEncodable.encode(to: encoder)
            
        case .i8(let value):
            // `Int8` is already `Codable` so we have to go through its proxy type for JSON coding.
            try value.proxyEncodable.encode(to: encoder)
        
        case .i16(let value):
            // `Int16` is already `Codable` so we have to go through its proxy type for JSON coding.
            try value.proxyEncodable.encode(to: encoder)
        
        case .i32(let value):
            // `Int32` is already `Codable` so we have to go through its proxy type for JSON coding.
            try value.proxyEncodable.encode(to: encoder)
        
        case .i64(let value):
            // `Int64` is already `Codable` so we have to go through its proxy type for JSON coding.
            try value.proxyEncodable.encode(to: encoder)
        
        case .i128(let value):
            try value.encode(to: encoder)
            
        case .u8(let value):
            // `UInt8` is already `Codable` so we have to go through its proxy type for JSON coding.
            try value.proxyEncodable.encode(to: encoder)
        
        case .u16(let value):
            // `UInt16` is already `Codable` so we have to go through its proxy type for JSON coding.
            try value.proxyEncodable.encode(to: encoder)
        
        case .u32(let value):
            // `UInt32` is already `Codable` so we have to go through its proxy type for JSON coding.
            try value.proxyEncodable.encode(to: encoder)
        
        case .u64(let value):
            // `UInt64` is already `Codable` so we have to go through its proxy type for JSON coding.
            try value.proxyEncodable.encode(to: encoder)
        
        case .u128(let value):
            try value.encode(to: encoder)
            
        case .string(let value):
            // `String` is already `Codable` so we have to go through its proxy type for JSON coding.
            try value.proxyEncodable.encode(to: encoder)
        
        case .enum(let value):
            try value.encode(to: encoder)
            
        case .array(let value):
            try value.encode(to: encoder)
        
        case .tuple(let value):
            try value.encode(to: encoder)
        
        case .decimal(let value):
            try value.encode(to: encoder)
        
        case .preciseDecimal(let value):
            try value.encode(to: encoder)
            
        case .component(let value):
            try value.encode(to: encoder)
        
        case .packageAddress(let value):
            try value.encode(to: encoder)
        
        case .componentAddress(let value):
            try value.encode(to: encoder)
        
        case .resourceAddress(let value):
            try value.encode(to: encoder)
            
        case .systemAddress(let value):
            try value.encode(to: encoder)
            
        case .hash(let value):
            try value.encode(to: encoder)
            
        case .bucket(let value):
            try value.encode(to: encoder)
        
        case .proof(let value):
            try value.encode(to: encoder)
        
        case .vault(let value):
            try value.encode(to: encoder)
            
        case .nonFungibleId(let value):
            try value.encode(to: encoder)
        
        case .nonFungibleAddress(let value):
            try value.encode(to: encoder)
            
        case .keyValueStore(let value):
            try value.encode(to: encoder)
            
        case .ecdsaSecp256k1PublicKey(let value):
            try value.encode(to: encoder)
        
        case .ecdsaSecp256k1Signature(let value):
            try value.encode(to: encoder)
        
        case .eddsaEd25519PublicKey(let value):
            try value.encode(to: encoder)
        
        case .eddsaEd25519Signature(let value):
            try value.encode(to: encoder)
            
        case .blob(let value):
            try value.encode(to: encoder)
        
        case .expression(let value):
            try value.encode(to: encoder)
        }
    }
    
    init(from decoder: Decoder) throws {
        // Checking for type discriminator
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let kind: ValueKind = try container.decode(ValueKind.self, forKey: .type)
        
        switch kind {
            
        case .unit:
            self = try .unit(.init(from: decoder))
            
        case .bool:
            // `Bool` is already `Codable` so we have to go through its proxy type for JSON coding.
            self = try .boolean(Bool.ProxyDecodable(from: decoder).decoded)
            
        case .i8:
            // `Int8` is already `Codable` so we have to go through its proxy type for JSON coding.
            self = try .i8(Int8.ProxyDecodable(from: decoder).decoded)
            
        case .i16:
            // `Int16` is already `Codable` so we have to go through its proxy type for JSON coding.
            self = try .i16(Int16.ProxyDecodable(from: decoder).decoded)
            
        case .i32:
            // `Int32` is already `Codable` so we have to go through its proxy type for JSON coding.
            self = try .i32(Int32.ProxyDecodable(from: decoder).decoded)
            
        case .i64:
            // `Int64` is already `Codable` so we have to go through its proxy type for JSON coding.
            self = try .i64(Int64.ProxyDecodable(from: decoder).decoded)
            
        case .i128:
            self = try .i128(.init(from: decoder))
            
        case .u8:
            // `UInt8` is already `Codable` so we have to go through its proxy type for JSON coding.
            self = try .u8(UInt8.ProxyDecodable(from: decoder).decoded)
            
        case .u16:
            // `UInt16` is already `Codable` so we have to go through its proxy type for JSON coding.
            self = try .u16(UInt16.ProxyDecodable(from: decoder).decoded)
            
        case .u32:
            // `UInt32` is already `Codable` so we have to go through its proxy type for JSON coding.
            self = try .u32(UInt32.ProxyDecodable(from: decoder).decoded)
            
        case .u64:
            // `UInt64` is already `Codable` so we have to go through its proxy type for JSON coding.
            self = try .u64(UInt64.ProxyDecodable(from: decoder).decoded)
            
        case .u128:
            self = try .u128(.init(from: decoder))
            
        case .string:
            // `String` is already `Codable` so we have to go through its proxy type for JSON coding.
            self = try .string(String.ProxyDecodable(from: decoder).decoded)
            
        case .enum:
            self = try .enum(.init(from: decoder))
            
        case .array:
            self = try .array(.init(from: decoder))
            
        case .tuple:
            self = try .tuple(.init(from: decoder))
            
        case .decimal:
            self = try .decimal(.init(from: decoder))
            
        case .preciseDecimal:
            self = try .preciseDecimal(.init(from: decoder))
            
        case .component:
            self = try .component(.init(from: decoder))
            
        case .packageAddress:
            self = try .packageAddress(.init(from: decoder))
            
        case .componentAddress:
            self = try .componentAddress(.init(from: decoder))
            
        case .resourceAddress:
            self = try .resourceAddress(.init(from: decoder))
            
        case .systemAddress:
            self = try .systemAddress(.init(from: decoder))
            
        case .hash:
            self = try .hash(.init(from: decoder))
            
        case .bucket:
            self = try .bucket(.init(from: decoder))
            
        case .proof:
            self = try .proof(.init(from: decoder))
            
        case .vault:
            self = try .vault(.init(from: decoder))
            
        case .nonFungibleId:
            self = try .nonFungibleId(.init(from: decoder))
            
        case .nonFungibleAddress:
            self = try .nonFungibleAddress(.init(from: decoder))
            
        case .keyValueStore:
            self = try .keyValueStore(.init(from: decoder))
            
        case .ecdsaSecp256k1PublicKey:
            self = try .ecdsaSecp256k1PublicKey(.init(from: decoder))
            
        case .ecdsaSecp256k1Signature:
            self = try .ecdsaSecp256k1Signature(.init(from: decoder))
            
        case .eddsaEd25519PublicKey:
            self = try .eddsaEd25519PublicKey(.init(from: decoder))
            
        case .eddsaEd25519Signature:
            self = try .eddsaEd25519Signature(.init(from: decoder))
            
        case .blob:
            self = try .blob(.init(from: decoder))
            
        case .expression:
            self = try .expression(.init(from: decoder))
            
        }
    }
}


