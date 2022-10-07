import Foundation

public indirect enum Value: Sendable, Codable, Hashable {
    // ==============
    // Enum Variants
    // ==============
    
    case unit(Unit)
    case boolean(Boolean)
    
    case i8(I8)
    case i16(I16)
    case i32(I32)
    case i64(I64)
    case i128(I128)
    
    case u8(U8)
    case u16(U16)
    case u32(U32)
    case u64(U64)
    case u128(U128)
    
    case string(String_)
    
    case `struct`(Struct)
    case `enum`(Enum)
    
    case option(Option)
    case array(Array_)
    case tuple(Tuple)
    case result(Result<Value, Value>)
    
    case list(List)
    case set(Set_)
    case map(Map)
    
    case decimal(Decimal_)
    case preciseDecimal(PreciseDecimal)
    
    case component(Component)
    case packageAddress(PackageAddress)
    case componentAddress(ComponentAddress)
    case resourceAddress(ResourceAddress)
    
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
    // =============
    // Constructors
    // =============
    
    init(value: Unit) {
        self = .unit(value)
    }
    init(value: Boolean) {
        self = .boolean(value)
    }
    
    init(value: I8) {
        self = .i8(value)
    }
    init(value: I16) {
        self = .i16(value)
    }
    init(value: I32) {
        self = .i32(value)
    }
    init(value: I64) {
        self = .i64(value)
    }
    init(value: I128) {
        self = .i128(value)
    }
    
    init(value: U8) {
        self = .u8(value)
    }
    init(value: U16) {
        self = .u16(value)
    }
    init(value: U32) {
        self = .u32(value)
    }
    init(value: U64) {
        self = .u64(value)
    }
    init(value: U128) {
        self = .u128(value)
    }
    
    init(value: String_) {
        self = .string(value)
    }
    
    init(value: Struct) {
        self = .struct(value)
    }
    init(value: Enum) {
        self = .enum(value)
    }
    
    init(value: Option) {
        self = .option(value)
    }
    init(value: Array_) {
        self = .array(value)
    }
    init(value: Tuple) {
        self = .tuple(value)
    }
    init(value: Result<Value, Value>) {
        self = .result(value)
    }
    
    init(value: List) {
        self = .list(value)
    }
    init(value: Set_) {
        self = .set(value)
    }
    init(value: Map) {
        self = .map(value)
    }
    
    init(value: Decimal_) {
        self = .decimal(value)
    }
    init(value: PreciseDecimal) {
        self = .preciseDecimal(value)
    }
    
    init(value: Component) {
        self = .component(value)
    }
    init(value: PackageAddress) {
        self = .packageAddress(value)
    }
    init(value: ComponentAddress) {
        self = .componentAddress(value)
    }
    init(value: ResourceAddress) {
        self = .resourceAddress(value)
    }
    
    init(value: Hash) {
        self = .hash(value)
    }
    
    init(value: Bucket) {
        self = .bucket(value)
    }
    init(value: Proof) {
        self = .proof(value)
    }
    init(value: Vault) {
        self = .vault(value)
    }
    
    init(value: NonFungibleId) {
        self = .nonFungibleId(value)
    }
    init(value: NonFungibleAddress) {
        self = .nonFungibleAddress(value)
    }
    
    init(value: KeyValueStore) {
        self = .keyValueStore(value)
    }
    
    init(value: EcdsaSecp256k1PublicKey) {
        self = .ecdsaSecp256k1PublicKey(value)
    }
    init(value: EcdsaSecp256k1Signature) {
        self = .ecdsaSecp256k1Signature(value)
    }
    init(value: EddsaEd25519PublicKey) {
        self = .eddsaEd25519PublicKey(value)
    }
    init(value: EddsaEd25519Signature) {
        self = .eddsaEd25519Signature(value)
    }
    
    init(value: Blob) {
        self = .blob(value)
    }
    init(value: Expression) {
        self = .expression(value)
    }
}

public extension Value {
    
    // ===========
    // Value Kind
    // ===========
    
