//
//  ApiError.swift
//  ApiKit
//
//  Created by Daniel Saidi on 2023-03-25.
//

import Foundation

/**
 This enum defines api-specific errors that can occur when a
 client communicates with an external API.
 */
public enum ApiError: Error, Equatable {

    /// This error should be thrown when an ``ApiEnvironment``
    /// has a ``url`` that can't be used to generate a `URL`.
    case invalidEnvironmentUrl(String)

    /// This error should be thrown when a `URLResponse` has
    /// no `Data` in a situation were data is expected.
    case noDataInResponse(URLResponse?)

    /// This error should be thrown when a `URLRequest` will
    /// fail to be created due to invalid `URLComponents`.
    case noUrlInComponents(URLComponents)

    /// This error should be thrown when a `URLRequest` will
    /// fail to be created due to an invalid `URL`.
    case failedToCreateComponentsFromUrl(URL)
}
