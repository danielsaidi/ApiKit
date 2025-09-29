//
//  ApiEnvironment.swift
//  ApiKit
//
//  Created by Daniel Saidi on 2023-03-24.
//  Copyright © 2023-2025 Daniel Saidi. All rights reserved.
//

import Foundation

/// This protocol can be used to define API environments, or specific API versions.
///
/// An ``ApiEnvironment`` must define a ``url``, to which an ``ApiRoute``-specific
/// path can be appended. You can use enums to define multiple environments.
///
/// The ``ApiEnvironment`` can define headers and query parameters it needs, which will
/// be applied to all requests to that environment. An ``ApiRoute`` can override any values
/// that are defined by the environment.
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
