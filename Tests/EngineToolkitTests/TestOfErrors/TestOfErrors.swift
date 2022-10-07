//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-10-06.
//

import Foundation
@testable import EngineToolkit
import XCTest

func XCTAssertThrowsFailure<Success, Failure: Swift.Error & Equatable>(
    _ expression: @autoclosure () -> Result<Success, Failure>,
    _ message: @autoclosure () -> String = "",
    file: StaticString = #filePath,
    line: UInt = #line,
    _ errorHandler: (_ failure: Failure) -> Void = { _ in }
) {
    let result = expression()
    
    let assertFailureTypeResult = result.mapError { (failure: Failure) -> Failure in
        errorHandler(failure)
        return failure
    }
    
    XCTAssertThrowsError(
        try assertFailureTypeResult.get(),
        message(),
        file: file,
        line: line
    )
}

func XCTAssertThrowsEngineError<Success>(
    _ expression: @autoclosure () -> Result<Success, EngineToolkit.Error>,
    _ message: @autoclosure () -> String = "",
    file: StaticString = #filePath,
    line: UInt = #line,
    _ errorHandler: (_ failure: EngineToolkit.Error) -> Void = { _ in }
) {
    XCTAssertThrowsFailure(
        expression(),
        message(),
        file: file,
        line: line,
        errorHandler
    )
}

func XCTAssert<Success>(
    _ expression: @autoclosure () -> Result<Success, EngineToolkit.Error>,
    throwsSpecificError specificError: EngineToolkit.Error,
    _ message: @autoclosure () -> String = "",
    file: StaticString = #filePath,
    line: UInt = #line
) {
    XCTAssertThrowsFailure(
        expression(),
        message(),
        file: file,
        line: line
    ) { failure in
        XCTAssertEqual(failure, specificError, message(), file: file, line: line)
    }
}

enum ManualJSONError: String, Error {
    case encodeFail
    case decodeFail
}
final class FailingJSONEncoder: JSONEncoder {
    override func encode<T>(_ value: T) throws -> Data where T : Encodable {
        throw ManualJSONError.encodeFail
    }
}
struct ManualDecodeFailure: Error {}
final class FailingJSONDecoder: JSONDecoder {
    override func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable {
        throw ManualJSONError.decodeFail
    }
    
}

final class TestOfErrors: TestCase {
    func test_json_encode_fail_errors() throws {
        let sut = EngineToolkit(jsonEncoder: FailingJSONEncoder())
        XCTAssert(
            sut.information(),
            throwsSpecificError: .serializeRequestFailure(.jsonEncodeRequestFailed)
        )
    }
    
    func test_json_decode_fail_errors() throws {
        let sut = EngineToolkit(jsonDecoder: FailingJSONDecoder())
        XCTAssert(
            sut.information(),
            throwsSpecificError: .deserializeResponseFailure(
                .decodeResponseFailedAndCouldNotDecodeAsErrorResponseEither(
                    responseType: "\(InformationResponse.self)",
                    decodingFailure: ManualJSONError.decodeFail.rawValue
                )
            )
        )
    }
}
