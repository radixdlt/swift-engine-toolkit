import Foundation
import libTX

/// A type provides a high level functions and method for the
/// interaction with the transaction library and abstracting away
/// the low level memory allocation, serialization, and other low level concepts.
public struct EngineToolkit {
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
public extension EngineToolkit {
    
    /// Obtains information on the current transaction library used.
    ///
    /// This function is used to get information on the transaction library such as the package version. You may
    /// think of this information request as the "Hello World" example of the transaction library where, this is
    /// typically the first request type to be implemented in any implementation of the transaction library, if this
    /// request works then you can be assured that all of the other lower level operations work as well.
    func information() -> Result<InformationResponse, Error> {
        callLibraryFunction(
            request: InformationRequest(),
            function: libTX.information
        )
    }
    
    func convertManifest(
		request: ConvertManifestRequest
	) -> Result<ConvertManifestResponse, Error> {
        callLibraryFunction(
            request: request,
            function: libTX.convert_manifest
        )
    }

    func compileTransactionIntentRequest(
		request: CompileTransactionIntentRequest
	) -> Result<CompileTransactionIntentResponse, Error> {
        callLibraryFunction(
            request: request,
            function: libTX.compile_transaction_intent
        )
    }

    func decompileTransactionIntentRequest(
		request: DecompileTransactionIntentRequest
	) -> Result<DecompileTransactionIntentResponse, Error> {
        callLibraryFunction(
            request: request,
            function: libTX.decompile_transaction_intent
        )
    }

    func compileSignedTransactionIntentRequest(
		request: CompileSignedTransactionIntentRequest
	) -> Result<CompileSignedTransactionIntentResponse, Error> {
        callLibraryFunction(
            request: request,
            function: libTX.compile_signed_transaction_intent
        )
    }

    func decompileSignedTransactionIntentRequest(
		request: DecompileSignedTransactionIntentRequest
	) -> Result<DecompileSignedTransactionIntentResponse, Error> {
        callLibraryFunction(
            request: request,
            function: libTX.decompile_signed_transaction_intent
        )
    }

    func compileNotarizedTransactionIntentRequest(
		request: CompileNotarizedTransactionIntentRequest
	) -> Result<CompileNotarizedTransactionIntentResponse, Error> {
        callLibraryFunction(
            request: request,
            function: libTX.compile_notarized_transaction_intent
        )
    }

    func decompileNotarizedTransactionIntentRequest(
		request: DecompileNotarizedTransactionIntentRequest
	) -> Result<DecompileNotarizedTransactionIntentResponse, Error> {
        callLibraryFunction(
            request: request,
            function: libTX.decompile_notarized_transaction_intent
        )
    }

    func decompileUnknownTransactionIntentRequest(
		request: DecompileUnknownTransactionIntentRequest
	) -> Result<DecompileUnknownTransactionIntentResponse, Error> {
        callLibraryFunction(
            request: request,
            function: libTX.decompile_unknown_transaction_intent
        )
    }

    func decodeAddressRequest(
		request: DecodeAddressRequest
	) -> Result<DecodeAddressResponse, Error> {
        callLibraryFunction(
            request: request,
            function: libTX.decode_address
        )
    }

    func encodeAddressRequest(
		request: EncodeAddressRequest
	) -> Result<EncodeAddressResponse, Error> {
        callLibraryFunction(
            request: request,
            function: libTX.encode_address
        )
    }

    func sborDecodeRequest(
		request: SborDecodeRequest
	) -> Result<SborDecodeResponse, Error> {
        callLibraryFunction(
            request: request,
            function: libTX.sbor_decode
        )
    }

    func sborEncodeRequest(
		request: SborEncodeRequest
	) -> Result<SborEncodeResponse, Error> {
        callLibraryFunction(
            request: request,
            function: libTX.sbor_encode
        )
    }

    func extractAbiRequest(
		request: ExtractAbiRequest
	) -> Result<ExtractAbiResponse, Error> {
        callLibraryFunction(
            request: request,
            function: libTX.extract_abi
        )
    }

    func deriveNonFungibleAddressFromPublicKeyRequest(
		request: DeriveNonFungibleAddressFromPublicKeyRequest
	) -> Result<DeriveNonFungibleAddressFromPublicKeyResponse, Error> {
        callLibraryFunction(
            request: request,
            function: libTX.derive_non_fungible_address_from_public_key
        )
    }

    func deriveNonFungibleAddressRequest(
		request: DeriveNonFungibleAddressRequest
	) -> Result<DeriveNonFungibleAddressResponse, Error> {
        callLibraryFunction(
            request: request,
            function: libTX.derive_non_fungible_address
        )
    }
}


// MARK: Private
private extension EngineToolkit {
    /// Calls the transaction library with a given input and returns the output back.
    ///
    /// This function abstracts away how the transaction library is called and provides a high level interface for
    /// communicating and getting responses back from the library.
    func callLibraryFunction<Request, Response>(
        request: Request,
        function: (UnsafePointer<CChar>?) -> UnsafePointer<CChar>?
    ) -> Result<Response, Error> where Request: Encodable, Response: Decodable {
        // Serialize the given request to a JSON string.
        serialize(request: request)
            .mapError(Error.serializeRequestFailure)
            .flatMap { (requestString: String) in
                #if DEBUG
                prettyPrintRequest(jsonString: requestString)
                #endif
                
                // Allocate enough memory for the request string and then write it to
                // that memory location
                return allocateMemoryForJSONStringOf(request: requestString)
                    .map { requestPointer in
                        writeJSONString(of: requestString, to: requestPointer)
                    }
                    .mapError(Error.callLibraryFunctionFailure)
                   
            }
            .flatMap { (requestPointer: UnsafeMutablePointer<CChar>) in
                // Calling the underlying transaction library function and getting a pointer
                // response. We cannot deallocated the `responsePointer`, it results in a crash.
                guard let responsePointer = function(requestPointer) else {
                    // Deallocate memory on failure.
                    deallocateMemory(pointer: requestPointer)
                    
                    return .failure(Error.callLibraryFunctionFailure(.noReturnedOutputFromLibraryFunction))
                }
                
                return .success((requestPointer, responsePointer))
            }
            .flatMap { (requestPointer: UnsafeMutablePointer<CChar>, responsePointer: UnsafePointer<CChar>) in
                
                let responseJSONString = jsonStringOfResponse(at: responsePointer)
                
                #if DEBUG
                prettyPrintResponse(jsonString: responseJSONString)
                #endif
                
                // Deallocating the request and response memory
                deallocateMemory(pointer: requestPointer)
                
                // Deserialize response
                return deserialize(jsonString: responseJSONString)
                    .mapError(Error.deserializeResponseFailure)
            }
    }
    
