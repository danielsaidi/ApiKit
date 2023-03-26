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
     Try to perform a `URLRequest` and return the raw result.
     */
    func fetch(_ request: URLRequest) async throws -> ApiResult
}

extension URLSession: ApiClient {}

public extension URLSession {

    func fetch(
        _ request: URLRequest
    ) async throws -> ApiResult {
        let result = try await data(for: request)
        let data = result.0
        let response = result.1
        return ApiResult(data: data, response: response)
    }
}

public extension ApiClient {

    /**
     Try to perform a `URLRequest` and return a result where
     the raw `Data` is mapped to a certain type.
     */
    func fetchItem<T: Decodable>(
        with request: URLRequest
    ) async throws -> T {
        let result = try await fetch(request)
        guard let data = result.data else { throw ApiError.noDataInResponse(result.response) }
        return try JSONDecoder().decode(T.self, from: data)
    }

    /**
     Try to perform a `URLRequest` and return a result where
     the raw `Data` is mapped to a certain type.
     */
    func fetchItem<T: Decodable>(
        at route: ApiRoute,
        in environment: ApiEnvironment
    ) async throws -> T {
        let request = route.urlRequest(for: environment)
        return try await fetchItem(with: request)
    }
}
