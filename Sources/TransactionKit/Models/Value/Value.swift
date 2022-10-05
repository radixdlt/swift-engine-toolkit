import Foundation

public indirect enum Value: Sendable, Codable, Hashable {
    // ==============
    // Enum Variants
    // ==============
    
    case unitType(Unit)
    case booleanType(Boolean)
    
    case i8Type(I8)
    case i16Type(I16)
    case i32Type(I32)
    case i64Type(I64)
    case i128Type(I128)
    
    case u8Type(U8)
    case u16Type(U16)
    case u32Type(U32)
    case u64Type(U64)
    case u128Type(U128)
    
    case stringType(String_)
    
    case structType(Struct)
    case enumType(Enum)
    
    case optionType(Option)
    case arrayType(Array_)
    case tupleType(Tuple)
    case resultType(Result)
    
    case listType(List)
    case setType(Set_)
    case mapType(Map)
    
    case decimalType(Decimal_)
    case preciseDecimalType(PreciseDecimal)
    
    case componentType(Component)
    case packageAddressType(PackageAddress)
    case componentAddressType(ComponentAddress)
    case resourceAddressType(ResourceAddress)
    
    case hashType(Hash)
    
    case bucketType(Bucket)
    case proofType(Proof)
    case vaultType(Vault)
    
    case nonFungibleIdType(NonFungibleId)
    case nonFungibleAddressType(NonFungibleAddress)
    
    case keyValueStoreType(KeyValueStore)
    
    case ecdsaSecp256k1PublicKeyType(EcdsaSecp256k1PublicKey)
    case ecdsaSecp256k1SignatureType(EcdsaSecp256k1Signature)
    case eddsaEd25519PublicKeyType(EddsaEd25519PublicKey)
    case eddsaEd25519SignatureType(EddsaEd25519Signature)
    
    case blobType(Blob)
    case expressionType(Expression)
}

public extension Value {
    // =============
    // Constructors
    // =============
    
    init(from value: Unit) {
        self = .unitType(value)
    }
    init(from value: Boolean) {
        self = .booleanType(value)
    }
    
    init(from value: I8) {
        self = .i8Type(value)
    }
    init(from value: I16) {
        self = .i16Type(value)
    }
    init(from value: I32) {
        self = .i32Type(value)
    }
    init(from value: I64) {
        self = .i64Type(value)
    }
    init(from value: I128) {
        self = .i128Type(value)
    }
    
    init(from value: U8) {
        self = .u8Type(value)
    }
    init(from value: U16) {
        self = .u16Type(value)
    }
    init(from value: U32) {
        self = .u32Type(value)
    }
    init(from value: U64) {
        self = .u64Type(value)
    }
    init(from value: U128) {
        self = .u128Type(value)
    }
    
    init(from value: String_) {
        self = .stringType(value)
    }
    
    init(from value: Struct) {
        self = .structType(value)
    }
    init(from value: Enum) {
        self = .enumType(value)
    }
    
    init(from value: Option) {
        self = .optionType(value)
    }
    init(from value: Array_) {
        self = .arrayType(value)
    }
    init(from value: Tuple) {
        self = .tupleType(value)
    }
    init(from value: Result) {
        self = .resultType(value)
    }
    
    init(from value: List) {
        self = .listType(value)
    }
    init(from value: Set_) {
        self = .setType(value)
    }
    init(from value: Map) {
        self = .mapType(value)
    }
    
    init(from value: Decimal_) {
        self = .decimalType(value)
    }
    init(from value: PreciseDecimal) {
        self = .preciseDecimalType(value)
    }
    
    init(from value: Component) {
        self = .componentType(value)
    }
    init(from value: PackageAddress) {
        self = .packageAddressType(value)
    }
    init(from value: ComponentAddress) {
        self = .componentAddressType(value)
    }
    init(from value: ResourceAddress) {
        self = .resourceAddressType(value)
    }
    
    init(from value: Hash) {
        self = .hashType(value)
    }
    
    init(from value: Bucket) {
        self = .bucketType(value)
    }
    init(from value: Proof) {
        self = .proofType(value)
    }
    init(from value: Vault) {
        self = .vaultType(value)
    }
    
    init(from value: NonFungibleId) {
        self = .nonFungibleIdType(value)
    }
    init(from value: NonFungibleAddress) {
        self = .nonFungibleAddressType(value)
    }
    
    init(from value: KeyValueStore) {
        self = .keyValueStoreType(value)
    }
    
