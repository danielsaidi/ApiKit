# ``ApiKit``

ApiKit is a Swift library that makes it easy to integrate with REST-based web APIs over HTTP.


## Overview

![Library logotype](Logo.png)

ApiKit has an ``ApiClient`` protocol that can fetch any `URLRequest` and decode the data to any `Decodable` type. It's implemented by `URLSession` so you can use `URLSession.shared` directly, or create your own services.

ApiKit also has an ``ApiEnvironment`` and ``ApiRoute`` model that can be used to easily model various APIs and define things, like the HTTP method to use for a certain route, which headers to send etc. Any ``ApiClient`` can then fetch any route from any environment.

See the <doc:Getting-Started> guide for more information and code examples.



## Installation

ApiKit can be installed with the Swift Package Manager:

```
https://github.com/danielsaidi/ApiKit.git
```

If you prefer to not have external dependencies, you can also just copy the source code into your app.



## License

ApiKit is available under the MIT license. See the [LICENSE][License] file for more info.



## Topics

### Articles

- <doc:Getting-Started>

### Foundation

- ``ApiEnvironment``
- ``ApiRoute``
- ``ApiRequestData``
- ``ApiClient``
- ``ApiError``
- ``ApiResult``

### HTTP

- ``HttpMethod``

### Integrations

- ``TheMovieDb``
