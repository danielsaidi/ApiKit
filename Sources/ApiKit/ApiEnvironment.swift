//
//  ApiEnvironment.swift
//  ApiKit
//
//  Created by Daniel Saidi on 2023-03-24.
//  Copyright © 2023 Daniel Saidi. All rights reserved.
//

import Foundation

/**
 This protocol can be implemented to define API environments.

 An ``ApiEnvironment`` should define the root ``url`` of the
 environment, to which then the ``ApiRoute/path`` of a route
 can be applied. You can use an enum to define multiple ones
 with a single enum and use associated values to define data
 for a certain environment, such as api keys and secrets etc.
 and use the data when defining request data.

 Both ``ApiEnvironment`` and ``ApiRoute`` can define headers
 and query parameters that should be merged when the request
 is created. The environment can use this to define api keys,
 secrets etc. while the route can define route-specific data.
 */
public protocol ApiEnvironment {

    /// The base URL of the environment.
    var url: URL { get }
}

public extension ApiEnvironment {

    /**
     This function returns a `URLRequest` that is configured
     for the given `httpMethod` and the route's `queryItems`.
     */
    func urlRequest(for route: ApiRoute) -> URLRequest {
        route.urlRequest(for: self)
    }
}
