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

    /// This error can be thrown when try to fetch data from
    /// an external API and map it to a `Decodable` type.
    case noDataInResponse(URLResponse?)
}