    init(from value: EcdsaSecp256k1PublicKey) {
        self = .ecdsaSecp256k1PublicKeyType(value)
    }
    init(from value: EcdsaSecp256k1Signature) {
        self = .ecdsaSecp256k1SignatureType(value)
    }
    init(from value: EddsaEd25519PublicKey) {
        self = .eddsaEd25519PublicKeyType(value)
    }
    init(from value: EddsaEd25519Signature) {
        self = .eddsaEd25519SignatureType(value)
    }
    
    init(from value: Blob) {
        self = .blobType(value)
    }
    init(from value: Expression) {
        self = .expressionType(value)
    }
}

public extension Value {
    
    // ===========
    // Value Kind
    // ===========
    
    func kind() -> ValueKind {
        switch self {
        case .unitType(_):
            return .unit
        case .booleanType(_):
            return .bool
            
        case .i8Type(_):
            return .i8
        case .i16Type(_):
            return .i16
        case .i32Type(_):
            return .i32
        case .i64Type(_):
            return .i64
        case .i128Type(_):
            return .i128
            
        case .u8Type(_):
            return .u8
        case .u16Type(_):
            return .u16
        case .u32Type(_):
            return .u32
        case .u64Type(_):
            return .u64
        case .u128Type(_):
            return .u128
            
        case .stringType(_):
            return .string
            
        case .structType(_):
            return .struct
        case .enumType(_):
            return .enum
            
        case .optionType(_):
            return .option
        case .arrayType(_):
            return .array
        case .tupleType(_):
            return .tuple
        case .resultType(_):
            return .result
            
        case .listType(_):
            return .list
        case .setType(_):
            return .set
        case .mapType(_):
            return .map
            
        case .decimalType(_):
            return .decimal
        case .preciseDecimalType(_):
            return .preciseDecimal
            
        case .componentType(_):
            return .component
        case .packageAddressType(_):
            return .packageAddress
        case .componentAddressType(_):
            return .componentAddress
        case .resourceAddressType(_):
            return .resourceAddress
            
        case .hashType(_):
            return .hash
            
        case .bucketType(_):
            return .bucket
        case .proofType(_):
            return .proof
        case .vaultType(_):
            return .vault
            
        case .nonFungibleIdType(_):
            return .nonFungibleId
        case .nonFungibleAddressType(_):
            return .nonFungibleAddress
            
        case .keyValueStoreType(_):
            return .keyValueStore
            
        case .ecdsaSecp256k1PublicKeyType(_):
            return .ecdsaSecp256k1PublicKey
        case .ecdsaSecp256k1SignatureType(_):
            return .ecdsaSecp256k1Signature
        case .eddsaEd25519PublicKeyType(_):
            return .eddsaEd25519PublicKey
        case .eddsaEd25519SignatureType(_):
            return .eddsaEd25519Signature
            
        case .blobType(_):
            return .blob
        case .expressionType(_):
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
            case .unitType(let value):
                try value.encode(to: encoder)
            case .booleanType(let value):
                try value.encode(to: encoder)

            case .i8Type(let value):
                try value.encode(to: encoder)
            case .i16Type(let value):
                try value.encode(to: encoder)
            case .i32Type(let value):
                try value.encode(to: encoder)
            case .i64Type(let value):
                try value.encode(to: encoder)
            case .i128Type(let value):
                try value.encode(to: encoder)

            case .u8Type(let value):
                try value.encode(to: encoder)
            case .u16Type(let value):
                try value.encode(to: encoder)
            case .u32Type(let value):
                try value.encode(to: encoder)
            case .u64Type(let value):
                try value.encode(to: encoder)
            case .u128Type(let value):
                try value.encode(to: encoder)

            case .stringType(let value):
                try value.encode(to: encoder)

            case .structType(let value):
                try value.encode(to: encoder)
            case .enumType(let value):
                try value.encode(to: encoder)

            case .optionType(let value):
                try value.encode(to: encoder)
            case .arrayType(let value):
                try value.encode(to: encoder)
            case .tupleType(let value):
                try value.encode(to: encoder)
            case .resultType(let value):
                try value.encode(to: encoder)

            case .listType(let value):
                try value.encode(to: encoder)
            case .setType(let value):
                try value.encode(to: encoder)
            case .mapType(let value):
                try value.encode(to: encoder)

            case .decimalType(let value):
                try value.encode(to: encoder)
            case .preciseDecimalType(let value):
                try value.encode(to: encoder)

            case .componentType(let value):
                try value.encode(to: encoder)
            case .packageAddressType(let value):
                try value.encode(to: encoder)
            case .componentAddressType(let value):
                try value.encode(to: encoder)
            case .resourceAddressType(let value):
                try value.encode(to: encoder)

            case .hashType(let value):
                try value.encode(to: encoder)

            case .bucketType(let value):
                try value.encode(to: encoder)
            case .proofType(let value):
                try value.encode(to: encoder)
            case .vaultType(let value):
                try value.encode(to: encoder)

            case .nonFungibleIdType(let value):
                try value.encode(to: encoder)
            case .nonFungibleAddressType(let value):
                try value.encode(to: encoder)

            case .keyValueStoreType(let value):
                try value.encode(to: encoder)

            case .ecdsaSecp256k1PublicKeyType(let value):
                try value.encode(to: encoder)
            case .ecdsaSecp256k1SignatureType(let value):
                try value.encode(to: encoder)
            case .eddsaEd25519PublicKeyType(let value):
                try value.encode(to: encoder)
            case .eddsaEd25519SignatureType(let value):
                try value.encode(to: encoder)

            case .blobType(let value):
                try value.encode(to: encoder)
            case .expressionType(let value):
                try value.encode(to: encoder)
        }
    }
    
