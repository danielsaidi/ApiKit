<p align="center">
    <img src ="Resources/Logo_GitHub.png" alt="ApiKit Logo" title="ApiKit" width=600 />
</p>

<p align="center">
    <img src="https://img.shields.io/github/v/release/danielsaidi/ApiKit?color=%2300550&sort=semver" alt="Version" title="Version" />
    <img src="https://img.shields.io/badge/swift-5.7-orange.svg" alt="Swift 5.7" title="Swift 5.7" />
    <img src="https://img.shields.io/github/license/danielsaidi/ApiKit" alt="MIT License" title="MIT License" />
    <a href="https://twitter.com/danielsaidi">
        <img src="https://img.shields.io/twitter/url?label=Twitter&style=social&url=https%3A%2F%2Ftwitter.com%2Fdanielsaidi" alt="Twitter: @danielsaidi" title="Twitter: @danielsaidi" />
    </a>
    <a href="https://mastodon.social/@danielsaidi">
        <img src="https://img.shields.io/mastodon/follow/000253346?label=mastodon&style=social" alt="Mastodon: @danielsaidi@mastodon.social" title="Mastodon: @danielsaidi@mastodon.social" />
    </a>
</p>


## About ApiKit

ApiKit is a Swift library that makes it easy to integrate with any external REST APIs.

ApiKit has an ``ApiClient`` protocol that can fetch any ``URLRequest`` and decode the data to any `Decodable` type. It's implemented by `URLSession` so you can either use `URLSession.shared` or create your own custom service.

ApiKit has an `ApiEnvironment` and `ApiRoute` model that can be used to model the available environments and routes for any REST API, such as the base URL of a certain API environment, the URL of a certain route, which parameters and headers to send etc. 

Any `ApiClient` can then fetch any `ApiRoute` from any `ApiEnvironment` and automatically have the result decoded to any `Decodable` type.



## Installation

ApiKit can be installed with the Swift Package Manager:

```
https://github.com/danielsaidi/ApiKit.git
```

If you prefer to not have external dependencies, you can also just copy the source code into your app.



## Supported Platforms

ApiKit supports `iOS 13`, `macOS 11`, `tvOS 13` and `watchOS 6`.



## Getting started

Implementing API integrations with ApiKit is very easy. You can either fetch raw `URLRequest`s and handle the raw data, or create custom `ApiEnvironment` and `ApiRoute` types to model various APIs.

For instance, with a TheMovieDb-specific environment:

```swift
enum TheMovieDbEnvironment: ApiEnvironment {

    case production(apiKey: String)

    public var url: String {
        switch self {
        case .production: return "https://api.themoviedb.org/3"
        }
    }

    public var headers: [String: String]? { nil }

    public var queryParams: [String: String]? {
        switch self {
        case .production(let key): return ["api_key": key]
        }
    }
}
```

and a TheMovieDb-specific route:

```swift
enum Route: ApiRoute {

    case movie(id: Int)
    
    public var path: String {
        switch self {
        case .movie(let id): return "movie/\(id)"
        }
    }

    public var queryParams: [String: String]? {
        switch self {
        case .movie: return nil
        }
    }

    public var httpMethod: HttpMethod { .get }
    public var headers: [String: String]? { nil }
    public var formParams: [String: String]? { nil }
    public var postData: Data? { nil }
}
```

we could easily fetch movies like this:   

```
let client = URLSession.shared
let environment = TheMovieDb.Environment.production("API_KEY") 
let route = TheMovieDb.Route.movie(id: 123) 
let movie: TheMovieDb.Movie = try await client.fetchItem(at: route, in: environment)
```

For more information, please see the [online documentation][Documentation] and [getting started guide][Getting-Started] guide. 



## Documentation

The [online documentation][Documentation] contains more information, code examples, etc., and makes it easy to overview the various parts of the library.



## Demo Application

The demo app lets you explore the library on iOS and macOS. To try it out, just open and run the `Demo` project.



## Support

You can sponsor this project on [GitHub Sponsors][Sponsors] or get in touch for paid support.



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
