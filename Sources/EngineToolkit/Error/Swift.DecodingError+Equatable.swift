//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-10-07.
//

import Foundation

/// Make Swift.DecodingError `Equatable` so that we can use it in `DeserializeResponseFailure` and still
/// let `DeserializeResponseFailure` be `Equatable`.
extension Swift.DecodingError: Equatable {
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        
        switch (lhs, rhs) {
            /// An indication that a value of the given type could not be decoded because
            /// it did not match the type of what was found in the encoded payload.
            /// As associated values, this case contains the attempted type and context
        /// for debugging.
        case (
            .typeMismatch(let lhsType, let lhsContext),
            .typeMismatch(let rhsType, let rhsContext)):
            return lhsType == rhsType && lhsContext == rhsContext
            
            /// An indication that a non-optional value of the given type was expected,
            /// but a null value was found.
            /// As associated values, this case contains the attempted type and context
        /// for debugging.
        case (
            .valueNotFound(let lhsType, let lhsContext),
            .valueNotFound(let rhsType, let rhsContext)):
            return lhsType == rhsType && lhsContext == rhsContext
            
            /// An indication that a keyed decoding container was asked for an entry for
            /// the given key, but did not contain one.
            /// As associated values, this case contains the attempted key and context
        /// for debugging.
        case (
            .keyNotFound(let lhsKey, _),
            .keyNotFound(let rhsKey, _)):
            return lhsKey.stringValue == rhsKey.stringValue
            
            /// An indication that the data is corrupted or otherwise invalid.
        /// As an associated value, this case contains the context for debugging.
        case (
            .dataCorrupted(let lhsContext),
            .dataCorrupted(let rhsContext)):
            return lhsContext == rhsContext
            
        default: return false
        }
    }
}

extension Swift.DecodingError.Context: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.debugDescription == rhs.debugDescription
    }
}