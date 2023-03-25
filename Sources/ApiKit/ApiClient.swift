//
//  ApiClient.swift
//  ApiKit
//
//  Created by Daniel Saidi on 2023-03-25.
//

import Foundation

/**
 This protocol can be implemented by types that can make api
 requests and return the raw data.

 The protocol just requires you to implement one function to
 fetch data for a `URLRequest`, after which it provides more
 ``ApiRoute`` and ``ApiEnvironment`` based functions as well
 as functions that can map the data to any `Decodable` types.

 This protocol is implemented by `URLSession` so you can use
 it as is, without having to create custom implementations.
 */
public protocol ApiClient: AnyObject {

    /**
     Try to perform a certain `URLRequest`.
     */
    func fetch(_ request: URLRequest) async throws -> ApiResult
}

extension URLSession: ApiClient {}

public extension URLSession {

    func fetch(_ request: URLRequest) async throws -> ApiResult {
        let result = try await data(for: request)
        return ApiResult(data: result.0, response: result.1)
    }
}

public extension ApiClient {

    /**
     Fetch data at an ``ApiRoute`` in an ``ApiEnvironment``.
     */
    func fetch(
        _ route: ApiRoute,
        in env: ApiEnvironment
    ) async throws -> ApiResult {
        let request = route.urlRequest(for: env)
        return try await fetch(request)
    }

    /**
     Fetch a type at an ``ApiRoute`` in an ``ApiEnvironment``.
     */
    func fetchType<T: Decodable>(
        at route: ApiRoute,
        in env: ApiEnvironment
    ) async throws -> T {
        let result = try await fetch(route, in: env)
        guard let data = result.data else { throw ApiError.noDataInResponse }
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    }
}
