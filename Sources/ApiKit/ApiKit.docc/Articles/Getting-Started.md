# Getting Started

ScrollKit is a SwiftUI library that adds powerful scrolling features to SwiftUI, such as offset tracking and sticky scroll header views.


## Overview

Implementing API integrations with ApiKit is very easy. You can either fetch raw `URLRequest`s and handle the raw data, or create custom ``ApiEnvironment`` and ``ApiRoute`` types to model various APIs.

For instance, this code defines  ``ApiEnvironment`` and ``ApiRoute``, where the environment defines how to send the API key as a query parameter, and the route defines how to fetch movies:

```
struct TheMovieDb {

    enum Environment: ApiEnvironment {

        case production(apiKey: String)

        public var url: String {
            switch self {
            case .production: return "https://api.themoviedb.org/3"
            }
        }

        public var headers: [String : String]? { nil }

        public var queryParams: [String : String]? {
            switch self {
            case .production(let key): return ["api_key": key]
            }
        }
    }

    enum Route: ApiRoute {

        case movie(id: Int)
        
        public var path: String {
            switch self {
            case .movie(let id): return "movie/\(id)"
            }
        }

        public var queryParams: [String : String]? {
            switch self {
            case .movie: return nil
            }
        }

        public var httpMethod: HttpMethod {
            switch self {
                case .movie: return .get
            }
        }

        public var headers: [String : String]? { nil }

        public var formParams: [String : String]? { nil }

        public var postData: Data? { nil }
    }

    struct Movie: Codable, Identifiable {
        public let id: Int
        public let title: String
    }
}
```

We can then use `URLSession.shared` (or any ``ApiClient``) to fetch and parse movies by ID:

```swift
let client = URLSession.shared
let environment = TheMovieDb.Environment.production("API_KEY") 
let route = TheMovieDb.Route.movie(id: 123) 
let movie: TheMovieDb.Movie = try await client.fetchItem(at: route, in: environment)
```

Future versions may improve this further to make it even easier.
