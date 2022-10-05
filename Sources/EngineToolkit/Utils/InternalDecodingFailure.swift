//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-10-05.
//

import Foundation

/// Not to be confused with `DecodeError` case of `ErrorResponse` enum.
public enum InternalDecodingFailure: Swift.Error, Sendable, Equatable, Codable {
    case valueTypeDiscriminatorMismatch(expectedAnyOf: [ValueKind], butGot: ValueKind)
    case instructionTypeDiscriminatorMismatch(expected: InstructionKind, butGot: InstructionKind)
    case parsingError
}

extension InternalDecodingFailure {
    static func valueTypeDiscriminatorMismatch(expected: ValueKind, butGot: ValueKind) -> Self {
        .valueTypeDiscriminatorMismatch(expectedAnyOf: [expected], butGot: butGot)
    }
}
