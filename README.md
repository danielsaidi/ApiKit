<p align="center">
    <img src ="Resources/Logo_Rounded.png" alt="ApiKit Logo" title="ApiKit" />
</p>

<p align="center">
    <img src="https://img.shields.io/github/v/release/danielsaidi/ApiKit?color=%2300550&sort=semver" alt="Version" title="Version" />
    <img src="https://img.shields.io/badge/swift-6.0-orange.svg" alt="Swift 6.0" />
    <img src="https://img.shields.io/github/license/danielsaidi/ApiKit" alt="MIT License" title="MIT License" />
    <a href="https://twitter.com/danielsaidi"><img src="https://img.shields.io/twitter/url?label=Twitter&style=social&url=https%3A%2F%2Ftwitter.com%2Fdanielsaidi" alt="Twitter: @danielsaidi" title="Twitter: @danielsaidi" /></a>
    <a href="https://mastodon.social/@danielsaidi"><img src="https://img.shields.io/mastodon/follow/000253346?label=mastodon&style=social" alt="Mastodon: @danielsaidi@mastodon.social" title="Mastodon: @danielsaidi@mastodon.social" /></a>
</p>


## About ApiKit

ApiKit is a Swift SDK that helps you integrate with any REST API.

ApiKit defines an ``ApiClient`` protocol that describes how to request raw and typed data from any REST API. The protocol is implemented by ``URLSession``, so you can use the shared session without having to create a client.

ApiKit defines ``ApiEnvironment`` & ``ApiRoute`` protocols that make it easy to model API environments and routes, as well as an ``ApiRequest`` that can define a route and response type for even easier use.



## Installation

ApiKit can be installed with the Swift Package Manager:

```
https://github.com/danielsaidi/ApiKit.git
```



## Getting Started

Consider that you want to integrate with the Yelp API, which can return restaurants, reviews, etc.

You would first define the various API environments you want to integrate with. In this case, let's just integrate with the `v3` environment, which requires an API header token for all requests:

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
}
```

We can then define the routes to request from the Yelp API. In this case, let's just fetch a business by ID:

```swift
import ApiKit

enum YelpRoute: ApiRoute {

    case business(id: String)

    var path: String {
        switch self {
        case .business(let id): "businesses/\(id)"
        }
    }

    var httpMethod: HttpMethod { .get }
    var headers: [String: String]? { nil }
    var formParams: [String: String]? { nil }
    var postData: Data? { nil }
    
    var queryParams: [String: String]? {
        switch self {
        case .business: nil
        }
    }
}
``` 

With the environment and route in place, we can fetch a `YelpBusiness` with any ``ApiClient`` or ``URLSession``:

```swift
let client = URLSession.shared
let environment = YelpEnvironment.v3(apiToken: "YOUR_TOKEN")
let route = YelpRoute.business(id: "abc123") 
let business: YelpBusiness = try await client.request(route, in: environment)
```

The generic request functions will automatically map the raw response to the requested type, and throw any raw errors that occur. There are also non-generic variants if you want to get the raw data or use custom error handling.

See the online [getting started guide][Getting-Started] for more information.



## Documentation

The online [documentation][Documentation] has more information, articles, code examples, etc.



## Demo Application

The `Demo` folder has an app that lets you explore the library and integrate with a few APIs.



## Support my work 

You can [sponsor me][Sponsors] on GitHub Sponsors or [reach out][Email] for paid support, to help support my [open-source projects][OpenSource].

Your support makes it possible for me to put more work into these projects and make them the best they can be.



## Contact

Feel free to reach out if you have questions or want to contribute in any way:

* Website: [danielsaidi.com][Website]
* Mastodon: [@danielsaidi@mastodon.social][Mastodon]
* Twitter: [@danielsaidi][Twitter]
* E-mail: [daniel.saidi@gmail.com][Email]



## License

ApiKit is available under the MIT license. See the [LICENSE][License] file for more info.



[Email]: mailto:daniel.saidi@gmail.com

[Website]: https://danielsaidi.com
[GitHub]: https://github.com/danielsaidi
[Twitter]: https://twitter.com/danielsaidi
[Mastodon]: https://mastodon.social/@danielsaidi
[OpenSource]: https://danielsaidi.com/opensource
[Sponsors]: https://github.com/sponsors/danielsaidi

[Documentation]: https://danielsaidi.github.io/ApiKit
[Getting-Started]: https://danielsaidi.github.io/ApiKit/documentation/apikit/getting-started

[License]: https://github.com/danielsaidi/ApiKit/blob/master/LICENSE
