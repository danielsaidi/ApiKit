//
//  ApiClient.swift
//  ApiKit
//
//  Created by Daniel Saidi on 2023-03-25.
//

import Foundation

/**
 This protocol can be implemented by any types that can be
 used to communicate with an external api.

 This protocol is implemented by `URLSession`.
 */
public protocol ApiClient: AnyObject {

    func fetch(
        _ route: ApiRoute,
        for env: ApiEnvironment
    ) async throws -> ApiResult
}

public extension ApiClient {

    func fetchType<T: Decodable>(
        for route: ApiRoute,
        from env: ApiEnvironment
    ) async throws -> T {
        let result = try await fetch(route, for: env)
        guard let data = result.data else { throw ApiError.noDataInResponse }
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    }
}

public extension URLSession {

    func fetch(
        _ route: ApiRoute,
        for env: ApiEnvironment
    ) async throws -> ApiResult {
        let urlRequest = route.urlRequest(for: env)
        let result = try await data(for: urlRequest)
        return ApiResult(data: result.0, response: result.1)
    }
}
