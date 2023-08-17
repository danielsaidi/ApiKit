//
//  Yelp+Environment.swift
//  ApiKit
//
//  Created by Daniel Saidi on 2023-08-17.
//  Copyright © 2023 Daniel Saidi. All rights reserved.
//

import Foundation

public extension Yelp {

    /// This enum defines the currently supported API routes.
    enum ApiRoute: ApiKit.ApiRoute {

        case restaurant(id: String)
        case restaurantReviews(restaurantId: String)
        case search(params: Yelp.SearchParams)
    }
}

public extension Yelp.ApiRoute {

    var path: String {
        switch self {
        case .restaurant(let id): return "businesses/\(id)"
        case .restaurantReviews(let id): return "businesses/\(id)/reviews"
        case .search: return "businesses/search"
        }
    }

    var httpMethod: HttpMethod { .get }

    var headers: [String: String]? { nil }

    var formParams: [String: String]? { nil }

    var postData: Data? { nil }
    
    var queryParams: [String: String]? {
        switch self {
        case .restaurant: return nil
        case .restaurantReviews: return nil
        case .search(let params): return params.queryParams
        }
    }
}
