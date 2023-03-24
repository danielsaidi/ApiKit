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

    func testFormRequestsArePropertyAdjusted() throws {
        let env = TestEnvironment.production
        let route = TestRoute.formLogin(userName: "danielsaidi", password: "let's code, shall we? & do more stuff +")
        let request = route.formRequest(for: env)
        let contentType = request.allHTTPHeaderFields?["Content-Type"]
        XCTAssertEqual(contentType, "application/x-www-form-urlencoded")
        guard
            let bodyData = request.httpBody,
            let bodyString = String(data: bodyData, encoding: .utf8)
        else {
            return XCTFail("Invalid body data")
        }
        XCTAssertEqual(bodyString, "password=let's%20code,%20shall%20we%3F%20%26%20do%20more%20stuff%20%2B&username=danielsaidi")
    }

    func testQueryItemValuesAreUrlEncoded() throws {
        let route = TestRoute.search(query: "let's search for &")
        let items = route.queryItems
        XCTAssertEqual(items[0].value, "let\'s%20search%20for%20%26")
    }

    func testUrlRequestsArePropertyConfiguredForGetRequests() throws {
        let env = TestEnvironment.production
        let route = TestRoute.search(query: "movies&+")
        let request = route.urlRequest(for: env)
        let contentType = request.allHTTPHeaderFields?["Content-Type"]
        XCTAssertEqual(contentType, "application/json")
        XCTAssertEqual(request.url?.absoluteString, "https://prod.api/search?q=movies%2526+")
        XCTAssertEqual(request.httpMethod, "GET")
    }

    func testUrlRequestsArePropertyConfiguredForPostRequests() throws {
        let env = TestEnvironment.production
        let route = TestRoute.postLogin(userName: "danielsaidi", password: "password+")
        let request = route.urlRequest(for: env)
        let contentType = request.allHTTPHeaderFields?["Content-Type"]
        XCTAssertEqual(contentType, "application/json")
        XCTAssertEqual(request.url?.absoluteString, "https://prod.api/postLogin?")
        XCTAssertEqual(request.httpMethod, "POST")
        guard
            let bodyData = request.httpBody,
            let request = try? JSONDecoder().decode(TestLoginRequest.self, from: bodyData)
        else {
            return XCTFail("Invalid body data")
        }
        XCTAssertEqual(request.userName, "danielsaidi")
        XCTAssertEqual(request.password, "password+")
    }
}

private enum TestEnvironment: ApiEnvironment {

    case staging
    case production

    var url: URL {
        guard let url = URL(string: urlString) else { fatalError("TODO: make throwing") }
        return url
    }

    var urlString: String {
        switch self {
        case .staging: return "https://staging.api"
        case .production: return "https://prod.api"
        }
    }
}

private struct TestLoginRequest: Codable {

    var userName: String
    var password: String
}

private enum TestRoute: ApiRoute {

    case formLogin(userName: String, password: String)
    case postLogin(userName: String, password: String)
    case search(query: String)

    var httpMethod: HttpMethod {
        switch self {
        case .formLogin: return .post
        case .postLogin: return .post
        case .search: return .get
        }
    }

    var path: String {
        switch self {
        case .formLogin: return "formLogin"
        case .postLogin: return "postLogin"
        case .search: return "search"
        }
    }

    var formParams: [String : String] {
        switch self {
        case .formLogin(let userName, let password):
            return ["username": userName, "password": password]
        case .postLogin: return [:]
        case .search: return [:]
        }
    }

    var postData: Data? {
        switch self {
        case .formLogin: return nil
        case .postLogin(let userName, let password):
            let request = TestLoginRequest(
                userName: userName, password: password
            )
            let encoder = JSONEncoder()
            return try? encoder.encode(request)
        case .search: return nil
        }
    }

    var queryParams: [String : String] {
        switch self {
        case .formLogin: return [:]
        case .postLogin: return [:]
        case .search(let query): return ["q": query]
        }
    }
}
