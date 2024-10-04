//
//  ApiEnvironment.swift
//  ApiKit
//
//  Created by Daniel Saidi on 2023-03-24.
//  Copyright © 2023-2024 Daniel Saidi. All rights reserved.
//

import Foundation

/// This protocol can be used to define API environments, or
/// specific API versions.
///
/// An ``ApiEnvironment`` must define a ``url``, to which an
/// environment-relative ``ApiRoute/path`` can be appended.
///
/// You can use enums to define environments, and associated
/// values to provide environment-specific parameters.
///
/// Both ``ApiEnvironment`` and ``ApiRoute`` can specify any
/// headers and query parameters they need. Environments can
/// define global headers and query parameters, while routes
/// can define route-specific ones.
public protocol ApiEnvironment: ApiRequestData, Sendable {

    /// The base URL of the environment.
    var url: String { get }
}
