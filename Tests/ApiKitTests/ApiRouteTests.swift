//
//  ApiRouteTests.swift
//  ApiKit
//
//  Created by Daniel Saidi on 2023-03-24.
//  Copyright © 2023 Daniel Saidi. All rights reserved.
//

import XCTest
@testable import ApiKit

final class ApiRouteTests: XCTestCase {

    func request(for route: TestRoute) -> URLRequest {
        let env = TestEnvironment.production
        return route.urlRequest(for: env)
    }


    func testEncodedFormItemsAreSortedAndEncoded() throws {
        let route = TestRoute.formLogin(userName: "danielsaidi", password: "let's code, shall we? & do more stuff +")
        let items = route.encodedFormItems
        XCTAssertEqual(items.count, 2)
        XCTAssertEqual(items[0].name, "password")
        XCTAssertEqual(items[0].value, "let's%20code,%20shall%20we%3F%20%26%20do%20more%20stuff%20%2B")
        XCTAssertEqual(items[1].name, "username")
        XCTAssertEqual(items[1].value, "danielsaidi")
    }


    func testUrlRequestIsCreatedWithEnvironment() throws {
        XCTAssertNotNil(request(for: .movie(id: "ABC123")))
        XCTAssertNotNil(request(for: .formLogin(userName: "danielsaidi", password: "super-secret")))
        XCTAssertNotNil(request(for: .postLogin(userName: "danielsaidi", password: "super-secret")))
        XCTAssertNotNil(request(for: .search(query: "A nice movie")))
    }

    func testUrlRequestIsPropertyConfiguredForGetRequests() throws {
        let env = TestEnvironment.production
        let route = TestRoute.search(query: "movies&+")
        let request = route.urlRequest(for: env)
        XCTAssertEqual(request.allHTTPHeaderFields, [
            "Content-Type": "application/json",
            "locale": "sv-SE"
        ])
        XCTAssertEqual(request.httpMethod, "GET")
        XCTAssertEqual(request.url?.absoluteString, "https://api.imdb.com/search?q=movies%2526+")
    }

    func testUrlRequestIsPropertyConfiguredForFormRequests() throws {
        let env = TestEnvironment.production
        let route = TestRoute.formLogin(userName: "danielsaidi", password: "let's code, shall we? & do more stuff +")
        let request = route.urlRequest(for: env)
        guard
            let bodyData = request.httpBody,
            let bodyString = String(data: bodyData, encoding: .utf8)
        else {
            return XCTFail("Invalid body data")
        }
        XCTAssertEqual(request.allHTTPHeaderFields, [
            "Content-Type": "application/x-www-form-urlencoded",
            "locale": "sv-SE"
        ])
        XCTAssertEqual(bodyString, "password=let's%20code,%20shall%20we%3F%20%26%20do%20more%20stuff%20%2B&username=danielsaidi")
    }

    func testUrlRequestIsPropertyConfiguredForPostRequests() throws {
        let env = TestEnvironment.production
        let route = TestRoute.postLogin(userName: "danielsaidi", password: "password+")
        let request = route.urlRequest(for: env)
        guard
            let bodyData = request.httpBody,
            let loginRequest = try? JSONDecoder().decode(TestLoginRequest.self, from: bodyData)
        else {
            return XCTFail("Invalid body data")
        }
        XCTAssertEqual(request.allHTTPHeaderFields, [
            "Content-Type": "application/json",
            "locale": "sv-SE"
        ])
        XCTAssertEqual(request.url?.absoluteString, "https://api.imdb.com/postLogin?")
        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertEqual(loginRequest.userName, "danielsaidi")
        XCTAssertEqual(loginRequest.password, "password+")
    }
}
