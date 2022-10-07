//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-10-05.
//

import Foundation

/// Default `CustomStringConvertible` implementation for all RawRepresentable (enums)
public extension CustomStringConvertible where Self: RawRepresentable, RawValue == String {
    var description: String { rawValue }
}

protocol ErrorResponseProtocol: Swift.Error, Sendable, Equatable, Decodable {
    static var errorKind: ErrorKind { get }
}
protocol EmptyErrorResponseProtocol: ErrorResponseProtocol {
    init()
}
protocol ErrorResponseWithValueProtocol: ErrorResponseProtocol {
    associatedtype Value: Decodable
    var value: Value { get }
    init (value: Value)
}
protocol ErrorResponseWithStringValueProtocol: ErrorResponseWithValueProtocol where Value == String {}
protocol ErrorResponseWithNumberValueProtocol: ErrorResponseWithValueProtocol where Value == Int {}

protocol ErrorResponseWithKindProtocol: ErrorResponseProtocol {
    var kind: ValueKind { get }
    init (kind: ValueKind)
}

public enum ErrorResponse: Swift.Error, Sendable, Equatable, Decodable {
    case addressError(AddressError)
    case unrecognizedAddressFormat(UnrecognizedAddressFormat)
    
    /// Not to be confused with `InternalDecodingFailure`
    case decodeError(DecodeError)
    case deserializationError(DeserializationError)
    case invalidRequestString(InvalidRequestString)
    case unexpectedContents(UnexpectedContents)
    case invalidType(InvalidType)
    case unknownTypeId(UnknownTypeId)
    case parseError(ParseError)
    case noManifestRepresentation(NoManifestRepresentation)
    case transactionCompileError(TransactionCompileError)
    case transactionDecompileError(TransactionDecompileError)
    case unsupportedTransactionVersion(UnsupportedTransactionVersion)
    case generatorError(GeneratorError)
    case requestResponseConversionError(RequestResponseConversionError)
    case unrecognizedCompiledIntentFormat(UnrecognizedCompiledIntentFormat)
    case transactionValidationError(TransactionValidationError)
    case extractAbiError(ExtractAbiError)
    case networkMismatchError(NetworkMismatchError)
}

public extension ErrorResponse {
    var errorKind: ErrorKind {
        switch self {
        case .addressError: return .addressError
        case .unrecognizedAddressFormat: return .unrecognizedAddressFormat
        case .decodeError: return .decodeError
        case .deserializationError: return .deserializationError
        case .invalidRequestString: return .invalidRequestString
        case .unexpectedContents: return .unexpectedContents
        case .invalidType: return .invalidType
        case .unknownTypeId: return .unknownTypeId
        case .parseError: return .parseError
        case .noManifestRepresentation: return .noManifestRepresentation
        case .transactionCompileError: return .transactionCompileError
        case .transactionDecompileError: return .transactionDecompileError
        case .unsupportedTransactionVersion: return .unsupportedTransactionVersion
        case .generatorError: return .generatorError
        case .requestResponseConversionError: return .requestResponseConversionError
        case .unrecognizedCompiledIntentFormat: return .unrecognizedCompiledIntentFormat
        case .transactionValidationError: return .transactionValidationError
        case .extractAbiError: return .extractAbiError
        case .networkMismatchError: return .networkMismatchError
        }
    }
}

public enum ErrorKind: String, Swift.Error, Sendable, Equatable, Codable, CustomStringConvertible {
    case addressError = "AddressError"
    case unrecognizedAddressFormat = "UnrecognizedAddressFormat"
    case decodeError = "InternalDecodingFailure"
    case deserializationError = "DeserializationError"
    case invalidRequestString = "InvalidRequestString"
    case unexpectedContents = "UnexpectedContents"
    case invalidType = "InvalidType"
    case unknownTypeId = "UnknownTypeId"
    case parseError = "ParseError"
    case noManifestRepresentation = "NoManifestRepresentation"
    case transactionCompileError = "TransactionCompileError"
    case transactionDecompileError = "TransactionDecompileError"
    case unsupportedTransactionVersion = "UnsupportedTransactionVersion"
    case generatorError = "GeneratorError"
    case requestResponseConversionError = "RequestResponseConversionError"
    case unrecognizedCompiledIntentFormat = "UnrecognizedCompiledIntentFormat"
    case transactionValidationError = "TransactionValidationError"
    case extractAbiError = "ExtractAbiError"
    case networkMismatchError = "NetworkMismatchError"
}


// MARK: AddressError
public struct AddressError: ErrorResponseWithStringValueProtocol {
    public static let errorKind: ErrorKind = .addressError
    public let value: String
}

