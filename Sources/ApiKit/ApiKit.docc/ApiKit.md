# ``ApiKit``

ApiKit is a Swift SDK that helps you integrate with any REST API.


## Overview

![Library logotype](Logo.png)

ApiKit defines an ``ApiClient`` protocol that describes how to request raw and typed data from any REST-based API. This protocol is implemented by ``Foundation/URLSession``, so you can use the shared session without having to create a custom client.    

ApiKit defines ``ApiEnvironment`` and ``ApiRoute`` protocols that make it easy to model and integrate with any REST-based API, as well as an ``ApiRequest`` that can define a route and response type for even easier use.



## Installation

ApiKit can be installed with the Swift Package Manager:

```
https://github.com/danielsaidi/ApiKit.git
```



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
