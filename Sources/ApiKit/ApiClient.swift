//
//  ApiClient.swift
//  ApiKit
//
//  Created by Daniel Saidi on 2023-03-25.
//  Copyright © 2023 Daniel Saidi. All rights reserved.
//

import Foundation

/**
 This protocol can be implemented by types that can make api
 requests and return raw resoonse data.
 
 Use ``fetch(_:)`` to fetch raw data, and ``fetchItem(with:)``
 or ``fetchItem(at:in:)`` to fetch typed data.
 
 The protocol is implemented by `URLSession`, so you can use
 it without having to create a custom client implementation.
 
 If you must create a custom client implementation, you only
 have to implement ``fetch(_:)`` if you need to customize it.
 */
public protocol ApiClient: AnyObject {
    
    /// Fetch data with the provided `URLRequest`.
    func fetchData(
        for request: URLRequest
    ) async throws -> (Data, URLResponse)
}

extension URLSession: ApiClient {}

public extension URLSession {

    func fetchData(
        for request: URLRequest
    ) async throws -> (Data, URLResponse) {
        try await data(for: request)
    }
}

public extension ApiClient {
    
    /// Fetch an API result with the provided request.
    func fetch(
        _ request: URLRequest
    ) async throws -> ApiResult {
        let result = try await fetchData(for: request)
        let data = result.0
        let response = result.1
        return ApiResult(data: data, response: response)
    }
    
    /// Fetch an API result from the provided route.
    func fetch(
        _ route: ApiRoute,
        in environment: ApiEnvironment
    ) async throws -> ApiResult {
        let request = try route.urlRequest(for: environment)
        return try await fetch(request)
    }

    /// Fetch a decodable item with the provided request.
    func fetchItem<T: Decodable>(
        with request: URLRequest
    ) async throws -> T {
        let result = try await fetch(request)
        let data = result.data
        return try JSONDecoder().decode(T.self, from: data)
    }

    /// Fetch a decodable item from the provided route.
    func fetchItem<T: Decodable>(
        at route: ApiRoute,
        in environment: ApiEnvironment
    ) async throws -> T {
        let request = try route.urlRequest(for: environment)
        return try await fetchItem(with: request)
    }
    
    /// Validate the provided request, response and data.
    func validate(
        request: URLRequest,
        response: URLResponse,
        data: Data
    ) throws {
        guard let httpResponse = response as? HTTPURLResponse else { return }
        let status = httpResponse.statusCode
        let isValidStatus = status >= 200 && status < 300
        if isValidStatus { return }
        throw ApiError.invalidResponseStatusCode(status, request, response, data)
    }
}