// MARK: UnrecognizedAddressFormat
public struct UnrecognizedAddressFormat: EmptyErrorResponseProtocol {
    public static let errorKind: ErrorKind = .addressError
}

// MARK: DecodeError
/// Not to be confused with `InternalDecodingFailure` nor `DeserializationError`
public struct DecodeError: ErrorResponseWithStringValueProtocol {
    public static let errorKind: ErrorKind = .decodeError
    public let value: String
}

// MARK: DeserializationError
/// Not to be confused with `InternalDecodingFailure` nor `DecodeError`
public struct DeserializationError: ErrorResponseWithStringValueProtocol {
    public static let errorKind: ErrorKind = .deserializationError
    public let value: String
}

// MARK: InvalidRequestString
public struct InvalidRequestString: ErrorResponseWithStringValueProtocol {
    public static let errorKind: ErrorKind = .invalidRequestString
    public let value: String
}

// MARK: UnexpectedContents

/// An error emitted when an unexpected type is encountered when parsing the transaction manifest.
///
/// As an example, we expect that when parsing a `Bucket` we either encounter a `u32` or a `String`.
/// Instead, in this example, we encounter a `Decimal` inside of a `Bucket`
/// (something like `Bucket(Decimal("123.44"))`) then we get the following error:
///
///     UnexpectedContents {
///         kind: ValueKind.Bucket, // We were parsing a bucket
///         expected: vec![
///             ValueKind.U32,
///             ValueKind.String
///         ], // We expect a bucket to contain either a u32 or String
///         found: ValueKind.Decimal // We found a Decimal in the bucket
///     }
///
public struct UnexpectedContents: ErrorResponseProtocol {
    public static let errorKind: ErrorKind = .unexpectedContents
    
    /// The kind that was parsed, e.g. a `Bucket`, which we expect to contain either a `u32` or a `String`,
    /// which is the `expectedKind` property
    public let kind: ValueKind
    
    /// We expect to find any of these types, but found `foundKind`.
    public let expectedKind: [ValueKind]
    
    /// The unexpected type we found, instead of any of the `expectedKind`, when parsing the `kind`.
    public let foundKind: ValueKind
}

// MARK: InvalidType
public struct InvalidType: ErrorResponseProtocol {
    public static let errorKind: ErrorKind = .invalidType
    // FIXME: rename `expectedKind` ? see: https://rdxworks.slack.com/archives/C040KJQN5CL/p1665044252605759
    public let expectedType: ValueKind
    // FIXME: rename `actual` ? see: https://rdxworks.slack.com/archives/C040KJQN5CL/p1665044252605759
    public let actualType: ValueKind
}

// MARK: UnknownTypeId
public struct UnknownTypeId: ErrorResponseProtocol {
    public static let errorKind: ErrorKind = .unknownTypeId
    public let typeId: Int
}

// MARK: ParseError
public struct ParseError: ErrorResponseProtocol {
    public static let errorKind: ErrorKind = .parseError
    public let kind: ValueKind
    public let message: String
}

// MARK: NoManifestRepresentation
public struct NoManifestRepresentation: ErrorResponseWithKindProtocol {
    public static let errorKind: ErrorKind = .noManifestRepresentation
    public let kind: ValueKind
}

// MARK: TransactionCompileError
public struct TransactionCompileError: ErrorResponseWithStringValueProtocol {
    public static let errorKind: ErrorKind = .transactionCompileError
    public let value: String
}

// MARK: TransactionDecompileError
public struct TransactionDecompileError: ErrorResponseWithStringValueProtocol {
    public static let errorKind: ErrorKind = .transactionDecompileError
    public let value: String
}

// MARK: UnsupportedTransactionVersion
public struct UnsupportedTransactionVersion: ErrorResponseWithNumberValueProtocol {
    public static let errorKind: ErrorKind = .unsupportedTransactionVersion
    public let value: Int
}

// MARK: GeneratorError
public struct GeneratorError: ErrorResponseWithStringValueProtocol {
    public static let errorKind: ErrorKind = .generatorError
    public let value: String
}

// MARK: RequestResponseConversionError
public struct RequestResponseConversionError: ErrorResponseWithStringValueProtocol {
    public static let errorKind: ErrorKind = .requestResponseConversionError
    public let value: String
}

// MARK: UnrecognizedCompiledIntentFormat
public struct UnrecognizedCompiledIntentFormat: EmptyErrorResponseProtocol {
    public static let errorKind: ErrorKind = .unrecognizedCompiledIntentFormat
}

// MARK: TransactionValidationError
public struct TransactionValidationError: ErrorResponseWithStringValueProtocol {
    public static let errorKind: ErrorKind = .transactionValidationError
    public let value: String
}

