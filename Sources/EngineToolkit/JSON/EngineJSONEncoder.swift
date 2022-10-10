//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-10-10.
//

import Foundation

// non-`final` so that we can inherit from it in tests
public class EngineJSONEncoder: JSONEncoder {
    open override func encode<T>(_ value: T) throws -> Data where T : Encodable {
        if let optional = value as? Optional<Value_> {
            return try super.encode(optional.proxyEncodable)
        } else {
            return try super.encode(value)
        }
    }
}
