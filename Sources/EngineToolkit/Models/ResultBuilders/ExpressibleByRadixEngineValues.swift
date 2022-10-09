//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-10-09.
//

import Foundation

public protocol ExpressibleByRadixEngineValues: ExpressibleByArrayLiteral {
    init(values: [Value])
}
public extension ExpressibleByRadixEngineValues {
    
    init(_ values: [any ValueProtocol]) {
        self.init(values: values.map { $0.embedValue() })
    }
    
    init(arrayLiteral elements: Value...) {
        self.init(values: elements)
    }
}

@resultBuilder
struct ValuesBuilder {
    static func buildBlock(_ values: any ValueProtocol...) -> [any ValueProtocol] {
        values
    }
    static func buildBlock(_ value: any ValueProtocol) -> [any ValueProtocol] {
        [value]
    }
    static func buildBlock(_ value: any ValueProtocol) -> any ValueProtocol {
        value
    }
}

@resultBuilder
struct SpecificValuesBuilder {
    static func buildBlock(_ values: Value...) -> [Value] {
        values
    }
    static func buildBlock(_ value: Value) -> [Value] {
        [value]
    }
    static func buildBlock(_ value: Value) -> Value {
        value
    }
}

public extension ExpressibleByRadixEngineValues {
    init(@ValuesBuilder buildValues: () throws -> [any ValueProtocol]) rethrows {
        self.init(try buildValues())
    }
    
    init(@SpecificValuesBuilder buildValues: () throws -> [Value]) rethrows {
        self.init(values: try buildValues())
    }
}

