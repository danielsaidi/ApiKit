//
//  HttpMethod.swift
//  ApiKit
//
//  Created by Daniel Saidi on 2023-03-24.
//  Copyright © 2023 Daniel Saidi. All rights reserved.
//

import Foundation

/// This enum defines various HTTP methods.
public enum HttpMethod: String, CaseIterable, Identifiable {

    case connect
    case delete
    case get
    case head
    case options
    case patch
    case post
    case put
    case trace

    /// The unique HTTP method identifier.
    public var id: String { rawValue }

    /// The uppercased HTTP method name.
    public var method: String { id.uppercased() }
}
