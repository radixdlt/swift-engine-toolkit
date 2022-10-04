import Foundation

public indirect enum Value: Sendable, Codable, Hashable {
    // ==============
    // Enum Variants
    // ==============
    
    case UnitType(Unit)
    case BooleanType(Boolean)
    
    case I8Type(I8)
    case I16Type(I16)
    case I32Type(I32)
    case I64Type(I64)
    case I128Type(I128)
    
    case U8Type(U8)
    case U16Type(U16)
    case U32Type(U32)
    case U64Type(U64)
    case U128Type(U128)
    
    case StringType(String_)
    
    case StructType(Struct)
    case EnumType(Enum)
    
    case OptionType(Option)
    case ArrayType(Array_)
    case TupleType(Tuple)
    case ResultType(Result)
    
    case ListType(List)
    case SetType(Set_)
    case MapType(Map)
    
    case DecimalType(Decimal_)
    case PreciseDecimalType(PreciseDecimal)
    
    case ComponentType(Component)
    case PackageAddressType(PackageAddress)
    case ComponentAddressType(ComponentAddress)
    case ResourceAddressType(ResourceAddress)
    
    case HashType(Hash)
    
    case BucketType(Bucket)
    case ProofType(Proof)
    case VaultType(Vault)
    
    case NonFungibleIdType(NonFungibleId)
    case NonFungibleAddressType(NonFungibleAddress)
    
    case KeyValueStoreType(KeyValueStore)
    
    case EcdsaSecp256k1PublicKeyType(EcdsaSecp256k1PublicKey)
    case EcdsaSecp256k1SignatureType(EcdsaSecp256k1Signature)
    case EddsaEd25519PublicKeyType(EddsaEd25519PublicKey)
    case EddsaEd25519SignatureType(EddsaEd25519Signature)
    
    case BlobType(Blob)
    case ExpressionType(Expression)
}

public extension Value {
    // =============
    // Constructors
    // =============
    
    init(from value: Unit) {
        self = Self.UnitType(value)
    }
    init(from value: Boolean) {
        self = Self.BooleanType(value)
    }
    
    init(from value: I8) {
        self = Self.I8Type(value)
    }
    init(from value: I16) {
        self = Self.I16Type(value)
    }
    init(from value: I32) {
        self = Self.I32Type(value)
    }
    init(from value: I64) {
        self = Self.I64Type(value)
    }
    init(from value: I128) {
        self = Self.I128Type(value)
    }
    
    init(from value: U8) {
        self = Self.U8Type(value)
    }
    init(from value: U16) {
        self = Self.U16Type(value)
    }
    init(from value: U32) {
        self = Self.U32Type(value)
    }
    init(from value: U64) {
        self = Self.U64Type(value)
    }
    init(from value: U128) {
        self = Self.U128Type(value)
    }
    
    init(from value: String_) {
        self = Self.StringType(value)
    }
    
    init(from value: Struct) {
        self = Self.StructType(value)
    }
    init(from value: Enum) {
        self = Self.EnumType(value)
    }
    
    init(from value: Option) {
        self = Self.OptionType(value)
    }
    init(from value: Array_) {
        self = Self.ArrayType(value)
    }
    init(from value: Tuple) {
        self = Self.TupleType(value)
    }
    init(from value: Result) {
        self = Self.ResultType(value)
    }
    
    init(from value: List) {
        self = Self.ListType(value)
    }
    init(from value: Set_) {
        self = Self.SetType(value)
    }
    init(from value: Map) {
        self = Self.MapType(value)
    }
    
    init(from value: Decimal_) {
        self = Self.DecimalType(value)
    }
    init(from value: PreciseDecimal) {
        self = Self.PreciseDecimalType(value)
    }
    
    init(from value: Component) {
        self = Self.ComponentType(value)
    }
    init(from value: PackageAddress) {
        self = Self.PackageAddressType(value)
    }
    init(from value: ComponentAddress) {
        self = Self.ComponentAddressType(value)
    }
    init(from value: ResourceAddress) {
        self = Self.ResourceAddressType(value)
    }
    
    init(from value: Hash) {
        self = Self.HashType(value)
    }
    
    init(from value: Bucket) {
        self = Self.BucketType(value)
    }
    init(from value: Proof) {
        self = Self.ProofType(value)
    }
    init(from value: Vault) {
        self = Self.VaultType(value)
    }
    
    init(from value: NonFungibleId) {
        self = Self.NonFungibleIdType(value)
    }
    init(from value: NonFungibleAddress) {
        self = Self.NonFungibleAddressType(value)
    }
    
    init(from value: KeyValueStore) {
        self = Self.KeyValueStoreType(value)
    }
    
    init(from value: EcdsaSecp256k1PublicKey) {
        self = Self.EcdsaSecp256k1PublicKeyType(value)
    }
    init(from value: EcdsaSecp256k1Signature) {
        self = Self.EcdsaSecp256k1SignatureType(value)
    }
    init(from value: EddsaEd25519PublicKey) {
        self = Self.EddsaEd25519PublicKeyType(value)
    }
    init(from value: EddsaEd25519Signature) {
        self = Self.EddsaEd25519SignatureType(value)
    }
    
