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

public protocol ErrorResponseProtocol: Swift.Error, Sendable, Equatable, Codable {
    static var type: ErrorResponseType { get }
}
public protocol ErrorResponseWithValueProtocol: ErrorResponseProtocol {}

public enum ErrorResponse: Swift.Error, Sendable, Equatable, Codable {
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
    var type: ErrorResponseType {
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

public enum ErrorResponseType: String, Swift.Error, Sendable, Equatable, Codable, CustomStringConvertible {
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


public struct AddressError: ErrorResponseProtocol {
    public static let type: ErrorResponseType = .addressError
}
public struct UnrecognizedAddressFormat: ErrorResponseProtocol {
    public static let type: ErrorResponseType = .addressError
}

/// Not to be confused with `InternalDecodingFailure`
public struct DecodeError: ErrorResponseProtocol {
    public static let type: ErrorResponseType = .decodeError
}
public struct DeserializationError: ErrorResponseProtocol {
    public static let type: ErrorResponseType = .deserializationError
}
public struct InvalidRequestString: ErrorResponseProtocol {
    public static let type: ErrorResponseType = .invalidRequestString
}
public struct UnexpectedContents: ErrorResponseProtocol {
    public static let type: ErrorResponseType = .unexpectedContents
}
public struct InvalidType: ErrorResponseProtocol {
    public static let type: ErrorResponseType = .invalidType
}
public struct UnknownTypeId: ErrorResponseProtocol {
    public static let type: ErrorResponseType = .unknownTypeId
}
public struct ParseError: ErrorResponseProtocol {
    public static let type: ErrorResponseType = .parseError
}
public struct NoManifestRepresentation: ErrorResponseProtocol {
    public static let type: ErrorResponseType = .noManifestRepresentation
}
public struct TransactionCompileError: ErrorResponseProtocol {
    public static let type: ErrorResponseType = .transactionCompileError
}
public struct TransactionDecompileError: ErrorResponseProtocol {
    public static let type: ErrorResponseType = .transactionDecompileError
}
public struct UnsupportedTransactionVersion: ErrorResponseProtocol {
    public static let type: ErrorResponseType = .unsupportedTransactionVersion
}
public struct GeneratorError: ErrorResponseProtocol {
    public static let type: ErrorResponseType = .generatorError
}
public struct RequestResponseConversionError: ErrorResponseProtocol {
    public static let type: ErrorResponseType = .requestResponseConversionError
}
public struct UnrecognizedCompiledIntentFormat: ErrorResponseProtocol {
    public static let type: ErrorResponseType = .unrecognizedCompiledIntentFormat
}
public struct TransactionValidationError: ErrorResponseProtocol {
    public static let type: ErrorResponseType = .transactionValidationError
}
public struct ExtractAbiError: ErrorResponseProtocol {
    public static let type: ErrorResponseType = .extractAbiError
}
public struct NetworkMismatchError: ErrorResponseProtocol {
    public static let type: ErrorResponseType = .networkMismatchError
}