    /// Serializes an object to a JSON string.
    ///
    /// This private function takes an object and serializes it to a JSON string. In the current implementation, this
    /// object needs to be `Encodable`, therefore, this function abstracts the serialization logic away from the
    /// transaction library operations and into an individual function.
    func serialize(request: any Encodable) -> Result<String, Error.SerializeRequestFailure> {
        let jsonData: Data
        do {
           jsonData = try jsonEncoder.encode(request)
        } catch {
            return .failure(.jsonEncodeRequestFailed)
        }
		guard let jsonString = String(data: jsonData, encoding: .utf8) else {
            return .failure(.utf8EncodingFailed)
		}
        return .success(jsonString)
    }
    
    /// Deserializes a JSON string to a generic `T`.
    ///
    /// This function deserializes a JSON string to a generic `T` which is defined by the of this function. It is
    /// assumed that the deserialization does not fail since the payload is a trusted payload.
    ///
    /// TODO: In the future, it would be better to have this a `Result<T, Error>` since there is a chance
    /// that this could be an error type as well and not an Ok response.
    func deserialize<Response>(jsonString: String) -> Result<Response, Error.DeserializeResponseFailure>
        where Response: Decodable
    {
		guard let jsonData = jsonString.data(using: .utf8) else {
            return .failure(.beforeDecodingError(.failedToUTF8EncodeResponseJSONString))
		}
        
        do {
            let response = try jsonDecoder.decode(Response.self, from: jsonData)
            return .success(response)
        } catch {
            do {
                /// We might have got an **ErrorResponse** from the Radix Engine Toolkit,
                /// try decoding jsonData to that instead.
                let errorResponse = try jsonDecoder.decode(ErrorResponse.self, from: jsonData)
                return .failure(.errorResponse(errorResponse))
            } catch {
                #if DEBUG
                prettyPrint(responseJSONString: jsonString, error: error, failedToDecodeInto: Response.self)
                #endif
                return .failure(.decodeResponseFailedAndCouldNotDecodeAsErrorResponseEither(responseType: "\(Response.self)", decodingFailure: String(describing: error)))
            }
        }
    }
    
    /// Allocates as memory as the C-String representation of the provided String requires.
    ///
    /// **Note: **
    ///
    /// It is important to only use one memory allocator with the transaction library, you may opt to use the swift
    /// memory allocator and pass pointers to memory allocated by swift, or alternativly you may choose to use the
    /// memory allocator used in the transaction library. However, it is not recommended to use both at the same
    /// time as it can lead to heap corruption and other undefined behavior.
    func allocateMemoryForJSONStringOf(request requestJSONString: String) -> Result<UnsafeMutablePointer<CChar>, Error.CallLibraryFunctionFailure> {
        // Get the byte count of the C-String representation of the utf-8 encoded
        // string.
		guard let cString = requestJSONString.cString(using: .utf8) else {
            return .failure(.allocatedMemoryForResponseFailedCouldNotUTF8EncodeCString)
		}
        let byteCount: Int = cString.count
        let allocatedMemory = UnsafeMutablePointer<CChar>.allocate(capacity: byteCount)
        return .success(allocatedMemory)
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
    @discardableResult
    func writeJSONString(
        of requestJSONString: String,
        to pointer: UnsafeMutablePointer<CChar>
    ) -> UnsafeMutablePointer<CChar> {
        // Converting the request JSON string to an array of UTF-8 bytes
        let requestChars: [CChar] = Array(requestJSONString.utf8CString)
        
        // Iterating over the array and writing all of the bytes to memory
        for (charIndex, cChar) in requestChars.enumerated() {
            pointer.advanced(by: charIndex).pointee = cChar
        }
        
        return pointer
    }
    
    /// Reads a string from the provided memory location.
    ///
    /// This function reads a C-String, null terminated, string from the provided memory location and returns it.
    func jsonStringOfResponse(
        at pointer: UnsafePointer<CChar>
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
func prettyPrint<FailedDecodable: Decodable>(
    responseJSONString: String,
    error: Swift.Error,
    failedToDecodeInto: FailedDecodable.Type
) {
    prettyPrint(
        jsonString: responseJSONString,
        label: "\n📦⬇️ Failed to parse response JSON string to either \(FailedDecodable.self) or \(ErrorResponse.self), underlying decoding error: \(String(describing: error))"
    )
}

/// Tries to pretty prints JSON string even before Decodable JSON decoding takes place
/// using old Cocoa APIs
func prettyPrint(jsonString: String, label: String?) {
    guard
        EngineToolkit._debugPrint,
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
