import Foundation
import libTX

/// A namespace `TX` providing a high level functions and method for the
/// interaction with the transaction library and abstracting away the low level memory allocation, serialization, and
/// other low level concepts.
public enum TX {}
public extension TX {
    
    /// Obtains information on the current transaction library used.
    ///
    /// This function is used to get information on the transaction library such as the package version. You may
    /// think of this information request as the "Hello World" example of the transaction library where, this is
    /// typically the first request type to be implemented in any implementation of the transaction library, if this
    /// request works then you can be assured that all of the other lower level operations work as well.
    static func information() throws -> InformationResponse {
        try callLibraryFunction(
            input: InformationRequest(),
            function: libTX.information
        )
    }
    
    static func convertManifest(request: ConvertManifestRequest) throws -> ConvertManifestResponse {
        try callLibraryFunction(
            input: request,
            function: libTX.convert_manifest
        )
    }

    static func compileTransactionIntentRequest(request: CompileTransactionIntentRequest) throws -> CompileTransactionIntentResponse {
        try callLibraryFunction(
            input: request,
            function: libTX.compile_transaction_intent
        )
    }

    static func decompileTransactionIntentRequest(request: DecompileTransactionIntentRequest) throws -> DecompileTransactionIntentResponse {
        try callLibraryFunction(
            input: request,
            function: libTX.decompile_transaction_intent
        )
    }

    static func compileSignedTransactionIntentRequest(request: CompileSignedTransactionIntentRequest) throws -> CompileSignedTransactionIntentResponse {
        try callLibraryFunction(
            input: request,
            function: libTX.compile_signed_transaction_intent
        )
    }

    static func decompileSignedTransactionIntentRequest(request: DecompileSignedTransactionIntentRequest) throws -> DecompileSignedTransactionIntentResponse {
        try callLibraryFunction(
            input: request,
            function: libTX.decompile_signed_transaction_intent
        )
    }

    static func compileNotarizedTransactionIntentRequest(request: CompileNotarizedTransactionIntentRequest) throws -> CompileNotarizedTransactionIntentResponse {
        try callLibraryFunction(
            input: request,
            function: libTX.compile_notarized_transaction_intent
        )
    }

    static func decompileNotarizedTransactionIntentRequest(request: DecompileNotarizedTransactionIntentRequest) throws -> DecompileNotarizedTransactionIntentResponse {
        try callLibraryFunction(
            input: request,
            function: libTX.decompile_notarized_transaction_intent
        )
    }

    static func decompileUnknownTransactionIntentRequest(
		request: DecompileUnknownTransactionIntentRequest
	) throws -> DecompileUnknownTransactionIntentResponse {
        try callLibraryFunction(
            input: request,
            function: libTX.decompile_unknown_transaction_intent
        )
    }

    static func decodeAddressRequest(request: DecodeAddressRequest) throws -> DecodeAddressResponse {
        try callLibraryFunction(
            input: request,
            function: libTX.decode_address
        )
    }

    static func encodeAddressRequest(request: EncodeAddressRequest) throws -> EncodeAddressResponse {
        try callLibraryFunction(
            input: request,
            function: libTX.encode_address
        )
    }

    static func sborDecodeRequest(request: SborDecodeRequest) throws -> SborDecodeResponse {
        try callLibraryFunction(
            input: request,
            function: libTX.sbor_decode
        )
    }

    static func sborEncodeRequest(request: SborEncodeRequest) throws -> SborEncodeResponse {
        try callLibraryFunction(
            input: request,
            function: libTX.sbor_encode
        )
    }

    static func extractAbiRequest(request: ExtractAbiRequest) throws -> ExtractAbiResponse {
        try callLibraryFunction(
            input: request,
            function: libTX.extract_abi
        )
    }

    static func deriveNonFungibleAddressFromPublicKeyRequest(
		request: DeriveNonFungibleAddressFromPublicKeyRequest
	) throws -> DeriveNonFungibleAddressFromPublicKeyResponse {
        try callLibraryFunction(
            input: request,
            function: libTX.derive_non_fungible_address_from_public_key
        )
    }