// MARK: ExtractAbiError
public struct ExtractAbiError: ErrorResponseWithStringValueProtocol {
    public static let errorKind: ErrorKind = .extractAbiError
    public let value: String
}

// MARK: NetworkMismatchError
public struct NetworkMismatchError: ErrorResponseProtocol {
    public static let errorKind: ErrorKind = .networkMismatchError
    public let expected: NetworkID
    public let found: NetworkID
}

private enum ErrorResponseCodingKeys: String, CodingKey {
    case errorKind = "error"
    case value
    
    case expected = "expected"
    case found = "found"
    
    case expectedType = "expected_type"
    case actualType = "actual_type"
    
    case typeId = "type_id"

    case kind
    case message
    
}

extension ErrorResponseProtocol {
    fileprivate static func containerAssertingErrorKind(
        from decoder: Decoder
    ) throws -> KeyedDecodingContainer<ErrorResponseCodingKeys> {
        let container = try decoder.container(keyedBy: ErrorResponseCodingKeys.self)
        let errorKind = try container.decode(ErrorKind.self, forKey: .errorKind)
        guard errorKind == Self.errorKind else {
            throw InternalDecodingFailure.errorKindMismatch(expected: Self.errorKind, butGot: errorKind)
        }
        return container
    }
    
    fileprivate static func containerAndValueKindAssertingErrorKind(
        from decoder: Decoder
    ) throws -> (container: KeyedDecodingContainer<ErrorResponseCodingKeys>, valueKind: ValueKind) {
        let container = try Self.containerAssertingErrorKind(from: decoder)
        let valueKind = try container.decode(ValueKind.self, forKey: .kind)
        return (container, valueKind)
    }
}

extension ErrorResponseWithKindProtocol {
    public init(from decoder: Decoder) throws {
        let (_, kind) = try Self.containerAndValueKindAssertingErrorKind(from: decoder)
       self.init(kind: kind)
   }
}

extension ErrorResponseWithValueProtocol {
    
     public init(from decoder: Decoder) throws {
        let container = try Self.containerAssertingErrorKind(from: decoder)
        let value = try container.decode(Value.self, forKey: .value)
        self.init(value: value)
    }
}

extension EmptyErrorResponseProtocol {
    
    public init(from decoder: Decoder) throws {
        // Nothing more to decode
        _ = try Self.containerAssertingErrorKind(from: decoder)
        self.init()
    }
}

// MARK: UnexpectedContents + Decodable
public extension UnexpectedContents {
    init(from decoder: Decoder) throws {
        // FIXME: how does this `kind` relate to `expectedKind`? Should one be removed?
        let (container, kind) = try Self.containerAndValueKindAssertingErrorKind(from: decoder)
        let foundKind = try container.decode(ValueKind.self, forKey: .found)
        
        // FIXME: how does this `expectedKind` relate to `kind`? Should one be removed?
        let expectedKind = try container.decode([ValueKind].self, forKey: .expected)
        
        self.init(kind: kind, expectedKind: expectedKind, foundKind: foundKind)
    }
}

// MARK: InvalidType + Decodable
public extension InvalidType {
    init(from decoder: Decoder) throws {
        let container = try Self.containerAssertingErrorKind(from: decoder)
        
        // FIXME: rename to `actual`? see: https://rdxworks.slack.com/archives/C040KJQN5CL/p1665044252605759
        let actualType = try container.decode(ValueKind.self, forKey: .actualType)
        // FIXME: rename to `expected`? see: https://rdxworks.slack.com/archives/C040KJQN5CL/p1665044252605759
        let expectedType = try container.decode(ValueKind.self, forKey: .expected)
        
        self.init(expectedType: expectedType, actualType: actualType)
    }
}

// MARK: UnknownTypeId + Decodable
public extension UnknownTypeId {
    init(from decoder: Decoder) throws {
        let container = try Self.containerAssertingErrorKind(from: decoder)
        let typeId = try container.decode(Int.self, forKey: .typeId)
        self.init(typeId: typeId)
    }
}

// MARK: ParseError + Decodable
public extension ParseError {
    init(from decoder: Decoder) throws {
        let (container, kind) = try Self.containerAndValueKindAssertingErrorKind(from: decoder)
        let message = try container.decode(String.self, forKey: .message)
        self.init(kind: kind, message: message)
    }
}

// MARK: NetworkMismatchError + Decodable
public extension NetworkMismatchError {
    init(from decoder: Decoder) throws {
        let container = try Self.containerAssertingErrorKind(from: decoder)
        let expectedNetworkID = try container.decode(NetworkID.self, forKey: .expected)
        let foundNetworkID = try container.decode(NetworkID.self, forKey: .found)
        self.init(expected: expectedNetworkID, found: foundNetworkID)
    }
}
