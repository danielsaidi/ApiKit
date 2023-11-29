# Getting Started

This article explains how to get started with ApiKit.


## Overview

ApiKit provides lightweight ``ApiEnvironment`` and ``ApiRoute`` protocols that make it easy to integrate with any REST-based APIs.

With ApiKit, you just have to define one or multiple environments and routes, and can then start fetching data with the standard `URLSession` or a custom client implementation. 


## How to define API environments

An ``ApiEnvironment`` refers to a specific API version or environment (prod, staging, etc.), and can define a URL as well as global request headers and query parameters.

For instance, this is how you would specify a Yelp v3 API environment, which requires that all request sends an API token as header:

```swift
import ApiKit

enum YelpEnvironment: ApiEnvironment {

    case v3(apiToken: String)
    
    var url: String {
        switch self {
        case .v3: return "https://api.yelp.com/v3/"
        }
    }
 
    var headers: [String: String]? {
        switch self {
        case .v3(let apiToken):
            return ["Authorization": "Bearer \(apiToken)"]
        }
    }
    
    var queryParams: [String: String]? {
        [:]
    }
}
```


## How to define API routes

An ``ApiRoute`` refers to endpoints within an API, and can define HTTP method, an environment-relative path, custom headers, query parameters, post data, etc.

For instance, this is how you would specify some Yelp v3 API routes:

```swift
import ApiKit

public enum YelpRoute: ApiRoute {

    case restaurant(id: String)
    case restaurantReviews(restaurantId: String)
    case search(params: Yelp.SearchParams)

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
```


## How to define API models

We also have to define `Codable` Yelp-specific models to be able to map data from the API.

For instance, this is a super lightweight model that just parses the ID, name and image URL for a restaurant:

```swift
struct YelpRestaurant: Codable {
    
    public let id: String
    public let name: String?
    public let imageUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case imageUrl = "image_url"
    }
}
```


## How to fetch data from an API

With the environment, routes and models in place, we can now fetch data from the Yelp API.

We can use `URLSession.shared` directly, or any custom ``ApiClient`` implementation:

```swift
let client = URLSession.shared
let environment = YelpEnvironment.v3(apiToken: "TOKEN") 
let route = YelpRoute.restaurant(id: "abc123") 
let restaurant: YelpRestaurant = try await client.fetchItem(at: route, in: environment)
```

The client will fetch the raw data and either return the mapped result, or throw an error.
