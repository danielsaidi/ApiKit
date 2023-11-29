<p align="center">
    <img src ="Resources/Logo_GitHub.png" alt="ApiKit Logo" title="ApiKit" />
</p>

<p align="center">
    <img src="https://img.shields.io/github/v/release/danielsaidi/ApiKit?color=%2300550&sort=semver" alt="Version" title="Version" />
    <img src="https://img.shields.io/badge/swift-5.9-orange.svg" alt="Swift 5.9" title="Swift 5.9" />
    <img src="https://img.shields.io/github/license/danielsaidi/ApiKit" alt="MIT License" title="MIT License" />
    <a href="https://twitter.com/danielsaidi"><img src="https://img.shields.io/twitter/url?label=Twitter&style=social&url=https%3A%2F%2Ftwitter.com%2Fdanielsaidi" alt="Twitter: @danielsaidi" title="Twitter: @danielsaidi" /></a>
    <a href="https://mastodon.social/@danielsaidi"><img src="https://img.shields.io/mastodon/follow/000253346?label=mastodon&style=social" alt="Mastodon: @danielsaidi@mastodon.social" title="Mastodon: @danielsaidi@mastodon.social" /></a>
</p>


## About ApiKit

ApiKit provides lightweight ``ApiEnvironment`` and ``ApiRoute`` protocols that make it easy to integrate with any REST-based APIs.

With ApiKit, you just have to define one or multiple environments and routes, and can then start fetching data with the standard `URLSession` or a custom client implementation.



## Installation

ApiKit can be installed with the Swift Package Manager:

```
https://github.com/danielsaidi/ApiKit.git
```

If you prefer to not have external dependencies, you can also just copy the source code into your app.



## Getting Started

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

With the environment, routes and models in place, we can now fetch data from the Yelp API.

We can use `URLSession.shared` directly, or any custom ``ApiClient`` implementation:

```swift
let client = URLSession.shared
let environment = YelpEnvironment.v3(apiToken: "TOKEN") 
let route = YelpRoute.restaurant(id: "abc123") 
let restaurant: YelpRestaurant = try await client.fetchItem(at: route, in: environment)
```

The client will fetch the raw data and either return the mapped result, or throw an error.



## Documentation

The [online documentation][Documentation] has more information, code examples, etc., and lets you overview the various parts of the library.



## Demo Application

The demo app lets you explore the library on iOS and macOS. To try it out, just open and run the `Demo` project.



## Support my work

I manage many open-source projects on my spare time and am very thankful for any help to keep my work going. 

You can sponsor my work on [GitHub Sponsors][Sponsors] or get in touch for paid support.



## Contact

Feel free to reach out if you have questions or if you want to contribute in any way:

* Website: [danielsaidi.com][Website]
* Mastodon: [@danielsaidi@mastodon.social][Mastodon]
* Twitter: [@danielsaidi][Twitter]
* E-mail: [daniel.saidi@gmail.com][Email]



## License

ApiKit is available under the MIT license. See the [LICENSE][License] file for more info.



[Email]: mailto:daniel.saidi@gmail.com
[Website]: https://www.danielsaidi.com
[Twitter]: https://www.twitter.com/danielsaidi
[Mastodon]: https://mastodon.social/@danielsaidi
[Sponsors]: https://github.com/sponsors/danielsaidi

[Documentation]: https://danielsaidi.github.io/ApiKit/documentation/apikit/
[Getting-Started]: https://danielsaidi.github.io/ApiKit/documentation/apikit/getting-started
[License]: https://github.com/danielsaidi/ApiKit/blob/master/LICENSE
