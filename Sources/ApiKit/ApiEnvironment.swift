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
/// You can use an enum to define several environments for a certain API, or use
/// a struct if you want to allow for more extensibility.
///
/// An ``ApiEnvironment`` must define an global environment ``url``, to
/// which an environment-relative ``ApiRoute`` path can be appended.
///
/// An ``ApiEnvironment`` can define any headers and query parameters it
/// needs, which are then applied to all requests to that environment. A route can
/// then override any header or query parameter.
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
