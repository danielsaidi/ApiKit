//
//  TestTypes.swift
//  ApiKit
//
//  Created by Daniel Saidi on 2023-03-28.
//  Copyright © 2023 Daniel Saidi. All rights reserved.
//

import ApiKit
import Foundation

class TestClient: ApiClient {

    init(
        data: Data?,
        error: Error?
    ) {
        self.data = data
        self.error = error
    }

    let data: Data?
    let error: Error?

    func fetch(
        _ request: URLRequest
    ) async throws -> ApiResult {
        if let error { throw error }
        return ApiResult(data: data, response: .init())
    }
}

enum TestEnvironment: ApiEnvironment {

    case staging
    case production

    var url: String {
        switch self {
        case .staging: return "https://staging-api.imdb.com"
        case .production: return "https://api.imdb.com"
        }
    }

    var headers: [String : String]? {
        ["api-secret": "APISECRET"]
    }

    var queryParams: [String : String]? {
        ["api-key": "APIKEY"]
    }
}

enum TestRoute: ApiRoute {

    case formLogin(userName: String, password: String)
    case movie(id: String)
    case postLogin(userName: String, password: String)
    case search(query: String, page: Int)

    var httpMethod: HttpMethod {
        switch self {
        case .formLogin: return .post
        case .movie: return .get
        case .postLogin: return .post
        case .search: return .get
        }
    }

    var path: String {
        switch self {
        case .formLogin: return "formLogin"
        case .movie(let id): return "movie/\(id)"
        case .postLogin: return "postLogin"
        case .search: return "search"
        }
    }

    var headers: [String : String]? {
        ["locale": "sv-SE"]
    }

    var formParams: [String: String]? {
        switch self {
        case .formLogin(let userName, let password):
            return ["username": userName, "password": password]
        default: return nil
        }
    }

    var postData: Data? {
        switch self {
        case .formLogin: return nil
        case .movie: return nil
        case .postLogin(let userName, let password):
            let request = TestLoginRequest(
                userName: userName, password: password
            )
            let encoder = JSONEncoder()
            return try? encoder.encode(request)
        case .search: return nil
        }
    }

    var queryParams: [String: String]? {
        switch self {
        case .search(let query, let page): return ["q": query, "p": "\(page)"]
        default: return nil
        }
    }
}


struct TestLoginRequest: Codable {

    var userName: String
    var password: String
}

enum TestError: Error, Equatable {

    case baboooom
}

struct TestMovie: Codable {

    var id: String
    var name: String
}

struct TestPerson: Codable {

    var id: String
    var firstName: String
    var lastName: String
}

extension ApiError {

    var isNoDataInResponse: Bool {
        switch self {
        case .noDataInResponse: return true
        default: return false
        }
    }
}