    init(from value: Blob) {
        self = Self.BlobType(value)
    }
    init(from value: Expression) {
        self = Self.ExpressionType(value)
    }
}

public extension Value {
    
    // ===========
    // Value Kind
    // ===========
    
    func kind() -> ValueKind {
        switch self {
        case .UnitType(_):
            return ValueKind.Unit
        case .BooleanType(_):
            return ValueKind.Bool
            
        case .I8Type(_):
            return ValueKind.I8
        case .I16Type(_):
            return ValueKind.I16
        case .I32Type(_):
            return ValueKind.I32
        case .I64Type(_):
            return ValueKind.I64
        case .I128Type(_):
            return ValueKind.I128
            
        case .U8Type(_):
            return ValueKind.U8
        case .U16Type(_):
            return ValueKind.U16
        case .U32Type(_):
            return ValueKind.U32
        case .U64Type(_):
            return ValueKind.U64
        case .U128Type(_):
            return ValueKind.U128
            
        case .StringType(_):
            return ValueKind.String
            
        case .StructType(_):
            return ValueKind.Struct
        case .EnumType(_):
            return ValueKind.Enum
            
        case .OptionType(_):
            return ValueKind.Option
        case .ArrayType(_):
            return ValueKind.Array
        case .TupleType(_):
            return ValueKind.Tuple
        case .ResultType(_):
            return ValueKind.Result
            
        case .ListType(_):
            return ValueKind.List
        case .SetType(_):
            return ValueKind.Set
        case .MapType(_):
            return ValueKind.Map
            
        case .DecimalType(_):
            return ValueKind.Decimal
        case .PreciseDecimalType(_):
            return ValueKind.PreciseDecimal
            
        case .ComponentType(_):
            return ValueKind.Component
        case .PackageAddressType(_):
            return ValueKind.PackageAddress
        case .ComponentAddressType(_):
            return ValueKind.ComponentAddress
        case .ResourceAddressType(_):
            return ValueKind.ResourceAddress
            
        case .HashType(_):
            return ValueKind.Hash
            
        case .BucketType(_):
            return ValueKind.Bucket
        case .ProofType(_):
            return ValueKind.Proof
        case .VaultType(_):
            return ValueKind.Vault
            
        case .NonFungibleIdType(_):
            return ValueKind.NonFungibleId
        case .NonFungibleAddressType(_):
            return ValueKind.NonFungibleAddress
            
        case .KeyValueStoreType(_):
            return ValueKind.KeyValueStore
            
        case .EcdsaSecp256k1PublicKeyType(_):
            return ValueKind.EcdsaSecp256k1PublicKey
        case .EcdsaSecp256k1SignatureType(_):
            return ValueKind.EcdsaSecp256k1Signature
        case .EddsaEd25519PublicKeyType(_):
            return ValueKind.EddsaEd25519PublicKey
        case .EddsaEd25519SignatureType(_):
            return ValueKind.EddsaEd25519Signature
            
        case .BlobType(_):
            return ValueKind.Blob
        case .ExpressionType(_):
            return ValueKind.Expression
        }
    }
}

public extension Value {
    
    // =======================
    // Coding Keys Definition
    // =======================
    private enum CodingKeys : String, CodingKey {
        case type
    }
    
    // ======================
    // Encoding and Decoding
    // ======================
    func encode(to encoder: Encoder) throws {
        switch self {
            case .UnitType(let value):
                try value.encode(to: encoder)
            case .BooleanType(let value):
                try value.encode(to: encoder)

            case .I8Type(let value):
                try value.encode(to: encoder)
            case .I16Type(let value):
                try value.encode(to: encoder)
            case .I32Type(let value):
                try value.encode(to: encoder)
            case .I64Type(let value):
                try value.encode(to: encoder)
            case .I128Type(let value):
                try value.encode(to: encoder)

            case .U8Type(let value):
                try value.encode(to: encoder)
            case .U16Type(let value):
                try value.encode(to: encoder)
            case .U32Type(let value):
                try value.encode(to: encoder)
            case .U64Type(let value):
                try value.encode(to: encoder)
            case .U128Type(let value):
                try value.encode(to: encoder)

            case .StringType(let value):
                try value.encode(to: encoder)

            case .StructType(let value):
                try value.encode(to: encoder)
            case .EnumType(let value):
                try value.encode(to: encoder)

            case .OptionType(let value):
                try value.encode(to: encoder)
            case .ArrayType(let value):
                try value.encode(to: encoder)
            case .TupleType(let value):
                try value.encode(to: encoder)
            case .ResultType(let value):
                try value.encode(to: encoder)

            case .ListType(let value):
                try value.encode(to: encoder)
            case .SetType(let value):
                try value.encode(to: encoder)
            case .MapType(let value):
                try value.encode(to: encoder)

            case .DecimalType(let value):
                try value.encode(to: encoder)
            case .PreciseDecimalType(let value):
                try value.encode(to: encoder)

            case .ComponentType(let value):
                try value.encode(to: encoder)
            case .PackageAddressType(let value):
                try value.encode(to: encoder)
            case .ComponentAddressType(let value):
                try value.encode(to: encoder)
            case .ResourceAddressType(let value):
                try value.encode(to: encoder)

            case .HashType(let value):
                try value.encode(to: encoder)

            case .BucketType(let value):
                try value.encode(to: encoder)
            case .ProofType(let value):
                try value.encode(to: encoder)
            case .VaultType(let value):
                try value.encode(to: encoder)

            case .NonFungibleIdType(let value):
                try value.encode(to: encoder)
            case .NonFungibleAddressType(let value):
                try value.encode(to: encoder)

            case .KeyValueStoreType(let value):
                try value.encode(to: encoder)

            case .EcdsaSecp256k1PublicKeyType(let value):
                try value.encode(to: encoder)
            case .EcdsaSecp256k1SignatureType(let value):
                try value.encode(to: encoder)
            case .EddsaEd25519PublicKeyType(let value):
                try value.encode(to: encoder)
            case .EddsaEd25519SignatureType(let value):
                try value.encode(to: encoder)

            case .BlobType(let value):
                try value.encode(to: encoder)
            case .ExpressionType(let value):
                try value.encode(to: encoder)
        }
    }
    
