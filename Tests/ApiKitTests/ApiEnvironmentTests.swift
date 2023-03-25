//
//  ApiEnvironmentTests.swift
//  ApiKit
//
//  Created by Daniel Saidi on 2023-03-25.
//  Copyright © 2023 Daniel Saidi. All rights reserved.
//

import XCTest
@testable import ApiKit

final class ApiEnvironmentTests: XCTestCase {

    func testUrlRequestIsNotNilForRoute() throws {
        let env = TestEnvironment.production
        let route = TestRoute.postLogin(userName: "danielsaidi", password: "let's code, shall we? & do more stuff +")
        XCTAssertNotNil(env.urlRequest(for: route))
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
