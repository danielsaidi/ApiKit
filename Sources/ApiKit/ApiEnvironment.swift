//
//  ApiEnvironment.swift
//  ApiKit
//
//  Created by Daniel Saidi on 2023-03-24.
//  Copyright © 2023-2025 Daniel Saidi. All rights reserved.
//

import Foundation

/// This protocol can be used to define API environments, or
/// specific API versions.
///
/// An ``ApiEnvironment`` must define a ``url``, to which an
/// environment-relative ``ApiRoute/path`` can be added. You
/// can use an enum to define multiple environments.
///
/// Both the ``ApiEnvironment`` and ``ApiRoute`` can specify
/// headers and query parameters that they need. Environment
/// specific headers and query parameters will be applied to
/// all requests, while a route specific value will override
/// a value that is defined by the environment.
public protocol ApiEnvironment: Sendable {
    
    /// Optional header parameters to apply to all requests.
    var headers: [String: String]? { get }

    /// Optional query params to apply to all requests.
    var queryParams: [String: String]? { get }

    /// The base URL of the environment.
    var url: String { get }
}

extension ApiEnvironment {

    /// Convert ``queryParams`` to url encoded query items.
    var encodedQueryItems: [URLQueryItem]? {
        queryParams?
            .map { URLQueryItem(name: $0.key, value: $0.value) }
            .sorted { $0.name < $1.name }
    }
}
