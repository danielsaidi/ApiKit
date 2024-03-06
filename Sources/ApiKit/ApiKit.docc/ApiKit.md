# ``ApiKit``

ApiKit is a Swift SDK that helps you integrate with external REST APIs.


## Overview

![Library logotype](Logo.png)

ApiKit is a Swift SDK that helps you integrate with external REST APIs.

ApiKit has lightweight ``ApiEnvironment`` and ``ApiRoute`` protocols that make it easy to model any REST-based API. It also has an ``ApiRequest`` that can define a route and response type for even easier use.

Once you have an environment and routes, you can use a regular `URLSession` or a custom ``ApiClient`` to fetch any route or request from any environment.



## Installation

ApiKit can be installed with the Swift Package Manager:

```
https://github.com/danielsaidi/ApiKit.git
```



## Getting started

The <doc:Getting-Started> article helps you get started with ApiKit.



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
- ``ApiRequestData``
- ``ApiResult``

### HTTP

- ``HttpMethod``

### Integrations

- ``TheMovieDb``
- ``Yelp``
