//
//  Yelp+Models.swift
//  ApiKit
//
//  Created by Daniel Saidi on 2023-08-17.
//  Copyright © 2023 Daniel Saidi. All rights reserved.
//

import Foundation

public extension Yelp {

    struct Restaurant: Codable {
        
        public let id: String
        public let alias: String?
        public let name: String?
        public let imageUrl: String?
        public let isClosed: Bool?
        public let url: String?
        public let reviewCount: Int?
        public let categories: [RestaurantCategory]
        public let rating: Double?
        public let location: RestaurantLocation
        public let coordinates: RestaurantCoordinates
        public let photos: [String]?
        public let price: String?
        public let hours: [RestaurantHours]?
        public let phone: String?
        public let displayPhone: String?
        public let distance: Double?
        
        enum CodingKeys: String, CodingKey {
            case id
            case alias
            case name
            case imageUrl = "image_url"
            case isClosed = "is_closed"
            case url
            case reviewCount = "review_count"
            case categories
            case rating
            case location
            case coordinates
            case photos
            case price
            case hours
            case phone
            case displayPhone = "display_phone"
            case distance
        }
    }
    
    struct RestaurantCategory: Codable {
        
        public let title: String
    }
    
    struct RestaurantCoordinates: Codable {
        
        public let latitude: Double?
        public let longitude: Double?
    }

    struct RestaurantHour: Codable {
        
        public let isOvernight: Bool
        public let start: String
        public let end: String
        public let day: Int
        
        enum CodingKeys: String, CodingKey {
            case isOvernight = "is_overnight"
            case start
            case end
            case day
        }
    }
    
    struct RestaurantHours: Codable {
        
        public let type: String
        public let isOpenNow: Bool
        public let open: [RestaurantHour]
        
        enum CodingKeys: String, CodingKey {
            case type = "hours_type"
            case isOpenNow = "is_open_now"
            case open
        }
    }
    
    struct RestaurantLocation: Codable {
        
        public let displayAddress: [String]
        
        enum CodingKeys: String, CodingKey {
            case displayAddress = "display_address"
        }
    }
    
    struct RestaurantReview: Codable {
        
        public let id: String
        public let url: String?
        public let text: String?
        public let rating: Double?
        public let user: RestaurantReviewUser
    }
    
    struct RestaurantReviewUser: Codable {
        
        public let id: String
        public let name: String?
        public let imageUrl: String?
        
        enum CodingKeys: String, CodingKey {
            case id
            case name
            case imageUrl = "image_url"
        }
    }
    
    struct ReviewResult: Codable {
        
        public let reviews: [RestaurantReview]
    }
    
    struct SearchParams {
        
        public init(
            skip: Int,
            take: Int,
            radius: Int,
            coordinate: (lat: Double, long: Double)? = nil,
            budgetLevels: [BudgetLevel] = [],
            openingHours: OpeningHours = .showAll
        ) {
            self.skip = skip
            self.take = take
            self.radius = radius
            self.coordinate = coordinate
            self.budgetLevels = budgetLevels
            self.openingHours = openingHours
        }
        
        public enum BudgetLevel: String {
            case level1 = "1"
            case level2 = "2"
            case level3 = "3"
            case level4 = "4"
        }
        
        public enum OpeningHours: String {
            case openNow
            case showAll
        }
        
        public let skip: Int
        public let take: Int
        public let radius: Int
        public let coordinate: (lat: Double, long: Double)?
        public let budgetLevels: [BudgetLevel]
        public let openingHours: OpeningHours
        
        public var queryParams: [String: String] {
            var params: [String: String] = [
                "categories": "restaurants",
                "radius": "\(radius)",
                "offset": "\(skip)",
                "limit": "\(take)"
            ]
            
            if let coord = coordinate {
                params["latitude"] = "\(coord.lat)"
                params["longitude"] = "\(coord.long)"
            }
            
            if !budgetLevels.isEmpty {
                params["price"] = Set(budgetLevels)
                    .map { $0.rawValue }
                    .joined(separator: ",")
            }
            
            if openingHours == .openNow {
                params["open_now"] = "true"
            }
            
            return params
        }
    }
    
    struct SearchResult: Codable {
        
        public let businesses: [Restaurant]
    }
}
