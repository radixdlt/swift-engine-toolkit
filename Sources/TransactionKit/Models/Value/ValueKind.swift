import Foundation

public enum ValueKind: String, Codable, Sendable, Hashable {
    case Unit = "Unit"
    case Bool = "Bool"

    case I8 = "I8"
    case I16 = "I16"
    case I32 = "I32"
    case I64 = "I64"
    case I128 = "I128"

    case U8 = "U8"
    case U16 = "U16"
    case U32 = "U32"
    case U64 = "U64"
    case U128 = "U128"

    case String = "String"

    case Struct = "Struct"
    case Enum = "Enum"

    case Option = "Option"
    case Array = "Array"
    case Tuple = "Tuple"
    case Result = "Result"

    case List = "List"
    case Set = "Set"
    case Map = "Map"

    case Decimal = "Decimal"
    case PreciseDecimal = "PreciseDecimal"

    case Component = "Component"
    case PackageAddress = "PackageAddress"
    case ComponentAddress = "ComponentAddress"
    case ResourceAddress = "ResourceAddress"

    case Hash = "Hash"

    case Bucket = "Bucket"
    case Proof = "Proof"
    case Vault = "Vault"

    case NonFungibleId = "NonFungibleId"
    case NonFungibleAddress = "NonFungibleAddress"

    case KeyValueStore = "KeyValueStore"

    case EcdsaSecp256k1PublicKey = "EcdsaSecp256k1PublicKey"
    case EcdsaSecp256k1Signature = "EcdsaSecp256k1Signature"
    case EddsaEd25519PublicKey = "EddsaEd25519PublicKey"
    case EddsaEd25519Signature = "EddsaEd25519Signature"

    case Blob = "Blob"
    case Expression = "Expression"
}