    init(from decoder: Decoder) throws {
        // Checking for type discriminator
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let kind: ValueKind = try container.decode(ValueKind.self, forKey: .type)
        
        switch kind {
            
        case .unit:
            self = Self(from: try Unit(from: decoder))
        case .bool:
            self = Self(from: try Boolean(from: decoder))

        case .i8:
            self = Self(from: try I8(from: decoder))
        case .i16:
            self = Self(from: try I16(from: decoder))
        case .i32:
            self = Self(from: try I32(from: decoder))
        case .i64:
            self = Self(from: try I64(from: decoder))
        case .i128:
            self = Self(from: try I128(from: decoder))

        case .u8:
            self = Self(from: try U8(from: decoder))
        case .u16:
            self = Self(from: try U16(from: decoder))
        case .u32:
            self = Self(from: try U32(from: decoder))
        case .u64:
            self = Self(from: try U64(from: decoder))
        case .u128:
            self = Self(from: try U128(from: decoder))

        case .string:
            self = Self(from: try String_(from: decoder))

        case .struct:
            self = Self(from: try Struct(from: decoder))
        case .enum:
            self = Self(from: try Enum(from: decoder))

        case .option:
            self = Self(from: try Option(from: decoder))
        case .array:
            self = Self(from: try Array_(from: decoder))
        case .tuple:
            self = Self(from: try Tuple(from: decoder))
        case .result:
            self = Self(from: try Result(from: decoder))

        case .list:
            self = Self(from: try List(from: decoder))
        case .set:
            self = Self(from: try Set_(from: decoder))
        case .map:
            self = Self(from: try Map(from: decoder))

        case .decimal:
            self = Self(from: try Decimal_(from: decoder))
        case .preciseDecimal:
            self = Self(from: try PreciseDecimal(from: decoder))

        case .component:
            self = Self(from: try Component(from: decoder))
        case .packageAddress:
            self = Self(from: try PackageAddress(from: decoder))
        case .componentAddress:
            self = Self(from: try ComponentAddress(from: decoder))
        case .resourceAddress:
            self = Self(from: try ResourceAddress(from: decoder))

        case .hash:
            self = Self(from: try Hash(from: decoder))

        case .bucket:
            self = Self(from: try Bucket(from: decoder))
        case .proof:
            self = Self(from: try Proof(from: decoder))
        case .vault:
            self = Self(from: try Vault(from: decoder))

        case .nonFungibleId:
            self = Self(from: try NonFungibleId(from: decoder))
        case .nonFungibleAddress:
            self = Self(from: try NonFungibleAddress(from: decoder))

        case .keyValueStore:
            self = Self(from: try KeyValueStore(from: decoder))

        case .ecdsaSecp256k1PublicKey:
            self = Self(from: try EcdsaSecp256k1PublicKey(from: decoder))
        case .ecdsaSecp256k1Signature:
            self = Self(from: try EcdsaSecp256k1Signature(from: decoder))
        case .eddsaEd25519PublicKey:
            self = Self(from: try EddsaEd25519PublicKey(from: decoder))
        case .eddsaEd25519Signature:
            self = Self(from: try EddsaEd25519Signature(from: decoder))

        case .blob:
            self = Self(from: try Blob(from: decoder))
        case .expression:
            self = Self(from: try Expression(from: decoder))

        }
    }
}

enum DecodeError: Error {
    case valueTypeDiscriminatorMismatch(ValueKind, ValueKind)
    case instructionTypeDiscriminatorMismatch(InstructionKind, InstructionKind)
    case parsingError
    case typeMismatch
    case invalidManifestInstructionsType(String)
}
