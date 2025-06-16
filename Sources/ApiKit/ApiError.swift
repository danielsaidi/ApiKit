//
//  ApiError.swift
//  ApiKit
//
//  Created by Daniel Saidi on 2023-03-25.
//  Copyright © 2023-2025 Daniel Saidi. All rights reserved.
//

import Foundation
import SwiftUI

/// This enum defines api-specific errors that can be thrown
/// when an ``ApiClient`` communicates with any external API.
public enum ApiError: Equatable, LocalizedError {
    
    /// This error should be thrown when an ``ApiEnvironment``
    /// has a url that can't be used to generate a `URL`.
    case invalidEnvironmentUrl(String)

    /// This error should be thrown when a URL request fails
    /// due to an invalid status code (outside of 100-599).
    case invalidHttpStatusCode(Int, URLRequest, URLResponse, Data)

    /// This error should be thrown when a `URLRequest` will
    /// fail to be created due to invalid `URLComponents`.
    case noUrlInComponents(URLComponents)

    /// This error should be thrown when a `URLRequest` will
    /// fail to be created due to an invalid `URL`.
    case failedToCreateComponentsFromUrl(URL)

    /// This error should be thrown when a URL request fails
    /// due to an unsuccessful status code (100-199, as well
    /// as 300-599).
    case unsuccessfulHttpStatusCode(Int, URLRequest, URLResponse, Data)
}

public extension ApiError {

    /// A user-friendly error description.
    var errorDescription: String? {
        switch self {
        case .invalidEnvironmentUrl: "Unable to connect to the service. Please check your network connection and try again."
        case .invalidHttpStatusCode(let code, _, _, _): "An invalid status code was returned (Code: \(code)). Please try again later."
        case .failedToCreateComponentsFromUrl: "Invalid request configuration."
        case .noUrlInComponents: "Invalid request configuration."
        case .unsuccessfulHttpStatusCode(let code, _, _, _):
            switch code {
            case 400: "The request was invalid. Please check your input and try again."
            case 401: "Authentication failed. Please sign in again."
            case 403: "You don't have permission to access this resource."
            case 404: "The requested resource was not found."
            case 408: "The request timed out. Please check your connection and try again."
            case 429: "Too many requests. Please wait a moment and try again."
            case 500...599: "The server is experiencing issues. Please try again later."
            default: "A network error occurred. Please try again later."
            }
        }
    }
}

public extension ApiError {
    
    /// Whether the error is a ``ApiError/invalidHttpStatusCode(_:_:_:_:)``
    var isInvalidHttpStatusCodeError: Bool {
        switch self {
        case .invalidHttpStatusCode: true
        default: false
        }
    }
    
    /// Whether the error is a ``ApiError/invalidHttpStatusCode(_:_:_:_:)``
    var isUnsuccessfulHttpStatusCodeError: Bool {
        switch self {
        case .unsuccessfulHttpStatusCode: true
        default: false
        }
    }
}

#Preview {

    return List {
        listItem(for: ApiError.invalidEnvironmentUrl("foo"))
    }

    func listItem(for error: Error) -> some View {
        Text(error.localizedDescription)
    }
}
