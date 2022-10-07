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
//    do {
//        _ = try result.get()
//        XCTFail()
//    } catch {
//
//    }
    
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

final class FailingJSONEncoder: JSONEncoder {}

final class TestOfErrors: TestCase {
    func test_errors() throws {
        let sut = EngineToolkit(jsonEncoder: FailingJSONEncoder())
        let badRequest = DecodeAddressRequest(address: "bad_address")
        XCTAssert(
            sut.decodeAddressRequest(request: badRequest),
            throwsSpecificError: .serializeRequestFailure(.jsonEncodeRequestFailed)
        )
    }
}