    init(from decoder: Decoder) throws {
        // Checking for type discriminator
        let values: KeyedDecodingContainer = try decoder.container(keyedBy: CodingKeys.self)
        let kind: ValueKind = try values.decode(ValueKind.self, forKey: .type)
        
        switch kind {
            
        case .Unit:
            self = Self(from: try Unit(from: decoder))
        case .Bool:
            self = Self(from: try Boolean(from: decoder))

        case .I8:
            self = Self(from: try I8(from: decoder))
        case .I16:
            self = Self(from: try I16(from: decoder))
        case .I32:
            self = Self(from: try I32(from: decoder))
        case .I64:
            self = Self(from: try I64(from: decoder))
        case .I128:
            self = Self(from: try I128(from: decoder))

        case .U8:
            self = Self(from: try U8(from: decoder))
        case .U16:
            self = Self(from: try U16(from: decoder))
        case .U32:
            self = Self(from: try U32(from: decoder))
        case .U64:
            self = Self(from: try U64(from: decoder))
        case .U128:
            self = Self(from: try U128(from: decoder))

        case .String:
            self = Self(from: try String_(from: decoder))

        case .Struct:
            self = Self(from: try Struct(from: decoder))
        case .Enum:
            self = Self(from: try Enum(from: decoder))

        case .Option:
            self = Self(from: try Option(from: decoder))
        case .Array:
            self = Self(from: try Array_(from: decoder))
        case .Tuple:
            self = Self(from: try Tuple(from: decoder))
        case .Result:
            self = Self(from: try Result(from: decoder))

        case .List:
            self = Self(from: try List(from: decoder))
        case .Set:
            self = Self(from: try Set_(from: decoder))
        case .Map:
            self = Self(from: try Map(from: decoder))

        case .Decimal:
            self = Self(from: try Decimal_(from: decoder))
        case .PreciseDecimal:
            self = Self(from: try PreciseDecimal(from: decoder))

        case .Component:
            self = Self(from: try Component(from: decoder))
        case .PackageAddress:
            self = Self(from: try PackageAddress(from: decoder))
        case .ComponentAddress:
            self = Self(from: try ComponentAddress(from: decoder))
        case .ResourceAddress:
            self = Self(from: try ResourceAddress(from: decoder))

        case .Hash:
            self = Self(from: try Hash(from: decoder))

        case .Bucket:
            self = Self(from: try Bucket(from: decoder))
        case .Proof:
            self = Self(from: try Proof(from: decoder))
        case .Vault:
            self = Self(from: try Vault(from: decoder))

        case .NonFungibleId:
            self = Self(from: try NonFungibleId(from: decoder))
        case .NonFungibleAddress:
            self = Self(from: try NonFungibleAddress(from: decoder))

        case .KeyValueStore:
            self = Self(from: try KeyValueStore(from: decoder))

        case .EcdsaSecp256k1PublicKey:
            self = Self(from: try EcdsaSecp256k1PublicKey(from: decoder))
        case .EcdsaSecp256k1Signature:
            self = Self(from: try EcdsaSecp256k1Signature(from: decoder))
        case .EddsaEd25519PublicKey:
            self = Self(from: try EddsaEd25519PublicKey(from: decoder))
        case .EddsaEd25519Signature:
            self = Self(from: try EddsaEd25519Signature(from: decoder))

        case .Blob:
            self = Self(from: try Blob(from: decoder))
        case .Expression:
            self = Self(from: try Expression(from: decoder))

        }
    }
}

enum DecodeError: Error {
    case ValueTypeDiscriminatorMismatch(ValueKind, ValueKind)
    case InstructionTypeDiscriminatorMismatch(InstructionKind, InstructionKind)
    case ParsingError
    case TypeMismatch
    case InvalidManifestInstructionsType(String)
}
