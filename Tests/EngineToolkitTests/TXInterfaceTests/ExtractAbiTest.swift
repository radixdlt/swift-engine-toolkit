final class ExtractAbiTest: TestCase {
    
    func test__extractAbi() throws {
        // TODO: Come back to later. 
//        let packageWasm = readBytesFromFile(fileName: "package", fileExtension: "wasm")!
//        let packageAbi = readBytesFromFile(fileName: "package", fileExtension: "abi")!
//
//        let extractAbiRequest = ExtractAbiRequest(from: packageWasm)
//        let extractAbiResponse = try sut.extractAbiRequest(request: extractAbiRequest).get()
//
//        XCTAssertEqual(extractAbiResponse.abi, packageAbi)
    }
}

public func readBytesFromFile(fileName: String, fileExtension: String) -> [UInt8]? {
    guard let path = Bundle(for: ExtractAbiTest.self).path(
        forResource: fileName,
        ofType: fileExtension
    ) else { return nil }
    guard let data = NSData(contentsOfFile: path) else { return nil }

    var buffer = [UInt8](repeating: 0, count: data.length)
    data.getBytes(&buffer, length: data.length)

    return buffer
}