    func kind() -> ValueKind {
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
            
        case .struct:
            return .struct
        case .enum:
            return .enum
            
        case .option:
            return .option
        case .array:
            return .array
        case .tuple:
            return .tuple
        case .result:
            return .result
            
        case .list:
            return .list
        case .set:
            return .set
        case .map:
            return .map
            
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
    
    // =======================
    // Coding Keys Definition
    // =======================
    private enum CodingKeys: String, CodingKey {
        case type
    }
    
    // ======================
    // Encoding and Decoding
    // ======================
    func encode(to encoder: Encoder) throws {
        switch self {
            case .unit(let value):
                try value.encode(to: encoder)
            case .boolean(let value):
                try value.encode(to: encoder)

            case .i8(let value):
                try value.encode(to: encoder)
            case .i16(let value):
                try value.encode(to: encoder)
            case .i32(let value):
                try value.encode(to: encoder)
            case .i64(let value):
                try value.encode(to: encoder)
            case .i128(let value):
                try value.encode(to: encoder)

            case .u8(let value):
                try value.encode(to: encoder)
            case .u16(let value):
                try value.encode(to: encoder)
            case .u32(let value):
                try value.encode(to: encoder)
            case .u64(let value):
                try value.encode(to: encoder)
            case .u128(let value):
                try value.encode(to: encoder)

            case .string(let value):
                try value.encode(to: encoder)

            case .struct(let value):
                try value.encode(to: encoder)
            case .enum(let value):
                try value.encode(to: encoder)

            case .option(let value):
                try value.encode(to: encoder)
            case .array(let value):
                try value.encode(to: encoder)
            case .tuple(let value):
                try value.encode(to: encoder)
            case .result(let value):
                try value.encode(to: encoder)

            case .list(let value):
                try value.encode(to: encoder)
            case .set(let value):
                try value.encode(to: encoder)
            case .map(let value):
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
            self = try Self(value: Unit(from: decoder))
        case .bool:
            self = try Self(value: Boolean(from: decoder))

        case .i8:
            self = try Self(value: I8(from: decoder))
        case .i16:
            self = try Self(value: I16(from: decoder))
        case .i32:
            self = try Self(value: I32(from: decoder))
        case .i64:
            self = try Self(value: I64(from: decoder))
        case .i128:
            self = try Self(value: I128(from: decoder))

        case .u8:
            self = try Self(value: U8(from: decoder))
        case .u16:
            self = try Self(value: U16(from: decoder))
        case .u32:
            self = try Self(value: U32(from: decoder))
        case .u64:
            self = try Self(value: U64(from: decoder))
        case .u128:
            self = try Self(value: U128(from: decoder))

        case .string:
            self = try Self(value: String_(from: decoder))

        case .struct:
            self = try Self(value: Struct(from: decoder))
        case .enum:
            self = try Self(value: Enum(from: decoder))

        case .option:
            self = try Self(value: Option(from: decoder))
        case .array:
            self = try Self(value: Array_(from: decoder))
        case .tuple:
            self = try Self(value: Tuple(from: decoder))
        case .result:
            self = try Self(value: Result(from: decoder))

        case .list:
            self = try Self(value: List(from: decoder))
        case .set:
            self = try Self(value: Set_(from: decoder))
        case .map:
            self = try Self(value: Map(from: decoder))

        case .decimal:
            self = try Self(value: Decimal_(from: decoder))
        case .preciseDecimal:
            self = try Self(value: PreciseDecimal(from: decoder))

        case .component:
            self = try Self(value: Component(from: decoder))
        case .packageAddress:
            self = try Self(value: PackageAddress(from: decoder))
        case .componentAddress:
            self = try Self(value: ComponentAddress(from: decoder))
        case .resourceAddress:
            self = try Self(value: ResourceAddress(from: decoder))

        case .hash:
            self = try Self(value: Hash(from: decoder))

        case .bucket:
            self = try Self(value: Bucket(from: decoder))
        case .proof:
            self = try Self(value: Proof(from: decoder))
        case .vault:
            self = try Self(value: Vault(from: decoder))

        case .nonFungibleId:
            self = try Self(value: NonFungibleId(from: decoder))
        case .nonFungibleAddress:
            self = try Self(value: NonFungibleAddress(from: decoder))

        case .keyValueStore:
            self = try Self(value: KeyValueStore(from: decoder))

        case .ecdsaSecp256k1PublicKey:
            self = try Self(value: EcdsaSecp256k1PublicKey(from: decoder))
        case .ecdsaSecp256k1Signature:
            self = try Self(value: EcdsaSecp256k1Signature(from: decoder))
        case .eddsaEd25519PublicKey:
            self = try Self(value: EddsaEd25519PublicKey(from: decoder))
        case .eddsaEd25519Signature:
            self = try Self(value: EddsaEd25519Signature(from: decoder))

        case .blob:
            self = try Self(value: Blob(from: decoder))
        case .expression:
            self = try Self(value: Expression(from: decoder))

        }
    }
}


