//
//  ApiRequest.swift
//  ApiKit
//
//  Created by Daniel Saidi on 2024-01-17.
//  Copyright © 2024 Daniel Saidi. All rights reserved.
//

import Foundation

/// This protocol represents an API request that specifies a
/// route and a response type.
///
/// You can implement this type to avoid having to specify a
/// route and a response type when using an ``ApiClient`` to
/// fetch data.
///
/// To fetch data with an ``ApiRequest`` value, just use the
/// request-based `fetch` function. It automatically selects
/// the request route and specifies the proper response type.
public protocol ApiRequest: Codable {
    
    associatedtype ResponseType: Codable
    
    var route: ApiRoute { get }
}

public extension URLSession {
    
    /// Try to request a certain ``ApiRequest``.
    func fetch<RequestType: ApiRequest>(
        _ request: RequestType,
        from env: ApiEnvironment
    ) async throws -> RequestType.ResponseType {
        try await self.request(at: request.route, in: env)
    }
}
