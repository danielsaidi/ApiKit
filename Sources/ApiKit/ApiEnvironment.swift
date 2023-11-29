//
//  ApiEnvironment.swift
//  ApiKit
//
//  Created by Daniel Saidi on 2023-03-24.
//  Copyright © 2023 Daniel Saidi. All rights reserved.
//

import Foundation

/**
 This protocol can be implemented to define API environments
 or specific API versions.

 An ``ApiEnvironment`` must define a root ``url`` to which a
 route ``ApiRoute/path`` can be applied. You can use an enum
 to define multiple environments, then use associated values
 to provide environment-specific data like keys, secrets etc.

 Both ``ApiEnvironment`` and ``ApiRoute`` can define headers
 and query parameters, which are then merged. An environment
 can use this to define global data, while routes can define
 route-specific data.
 */
public protocol ApiEnvironment: ApiRequestData {

    /// The base URL of the environment.
    var url: String { get }
}

public extension ApiEnvironment {

    /// Get a `URLRequest` for the provided `route`.
    func urlRequest(for route: ApiRoute) throws -> URLRequest {
        try route.urlRequest(for: self)
    }
}
