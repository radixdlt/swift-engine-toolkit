//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-10-10.
//

import Foundation

// non-`final` so that we can inherit from it in tests
public class EngineJSONDecoder: JSONDecoder {
    open override func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable {
        if type is Optional<Value_>.Type {
            let decoded = try self.decode(Optional<Value_>.ProxyDecodable.self, from: data)
            return decoded as! T
        } else {
            return try super.decode(type, from: data)
        }
    }
}
