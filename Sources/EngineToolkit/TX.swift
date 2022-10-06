import Foundation
import libTX

/// A `TX` type provides a high level functions and method for the
/// interaction with the transaction library and abstracting away
/// the low level memory allocation, serialization, and other low level concepts.
public struct TX {
    internal static var _debugPrint = false
	
	private let jsonEncoder: JSONEncoder
	private let jsonDecoder: JSONDecoder
	
	public init(
		jsonEncoder: JSONEncoder = .init(),
		jsonDecoder: JSONDecoder = .init()
	) {
		self.jsonEncoder = jsonEncoder
		self.jsonDecoder = jsonDecoder
	}
}

// MARK: Public
public extension TX {
    
    /// Obtains information on the current transaction library used.
    ///
    /// This function is used to get information on the transaction library such as the package version. You may
    /// think of this information request as the "Hello World" example of the transaction library where, this is
    /// typically the first request type to be implemented in any implementation of the transaction library, if this
    /// request works then you can be assured that all of the other lower level operations work as well.
    func information() throws -> InformationResponse {
        try callLibraryFunction(
            input: InformationRequest(),
            function: libTX.information
        )
    }
    
    func convertManifest(
		request: ConvertManifestRequest
	) throws -> ConvertManifestResponse {
        try callLibraryFunction(
            input: request,
            function: libTX.convert_manifest
        )
    }

    func compileTransactionIntentRequest(
		request: CompileTransactionIntentRequest
	) throws -> CompileTransactionIntentResponse {
        try callLibraryFunction(
            input: request,
            function: libTX.compile_transaction_intent
        )
    }

    func decompileTransactionIntentRequest(
		request: DecompileTransactionIntentRequest
	) throws -> DecompileTransactionIntentResponse {
        try callLibraryFunction(
            input: request,
            function: libTX.decompile_transaction_intent
        )
    }

    func compileSignedTransactionIntentRequest(
		request: CompileSignedTransactionIntentRequest
	) throws -> CompileSignedTransactionIntentResponse {
        try callLibraryFunction(
            input: request,
            function: libTX.compile_signed_transaction_intent
        )
    }

    func decompileSignedTransactionIntentRequest(
		request: DecompileSignedTransactionIntentRequest
	) throws -> DecompileSignedTransactionIntentResponse {
        try callLibraryFunction(
            input: request,
            function: libTX.decompile_signed_transaction_intent
        )
    }

    func compileNotarizedTransactionIntentRequest(
		request: CompileNotarizedTransactionIntentRequest
	) throws -> CompileNotarizedTransactionIntentResponse {
        try callLibraryFunction(
            input: request,
            function: libTX.compile_notarized_transaction_intent
        )
    }

    func decompileNotarizedTransactionIntentRequest(
		request: DecompileNotarizedTransactionIntentRequest
	) throws -> DecompileNotarizedTransactionIntentResponse {
        try callLibraryFunction(
            input: request,
            function: libTX.decompile_notarized_transaction_intent
        )
    }

    func decompileUnknownTransactionIntentRequest(
		request: DecompileUnknownTransactionIntentRequest
	) throws -> DecompileUnknownTransactionIntentResponse {
        try callLibraryFunction(
            input: request,
            function: libTX.decompile_unknown_transaction_intent
        )
    }

    func decodeAddressRequest(
		request: DecodeAddressRequest
	) throws -> DecodeAddressResponse {
        try callLibraryFunction(
            input: request,
            function: libTX.decode_address
        )
    }

    func encodeAddressRequest(
		request: EncodeAddressRequest
	) throws -> EncodeAddressResponse {
        try callLibraryFunction(
            input: request,
            function: libTX.encode_address
        )
    }

    func sborDecodeRequest(
		request: SborDecodeRequest
	) throws -> SborDecodeResponse {
        try callLibraryFunction(
            input: request,
            function: libTX.sbor_decode
        )
    }

    func sborEncodeRequest(
		request: SborEncodeRequest
	) throws -> SborEncodeResponse {
        try callLibraryFunction(
            input: request,
            function: libTX.sbor_encode
        )
    }

    func extractAbiRequest(
		request: ExtractAbiRequest
	) throws -> ExtractAbiResponse {
        try callLibraryFunction(
            input: request,
            function: libTX.extract_abi
        )
    }

    func deriveNonFungibleAddressFromPublicKeyRequest(
		request: DeriveNonFungibleAddressFromPublicKeyRequest
	) throws -> DeriveNonFungibleAddressFromPublicKeyResponse {
        try callLibraryFunction(
            input: request,
            function: libTX.derive_non_fungible_address_from_public_key
        )
    }

    func deriveNonFungibleAddressRequest(
		request: DeriveNonFungibleAddressRequest
	) throws -> DeriveNonFungibleAddressResponse {
        try callLibraryFunction(
            input: request,
            function: libTX.derive_non_fungible_address
        )
    }
}

// MARK: Error
internal extension TX {
	enum Error: String, Swift.Error, Equatable {
		case noOutputFromLibraryCall
		case failedToUTF8DecodeJSONStringFromData
		case failedToUTF8EncodeJSONString
		case failedToCStringUTF8Encode
	}
}

