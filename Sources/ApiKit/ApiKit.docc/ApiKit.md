# ``ApiKit``

ApiKit helps you integrate with external REST APIs.


## Overview

![Library logotype](Logo.png)

ApiKit has an ``ApiClient`` protocol that can fetch any `URLRequest` and decode the response to any `Decodable` type. It's implemented by `URLSession` so you can either use `URLSession.shared` or create your own service.

ApiKit has ``ApiEnvironment`` and ``ApiRoute`` models that can be used to model any REST API, such as the base URL of a certain API environment, the URL of a certain route, which parameters and headers to send etc. 

An ``ApiClient`` can then be used to fetch any ``ApiRoute`` from any ``ApiEnvironment`` and return a typed result.



## Installation

ApiKit can be installed with the Swift Package Manager:

```
https://github.com/danielsaidi/ApiKit.git
```

If you prefer to not have external dependencies, you can also just copy the source code into your app.



## Getting started

The <doc:Getting-Started> article has a guide to help you get started with RichTextKit.



## Repository

For more information, source code, an if you want to report issues, sponsor the project etc., visit the [project repository](https://github.com/danielsaidi/ApiKit).



## License

ApiKit is available under the MIT license. See the [LICENSE][License] file for more info.



## Topics

### Essentials

- <doc:Getting-Started>
- ``ApiClient``
- ``ApiEnvironment``
- ``ApiRoute``

### Foundation

- ``ApiRequestData``
- ``ApiError``
- ``ApiResult``

### HTTP

- ``HttpMethod``

### Integrations

- ``TheMovieDb``
