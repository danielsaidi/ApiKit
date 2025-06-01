# ``ApiKit``

ApiKit is a Swift SDK that helps you integrate with any REST API.


## Overview

![Library logotype](Logo.png)

ApiKit is a Swift library that makes it easy to integrate with any REST API and map its response models to Swift types. It defines an ``ApiClient`` that can request data from any API, as well as ``ApiEnvironment`` & ``ApiRoute`` protocols that make it easy to model any API. 

The ``ApiClient`` protocol is already implemented by ``URLSession``, so you can use ``URLSession.shared`` directly, without having to create a custom client implementation.


## Installation

ApiKit can be installed with the Swift Package Manager:

```
https://github.com/danielsaidi/ApiKit.git
```


## Support My Work

By [becoming a sponsor][Sponsors], you directly support the development and continuous improvements of my various [open-source projects][OpenSource].


## Getting started

Once you have one or several ``ApiEnvironment`` and ``ApiRoute`` values for the API you want to integrate with, you can easily perform requests with any ``ApiClient`` or ``Foundation/URLSession``:

```swift
let client = URLSession.shared
let environment = MyEnvironment.production(apiToken: "TOKEN")
let route = MyRoutes.user(id: "abc123") 
let user: ApiUser = try await client.request(at: route, in: environment)
```

The generic, typed functions will automatically map the raw response to the type you requested, and throw any raw errors that occur. There are also non-generic variants that can be used if you want to provide custom error handling.

See the <doc:Getting-Started> article for more information on how to define environments and routes.


## Repository

For more information, source code, etc., visit the [project repository](https://github.com/danielsaidi/ApiKit).


## License

ApiKit is available under the MIT license.


## Topics

### Articles

- <doc:Getting-Started>

### Essentials

- ``ApiEnvironment``
- ``ApiRoute``
- ``ApiClient``
- ``ApiError``
- ``ApiRequest``
- ``ApiResult``

### HTTP

- ``HttpMethod``

### Integrations

- ``TheMovieDb``
- ``Yelp``


[Email]: mailto:daniel.saidi@gmail.com
[Website]: https://danielsaidi.com
[GitHub]: https://github.com/danielsaidi
[OpenSource]: https://danielsaidi.com/opensource
[Sponsors]: https://github.com/sponsors/danielsaidi
