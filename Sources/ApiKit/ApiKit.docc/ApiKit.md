# ``ApiKit``

ApiKit helps you integrate with any external REST API.


## Overview

![Library logotype](Logo.png)

ApiKit has lightweight ``ApiEnvironment`` and ``ApiRoute`` protocols that make it easy to model any REST-based API.

ApiKit also has an ``ApiRequest`` that can be used to define a `route` and its response type, for even easier usage. 

Once you have your environment and routes defined, you can use a regular `URLSession` or custom client to fetch any route from any environment. 



## Installation

ApiKit can be installed with the Swift Package Manager:

```
https://github.com/danielsaidi/ApiKit.git
```

If you prefer to not have external dependencies, you can also just copy the source code into your app.



## Getting started

The <doc:Getting-Started> article helps you get started with ApiKit.



## Repository

For more information, source code, etc., visit the [project repository][Repository].



## License

ApiKit is available under the MIT license. See the [LICENSE][License] file for more info.



## Topics

### Articles

- <doc:Getting-Started>

### Essentials

- ``ApiEnvironment``
- ``ApiRoute``
- ``ApiClient``
- ``ApiError``
- ``ApiRequestData``
- ``ApiResult``

### HTTP

- ``HttpMethod``

### Integrations

- ``TheMovieDb``
- ``Yelp``



[License]: https://github.com/danielsaidi/ApiKit/blob/master/LICENSE
[Repository]: https://github.com/danielsaidi/ApiKit
