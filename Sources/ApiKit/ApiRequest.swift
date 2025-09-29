//
//  ApiRequest.swift
//  ApiKit
//
//  Created by Daniel Saidi on 2024-01-17.
//  Copyright © 2024-2025 Daniel Saidi. All rights reserved.
//

import Foundation

/// This protocol can be used to define a API route, and its expected return type.
///
/// You can use this protocol to avoid having to specify the return type when fetching route data.
/// Just use ``ApiClient/fetch(_:from:)`` to automatically decode the response data
/// to the expected ``ResponseType``.
public protocol ApiRequest: Codable {
    
    associatedtype ResponseType: Codable
    
    var route: ApiRoute { get }
}

public extension ApiClient {
    
    /// Try to request a certain ``ApiRequest``.
    func fetch<RequestType: ApiRequest>(
        _ request: RequestType,
        from env: ApiEnvironment
    ) async throws -> RequestType.ResponseType {
        try await self.request(at: request.route, in: env)
    }
}
