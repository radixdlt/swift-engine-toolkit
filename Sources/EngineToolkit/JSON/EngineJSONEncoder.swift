//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-10-10.
//

import Foundation

// non-`final` so that we can inherit from it in tests
public class EngineJSONEncoder: JSONEncoder {
    open override func encode<T>(_ encodableValue: T) throws -> Data where T: Encodable {
//        guard let value = encodableValue as? Value_ else {
//            return try super.encode(encodableValue)
//        }
//
//        switch value {
//        case let .option(proxyBase):
//            return try super.encode(proxyBase.proxyEncodable)
//        case let .boolean(proxyBase):
//            return try super.encode(proxyBase.proxyEncodable)
//        default:
//            return try super.encode(value)
//        }
                    return try super.encode(encodableValue)
    }
}
