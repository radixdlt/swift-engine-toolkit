//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-10-05.
//

import Foundation

public struct NetworkID: Sendable, Codable, Hashable, CustomStringConvertible, ExpressibleByIntegerLiteral {
	public typealias ID = UInt8
	public typealias IntegerLiteralType = ID
	public var description: String { String(describing: id) }
	public let id: ID
	public init(_ id: ID) {
		self.id = id
	}
	public init(integerLiteral id: IntegerLiteralType) {
		self.init(id)
	}
}
public extension NetworkID {
	func encode(to encoder: Encoder) throws {
		var container = encoder.singleValueContainer()
		try container.encode(self.id)
	}
	init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		self.id = try container.decode(NetworkID.ID.self)
	}
}

public extension NetworkID {
	
	/// https://github.com/radixdlt/radixdlt-scrypto/blob/f4c41985ad9d1570fff7293fa90b77a896b3be2b/scrypto/src/core/network.rs#L43
	static let mainnet: Self = 1
	
	/// https://github.com/radixdlt/radixdlt-scrypto/blob/f4c41985ad9d1570fff7293fa90b77a896b3be2b/scrypto/src/core/network.rs#L19
	static let simulator: Self = 242
	
	/// https://github.com/radixdlt/radixdlt-scrypto/blob/f4c41985ad9d1570fff7293fa90b77a896b3be2b/scrypto/src/core/network.rs#L27
	static let adapanet: Self = 0x0a
	
	/// https://github.com/radixdlt/radixdlt-scrypto/blob/f4c41985ad9d1570fff7293fa90b77a896b3be2b/scrypto/src/core/network.rs#L35
	static let nebunet: Self = 0x0b
	
}
