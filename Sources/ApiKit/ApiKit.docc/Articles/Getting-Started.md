# Getting Started

This article explains how to get started with ApiKit.


## Overview

ApiKit builds on the basic concept of environments and routes and provides lightweight types that make it easy to integrate with any REST-based APIs.

With ApiKit, you just have to define one or multiple environments and routes, and can then start fetching data with the standard `URLSession` or a custom client implementation. 


## API environments

An ``ApiEnvironment`` refers to a specific API version or environment (prod, staging, etc.), and defines a URL as well as global request headers and query parameters.

For instance, this is a [Yelp](https://yelp.com) v3 API environment, which requires an API token:

```swift
import ApiKit

enum YelpEnvironment: ApiEnvironment {

    case v3(apiToken: String)
    
    var url: String {
        switch self {
        case .v3: "https://api.yelp.com/v3/"
        }
    }
 
    var headers: [String: String]? {
        switch self {
        case .v3(let token): ["Authorization": "Bearer \(token)"]
        }
    }
    
    var queryParams: [String: String]? {
        [:]
    }
}
```

The Yelp API requires that all requests send the API token as a custom header. Other APIs may require it to be sent as a query parameter, or have no token requirement at all. 

ApiKit is flexible and supports many different requirements.


## API routes

An ``ApiRoute`` refers to an endpoint within an API, and defines a HTTP method, an environment-relative path, custom headers, query parameters, post data, etc.

For instance, this is a [Yelp](https://yelp.com) v3 API route, which defines how to fetch and search for restaurants:

```swift
import ApiKit

enum YelpRoute: ApiRoute {

    case restaurant(id: String)
    case search(params: Yelp.SearchParams)

    var path: String {
        switch self {
        case .restaurant(let id): "businesses/\(id)"
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
        case .search(let params): params.queryParams
        }
    }
}
```

The routes above use associated values to provide item ID to the paths, and search parameters as query parameters.  


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

The `id` and `name` parameters use the same name as in the API, while `imageUrl` requires custom mapping.


## How to fetch data from an API

We can now fetch data from the Yelp API, using `URLSession` or any custom ``ApiClient``:

```swift
let client = URLSession.shared
let environment = YelpEnvironment.v3(apiToken: "TOKEN") 
let route = YelpRoute.restaurant(id: "abc123") 
let restaurant: YelpRestaurant = try await client.fetchItem(at: route, in: environment)
```

The client will fetch the raw data and either return the mapped result, or throw an error.


## How to fetch data even easier

We can also define a ``ApiRequest`` to avoid having to define routes and return types every time:

```swift
struct YelpRestaurantRequest: ApiRequest {

    typealias ResponseType = YelpRestaurant

    let id: String

    var route: ApiRoute { 
        YelpRoute.restaurant(id: id)
    }
}
```

We can use `URLSession` or any custom ``ApiClient`` to fetch requests as well:

```swift
let client = URLSession.shared
let environment = YelpEnvironment.v3(apiToken: "TOKEN") 
let request = YelpRestaurantRequest(id: "abc123") 
let restaurant = try await client.fetch(
    at: request, in: environment)
```

As you can see, we don't have to define route and return type when we use requests. 