    static func deriveNonFungibleAddressRequest(
		request: DeriveNonFungibleAddressRequest
	) throws -> DeriveNonFungibleAddressResponse {
        try callLibraryFunction(
            input: request,
            function: libTX.derive_non_fungible_address
        )
    }
}

internal extension TX {
	enum Error: Swift.Error {
		case noOutputFromLibraryCall
	}
}

private extension TX {
    /// Calls the transaction library with a given input and returns the output back.
    ///
    /// This function abstracts away how the transaction library is called and provides a high level interface for
    /// communicating and getting responses back from the library.
    static func callLibraryFunction<I: Encodable, O: Decodable>(
        input: I,
        function: (UnsafePointer<CChar>?) -> UnsafePointer<CChar>?
    ) throws -> O {
        // Serialize the given request to a JSON string.
        let requestString: String = try serialize(object: input)
        
        // Allocate enough memory for the request string and then write it to
        // that memory location
        let allocatedMemory: UnsafeMutablePointer<CChar> = allocateMemory(string: requestString)
        writeStringToMemory(string: requestString, pointer: allocatedMemory)
        
        // Calling the underlying transaction library function and getting a pointer
        // response. We cannot deallocated the `responsePointer`, it results in a crash.
		guard let responsePointer = function(allocatedMemory) else {
			throw Error.noOutputFromLibraryCall
		}
        let responseString: String = readStringFromMemory(pointer: responsePointer)
		
        
        // Deallocating the request and response memory
        deallocateMemory(pointer: allocatedMemory)
        
        return try deserialize(string: responseString)
    }
    
    /// Serializes an object to a JSON string.
    ///
    /// This private function takes an object and serializes it to a JSON string. In the current implementation, this
    /// object needs to be `Encodable`, therefore, this function abstracts the serialization logic away from the
    /// transaction library operations and into an individual function.
    static func serialize<T: Encodable>(object: T) throws -> String {
        let encoder: JSONEncoder = JSONEncoder()
        let jsonData: Data = try encoder.encode(object)
        let jsonString: String = String(data: jsonData, encoding: .utf8)!
        return jsonString
    }
    
    /// Deserializes a JSON string to a generic `T`.
    ///
    /// This function deserializes a JSON string to a generic `T` which is defined by the of this function. It is
    /// assumed that the deserialization does not fail since the payload is a trusted payload.
    ///
    /// TODO: In the future, it would be better to have this a `Result<T, Error>` since there is a chance
    /// that this could be an error type as well and not an Ok response.
    static func deserialize<T: Decodable>(string: String) throws -> T {
		
		debugPrint(string)
		
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: string.data(using: String.Encoding.utf8)!)
    }
    
    /// Allocates as memory as the C-String representation of the provided String requires.
    ///
    /// **Note: **
    ///
    /// It is important to only use one memory allocator with the transaction library, you may opt to use the swift
    /// memory allocator and pass pointers to memory allocated by swift, or alternativly you may choose to use the
    /// memory allocator used in the transaction library. However, it is not recommended to use both at the same
    /// time as it can lead to heap corruption and other undefined behavior.
    static func allocateMemory(string: String) -> UnsafeMutablePointer<CChar> {
        // Get the byte count of the C-String representation of the utf-8 encoded
        // string.
        let byteCount: Int = string.cString(using: String.Encoding.utf8)!.count
        let allocatedMemory: UnsafeMutablePointer<CChar> = UnsafeMutablePointer<CChar>.allocate(capacity: byteCount)
        return allocatedMemory
    }
    
    /// Deallocates memory
    ///
    /// This function deallocates memory which was previously allocated by the transaction library memory allocator.
    /// There are no returns from this function since it is assumed that the memory deallocation will always succeed.
    static func deallocateMemory(pointer: UnsafeMutablePointer<CChar>) {
        pointer.deallocate()
    }
    
    /// Writes the string to the memory location provided.
    ///
    /// This function writes the C-String representation of the passed string to the provided pointer. Since this is a C-String
    /// representation, this means that an additional byte is added at the end with the null terminator.
    static func writeStringToMemory(
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
    static func readStringFromMemory(
        pointer: UnsafePointer<CChar>
    ) -> String {
        String(cString: pointer)
    }
}
