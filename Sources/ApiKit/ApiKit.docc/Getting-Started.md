# Getting Started

This article explains how to get started with ApiKit.

@Metadata {
    
    @PageImage(
        purpose: card,
        source: "Page"
    )

    @PageColor(blue)
}



## Overview

ApiKit defines an ``ApiClient`` protocol that describes how to request raw and typed data from any REST-based API. This protocol is implemented by ``Foundation/URLSession``, so you can use the shared session without having to create a custom client.

Once you have one or several ``ApiEnvironment`` and ``ApiRoute`` values for the API you want to integrate with, you can easily perform requests with any ``ApiClient`` or ``Foundation/URLSession``:

```swift
let client = URLSession.shared
let environment = MyEnvironment.production(apiToken: "TOKEN")
let route = MyRoutes.user(id: "abc123") 
let user: ApiUser = try await client.request(at: route, in: environment)
```

The generic, typed functions will automatically map the raw response to the type you requested, and throw any raw errors that occur. There are also non-generic variants that can be used if you want to provide custom error handling. 



## API Environments

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

This API requires that all requests send the API token as a custom header. Other APIs may require it to be sent as a query parameter, or have no such requirements at all. ApiKit is flexible to support all different kinds of requirements.



## API Routes

An ``ApiRoute`` refers to an endpoint within an API. It defines an HTTP method, an environment-relative path, custom headers, query parameters, post data, etc. and will generate a proper URL request for a certain ``ApiEnvironment``.

For instance, this is a [Yelp](https://yelp.com) v3 API route that defines how to fetch and search for restaurants:

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

The routes above use associated values to apply a restaurant ID to the request path, and search parameters as query parameters.  



## API models

We can also define codable API-specific value types to let the ``ApiClient`` automatically map the raw response data to these types.

For instance, this is a lightweight Yelp restaurant model:

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



## How to fetch data

We can now fetch data from the Yelp API, using ``Foundation/URLSession`` or any custom ``ApiClient``:

```swift
let client = URLSession.shared
let environment = YelpEnvironment.v3(apiToken: "TOKEN") 
let route = YelpRoute.restaurant(id: "abc123") 
let restaurant: YelpRestaurant = try await client.request(at: route, in: environment)
```

The client will fetch the raw data and either return the mapped result, or throw an error.



## How to fetch data even easier

We can define an ``ApiRequest`` to avoid having to define routes and return types every time:

```swift
struct YelpRestaurantRequest: ApiRequest {

    typealias ResponseType = YelpRestaurant

    let id: String

    var route: ApiRoute { 
        YelpRoute.restaurant(id: id)
    }
}
```

We can then use `URLSession` or a custom ``ApiClient`` to fetch requests without having to specify the route or return type:

```swift
let client = URLSession.shared
let environment = YelpEnvironment.v3(apiToken: "TOKEN") 
let request = YelpRestaurantRequest(id: "abc123") 
let restaurant = try await client.fetch(request, from: environment)
```

This involves creating more types, but is easier to manage in larger projects. 
