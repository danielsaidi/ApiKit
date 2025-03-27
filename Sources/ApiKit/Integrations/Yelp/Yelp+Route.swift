//
//  Yelp+Route.swift
//  ApiKit
//
//  Created by Daniel Saidi on 2023-08-17.
//  Copyright © 2023-2025 Daniel Saidi. All rights reserved.
//

import Foundation

public extension Yelp {

    /// This type defines supported Yelp API routes.
    enum Route: ApiRoute {
        
        public typealias Restaurant = Yelp.Restaurant
        public typealias RestaurantReviewsResult = Yelp.RestaurantReviewsResult
        public typealias RestaurantSearchResult = Yelp.RestaurantSearchResult

        case restaurant(id: String)
        case restaurantReviews(restaurantId: String)
        case search(params: Yelp.RestaurantSearchParams)
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
    
    var returnType: Any? {
        switch self {
        case .restaurant: Restaurant.self
        case .restaurantReviews: RestaurantReviewsResult.self
        case .search: RestaurantSearchResult.self
        }
    }
}
