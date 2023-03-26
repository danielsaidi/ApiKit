//
//  ApiResult.swift
//  ApiKit
//
//  Created by Daniel Saidi on 2023-03-25.
//

import Foundation

/**
 This type can be returned used by an ``ApiClient`` when the
 client requests data from an external API.
 */
public struct ApiResult {

    public init(
        data: Data?,
        response: URLResponse?
    ) {
        self.data = data
        self.response = response
    }

    public var data: Data?
    public var response: URLResponse?
}
