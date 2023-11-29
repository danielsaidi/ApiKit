//
//  Yelp+Route.swift
//  ApiKit
//
//  Created by Daniel Saidi on 2023-08-17.
//  Copyright © 2023 Daniel Saidi. All rights reserved.
//

import Foundation

public extension Yelp {

    /// This enum defines the currently supported API routes.
    enum Route: ApiRoute {

        case restaurant(id: String)
        case restaurantReviews(restaurantId: String)
        case search(params: Yelp.SearchParams)
    }
}

public extension Yelp.Route {

    var path: String {
        switch self {
        case .restaurant(let id): "businesses/\(id)"
        case .restaurantReviews(let id): "businesses/\(id)/reviews"
        case .search: "businesses/search"
        }
    }

    var httpMethod: HttpMethod { .get }

    var headers: [String: String]? { nil }

    var formParams: [String: String]? { nil }

    var postData: Data? { nil }
    
    var queryParams: [String: String]? {
        switch self {
        case .restaurant: nil
        case .restaurantReviews: nil
        case .search(let params): params.queryParams
        }
    }
}
