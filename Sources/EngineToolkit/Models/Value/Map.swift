import Foundation

// TODO: Replace with `Swift.Dictionary`? As we did with `Result_` -> `Swift.Result` ( https://github.com/radixdlt/swift-engine-toolkit/pull/6/commits/decc7ebd325eb72fd8f376d1001f7ded7f2dd202 )
public struct Map: ValueProtocol, Sendable, Codable, Hashable, ExpressibleByDictionaryLiteral {
    // Type name, used as a discriminator
    public static let kind: ValueKind = .map
    public func embedValue() -> Value_ {
        .map(self)
    }
    
    // ===============
    // Struct members
    // ===============
    
    public let keyType: ValueKind
    public let valueType: ValueKind
    public let keyValuePairs: [KeyValuePair]

    // =============
    // Constructors
    // =============
    
    public init(keyType: ValueKind, valueType: ValueKind) {
        self.keyType = keyType
        self.valueType = valueType
        self.keyValuePairs = []
    }
    
    public init(keyType: ValueKind, valueType: ValueKind, keyValuePairsInterleaved: [Value_]) throws {
        
        guard keyValuePairsInterleaved.count.isMultiple(of: 2) else {
            throw Error.requiredEvenNumberOfValues
        }
        let keys: [Value_] = try keyValuePairsInterleaved.enumerated().compactMap { offset, value in
            guard offset.isMultiple(of: 2) else { return nil }
            guard value.kind() == keyType else {
                throw Error.unexpectedKeyTypeInKeyValuePairs
            }
            return value
        }
        let values: [Value_] = try keyValuePairsInterleaved.enumerated().compactMap { offset, value in
            guard !offset.isMultiple(of: 2) else { return nil }
            guard value.kind() == valueType else {
                throw Error.unexpectedValueTypeInKeyValuePairs
            }
            return value
        }
        
        self.keyType = keyType
        self.valueType = valueType
        let keyValuePairs = zip(keys, values).map { KeyValuePair(key: $0, value: $1) }
        
        // Divide by 2 since we go from `[key, value] -> [(key, value)]`
        guard keyValuePairs.count == (keyValuePairsInterleaved.count / 2) else {
            throw Error.nonKeyNorValueTypeFound
        }
        self.keyValuePairs = keyValuePairs
    }
    
    public init(
        keyType: ValueKind,
        valueType: ValueKind,
        @ValuesBuilder buildKeyValuePairsInterleaved: () throws -> [ValueProtocol]
    ) throws {
        try self.init(
            keyType: keyType,
            valueType: valueType,
            keyValuePairsInterleaved: buildKeyValuePairsInterleaved().map { $0.embedValue() }
        )
    }
    public init(
        keyType: ValueKind,
        valueType: ValueKind,
        @ValuesBuilder buildKeyValuePairsInterleaved: () throws -> [Value_]
    ) throws {
        try self.init(
            keyType: keyType,
            valueType: valueType,
            keyValuePairsInterleaved: buildKeyValuePairsInterleaved()
        )
    }
}

// MARK: ExpressibleByDictionaryLiteral
public extension Map {
    
    /// ExpressibleByDictionaryLiteral enables us to initialize this
    /// type like this:
    ///
    ///     [
    ///         String_("key0"): U8(0),
    ///         String_("key1"): U8(2)
    ///     ]
    ///
    /// instead of this:
    ///
    ///     try Map(
    ///         keyType: .string,
    ///         valueType: .u8
    ///     ) {
    ///         String_("key0")
    ///         U8(0)
    ///         String_("key1")
    ///         U8(2)
    ///     }
    ///
    init(dictionaryLiteral elements: (ValueProtocol, ValueProtocol)...) {
        precondition(!elements.isEmpty)
        self.keyType = elements.first!.0.kind
        self.valueType = elements.first!.1.kind
        self.keyValuePairs = elements.map { KeyValuePair(key: $0.0.embedValue(), value: $0.1.embedValue()) }
    }
}

public extension Map {
    
    struct KeyValuePair: Sendable, Hashable {
        public let key: Value_
        public let value: Value_
        public init(key: Value_, value: Value_) {
            self.key = key
            self.value = value
        }
    }
    
    enum Error: String, Swift.Error, Sendable, Hashable {
        case requiredEvenNumberOfValues
        case unexpectedKeyTypeInKeyValuePairs
        case unexpectedValueTypeInKeyValuePairs
        case nonKeyNorValueTypeFound
    }
    
    
    /// Returnes a mapping of the key value pairs:
    /// `[(key: Value, value: Value)] -> [key0, value0, key1, value1, ..., keyN, valueN]`
    var keyValuePairsInterleaved: [Value_] {
        keyValuePairs.flatMap { [$0.key, $0.value] }
    }
    
}

public extension Map {
    
    // =======================
    // Coding Keys Definition
    // =======================
    private enum CodingKeys: String, CodingKey {
        case keyValuePairsInterleaved = "elements", keyType = "key_type", valueType = "value_type", type
    }
    
    // ======================
    // Encoding and Decoding
    // ======================
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(Self.kind, forKey: .type)
        
        try container.encode(keyValuePairsInterleaved, forKey: .keyValuePairsInterleaved)
        try container.encode(keyType, forKey: .keyType)
        try container.encode(valueType, forKey: .valueType)
    }
    
    init(from decoder: Decoder) throws {
        // Checking for type discriminator
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let kind: ValueKind = try container.decode(ValueKind.self, forKey: .type)
        if kind != Self.kind {
            throw InternalDecodingFailure.valueTypeDiscriminatorMismatch(expected: Self.kind, butGot: kind)
        }
   
        try self.init(
            keyType: container.decode(ValueKind.self, forKey: .keyType),
            valueType: container.decode(ValueKind.self, forKey: .valueType),
            keyValuePairsInterleaved: container.decode([Value_].self, forKey: .keyValuePairsInterleaved)
        )
    }
}
