# Getting Started

This article explains how to get started with ApiKit.


## Overview

ApiKit builds on the basic concept of API environments and routes and provides lightweight ``ApiEnvironment`` and ``ApiRoute`` types that make it easy to integrate with any REST-based APIs.

With ApiKit, you just have to define one or multiple environments and routes, and can then start fetching data with the standard `URLSession` or a custom client implementation. 


## API environments

An ``ApiEnvironment`` refers to a specific API version or environment, and can define a URL as well as global request headers and query parameters.

For instance, the [Yelp](https://yelp.com) v3 API could be defined like this:

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

The environment above requires that all request sends an API token as header, while other APIs may require them to be sent as query parameters instead. This type is flexible to support different requirements.


## API routes

An ``ApiRoute`` refers to endpoints within an API, and can define an HTTP method and path, custom headers, query parameters, post data, etc.

For instance, the [Yelp](https://yelp.com) v3 API routes can be specified like this:

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

The routes above use associated values to provide an item ID in the path, and search parameters as query parameters.  


## How to define API models

We also have to define `Codable` Yelp-specific models to be able to map data from the API.

For instance, this is a super lightweight Yelp restaurant model:

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

The `id` and `name` parameters use the same name as in the API, while the `imageUrl` requires custom mapping.


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
