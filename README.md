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

ApiKit builds on the basic concept of environments and routes and provides lightweight types that make it easy to integrate with any REST-based APIs.

ApiKit has lightweight `ApiEnvironment` and `ApiRoute` protocols that make it easy to model any REST-based API. It also has an `ApiRequest` that can define a route and response type, for even easier use.

Once you have an environment and routes, you can use a regular `URLSession` or a custom `ApiClient` to fetch any route or request from any environment.



## Installation

ApiKit can be installed with the Swift Package Manager:

```
https://github.com/danielsaidi/ApiKit.git
```

If you prefer to not have external dependencies, you can also just copy the source code into your app.



## Getting Started

In short, this is how you could model the [Yelp](https://yelp.com) v3 API evironment, as well as a restaurant fetch route:

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
        case .v3(let token):
            ["Authorization": "Bearer \(token)"]
        }
    }
    
    var queryParams: [String: String]? {
        [:]
    }
}

enum YelpRoute: ApiRoute {

    case restaurant(id: String)

    var path: String {
        switch self {
        case .restaurant(let id): "businesses/\(id)"
        }
    }

    var httpMethod: HttpMethod { .get }
    var headers: [String: String]? { nil }
    var formParams: [String: String]? { nil }
    var postData: Data? { nil }
    
    var queryParams: [String: String]? {
        switch self {
        case .restaurant: nil
        }
    }
}
```

We must also define `Codable` models to map data from the API:

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

We can now fetch data from the Yelp API, using `URLSession` or any custom ``ApiClient``:

```swift
let client = URLSession.shared
let environment = YelpEnvironment.v3(apiToken: "TOKEN") 
let route = YelpRoute.restaurant(id: "abc123") 
let restaurant: YelpRestaurant = try await client.fetchItem(
    at: route, 
    in: environment
)
```

We can also define a `ApiRequest` to avoid having to define routes and return types:

```swift
struct YelpRestaurantRequest: ApiRequest {

    typealias ResponseType = YelpRestaurant

    let id: String

    var route: ApiRoute { 
        YelpRoute.restaurant(id: id)
    }
}
``` 

With this request, fetching data is even easier:

```swift
let request = YelpRestaurantRequest(id: "abc123") 
let restaurant = try await client.fetch(
    at: request, in: environment)
```

For more information, please see the [getting started guide][Getting-Started].



## Documentation

The [online documentation][Documentation] has more information, code examples, etc.



## Demo Application

The demo app lets you explore the library on iOS and macOS. To try it out, just open and run the `Demo` project.



## Support my work 

You can [sponsor me][Sponsors] on GitHub Sponsors or [reach out][Email] for paid support, to help support my [open-source projects][GitHub].



## Contact

Feel free to reach out if you have questions or want to contribute in any way:

* Website: [danielsaidi.com][Website]
* Mastodon: [@danielsaidi@mastodon.social][Mastodon]
* Twitter: [@danielsaidi][Twitter]
* E-mail: [daniel.saidi@gmail.com][Email]



## License

ApiKit is available under the MIT license. See the [LICENSE][License] file for more info.



[Email]: mailto:daniel.saidi@gmail.com
[Website]: https://www.danielsaidi.com
[GitHub]: https://www.github.com/danielsaidi
[Twitter]: https://www.twitter.com/danielsaidi
[Mastodon]: https://mastodon.social/@danielsaidi
[Sponsors]: https://github.com/sponsors/danielsaidi

[Documentation]: https://danielsaidi.github.io/ApiKit/documentation/apikit/
[Getting-Started]: https://danielsaidi.github.io/ApiKit/documentation/apikit/getting-started
[License]: https://github.com/danielsaidi/ApiKit/blob/master/LICENSE