// MARK: Private
private extension TX {
    /// Calls the transaction library with a given input and returns the output back.
    ///
    /// This function abstracts away how the transaction library is called and provides a high level interface for
    /// communicating and getting responses back from the library.
    func callLibraryFunction<I: Encodable, O: Decodable>(
        input: I,
        function: (UnsafePointer<CChar>?) -> UnsafePointer<CChar>?
    ) throws -> O {
        // Serialize the given request to a JSON string.
        let requestString = try serialize(object: input)
        
        #if DEBUG
        prettyPrintRequest(jsonString: requestString)
        #endif
        
        // Allocate enough memory for the request string and then write it to
        // that memory location
        let allocatedMemory = try allocateMemory(string: requestString)
        writeStringToMemory(string: requestString, pointer: allocatedMemory)
        
        // Calling the underlying transaction library function and getting a pointer
        // response. We cannot deallocated the `responsePointer`, it results in a crash.
		guard let responsePointer = function(allocatedMemory) else {
			throw Error.noOutputFromLibraryCall
		}
        
		let responseString = readStringFromMemory(pointer: responsePointer)
		
        
        // Deallocating the request and response memory
        deallocateMemory(pointer: allocatedMemory)
       
        #if DEBUG
        prettyPrintResponse(jsonString: responseString)
        #endif
        
        return try deserialize(jsonString: responseString)
    }
    
    /// Serializes an object to a JSON string.
    ///
    /// This private function takes an object and serializes it to a JSON string. In the current implementation, this
    /// object needs to be `Encodable`, therefore, this function abstracts the serialization logic away from the
    /// transaction library operations and into an individual function.
    func serialize<T: Encodable>(object: T) throws -> String {
        let jsonData = try jsonEncoder.encode(object)
		guard let jsonString = String(data: jsonData, encoding: .utf8) else {
			throw Error.failedToUTF8DecodeJSONStringFromData
		}
        return jsonString
    }
    
    /// Deserializes a JSON string to a generic `T`.
    ///
    /// This function deserializes a JSON string to a generic `T` which is defined by the of this function. It is
    /// assumed that the deserialization does not fail since the payload is a trusted payload.
    ///
    /// TODO: In the future, it would be better to have this a `Result<T, Error>` since there is a chance
    /// that this could be an error type as well and not an Ok response.
    func deserialize<T: Decodable>(jsonString: String) throws -> T {
		guard let jsonData = jsonString.data(using: .utf8) else {
			throw Error.failedToUTF8EncodeJSONString
		}
		return try jsonDecoder.decode(T.self, from: jsonData)
    }
    
    /// Allocates as memory as the C-String representation of the provided String requires.
    ///
    /// **Note: **
    ///
    /// It is important to only use one memory allocator with the transaction library, you may opt to use the swift
    /// memory allocator and pass pointers to memory allocated by swift, or alternativly you may choose to use the
    /// memory allocator used in the transaction library. However, it is not recommended to use both at the same
    /// time as it can lead to heap corruption and other undefined behavior.
    func allocateMemory(string: String) throws -> UnsafeMutablePointer<CChar> {
        // Get the byte count of the C-String representation of the utf-8 encoded
        // string.
		guard let cString = string.cString(using: .utf8) else {
			throw Error.failedToCStringUTF8Encode
		}
        let byteCount: Int = cString.count
        return UnsafeMutablePointer<CChar>.allocate(capacity: byteCount)
    }
    
    /// Deallocates memory
    ///
    /// This function deallocates memory which was previously allocated by the transaction library memory allocator.
    /// There are no returns from this function since it is assumed that the memory deallocation will always succeed.
    func deallocateMemory(pointer: UnsafeMutablePointer<CChar>) {
        pointer.deallocate()
    }
    
    /// Writes the string to the memory location provided.
    ///
    /// This function writes the C-String representation of the passed string to the provided pointer. Since this is a C-String
    /// representation, this means that an additional byte is added at the end with the null terminator.
    func writeStringToMemory(
        string: String,
        pointer: UnsafeMutablePointer<CChar>
    ) {
        // Converting the string to an array of UTF-8 bytes
        let stringBytes: [CChar] = Array(string.utf8CString)
        
        // Iterating over the array and writing all of the bytes to memory
        for (index, value) in stringBytes.enumerated() {
            pointer.advanced(by: index).pointee = value
        }
    }
    
    /// Reads a string from the provided memory location.
    ///
    /// This function reads a C-String, null terminated, string from the provided memory location and returns it.
    func readStringFromMemory(
        pointer: UnsafePointer<CChar>
    ) -> String {
        String(cString: pointer)
    }
}

#if DEBUG

func prettyPrintRequest(jsonString: String) {
    prettyPrint(jsonString: jsonString, label: "\n📦⬆️ Request JSON string")
}
func prettyPrintResponse(jsonString: String) {
    prettyPrint(jsonString: jsonString, label: "\n📦⬇️ Response JSON string (prettified before JSON decoding)")
}

/// Tries to pretty prints JSON string even before Decodable JSON decoding takes place
/// using old Cocoa APIs
func prettyPrint(jsonString: String, label: String?) {
    guard
        TX._debugPrint,
        let data = jsonString.data(using: .utf8),
        let pretty = data.prettyPrintedJSONString
    else {
        return
    }
    if let label {
        debugPrint(label)
    }
    debugPrint(pretty)
}

// https://gist.github.com/cprovatas/5c9f51813bc784ef1d7fcbfb89de74fe
extension Data {
    /// NSString gives us a nice sanitized debugDescription
    var prettyPrintedJSONString: NSString? {
        
        guard
            let object = try? JSONSerialization.jsonObject(with: self, options: []),
            let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
            let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
        else { return nil }

        return prettyPrintedString
    }
}
#endif
