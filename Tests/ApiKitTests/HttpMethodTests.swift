//
//  HttpMethodTests.swift
//  ApiKit
//
//  Created by Daniel Saidi on 2023-03-24.
//  Copyright © 2023 Daniel Saidi. All rights reserved.
//

import XCTest
@testable import ApiKit

final class HttpMethodTests: XCTestCase {

    func method(for method: HttpMethod) -> String {
        method.method
    }

    func testMethodIsUppercasedForAllCases() throws {
        HttpMethod.allCases.forEach { method in
            XCTAssertEqual(method.method, method.rawValue.uppercased())
        }
    }

    func testMethodIsUppercased() throws {
        XCTAssertEqual(method(for: .connect), "CONNECT")
        XCTAssertEqual(method(for: .delete), "DELETE")
        XCTAssertEqual(method(for: .get), "GET")
        XCTAssertEqual(method(for: .head), "HEAD")
        XCTAssertEqual(method(for: .options), "OPTIONS")
        XCTAssertEqual(method(for: .post), "POST")
        XCTAssertEqual(method(for: .put), "PUT")
        XCTAssertEqual(method(for: .trace), "TRACE")
    }

    func testIdIsUniqueForAllCases() throws {
        HttpMethod.allCases.forEach { method in
            XCTAssertEqual(method.id, method.rawValue)
        }
    }
}
