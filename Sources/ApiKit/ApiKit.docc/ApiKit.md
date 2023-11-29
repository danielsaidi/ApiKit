# ``ApiKit``

ApiKit helps you integrate with external REST APIs.


## Overview

![Library logotype](Logo.png)

ApiKit provides lightweight ``ApiEnvironment`` and ``ApiRoute`` protocols that make it easy to integrate with any REST-based APIs.

With ApiKit, you just have to define one or multiple environments and routes, and can then start fetching data with the standard `URLSession` or a custom client implementation. 



## Installation

ApiKit can be installed with the Swift Package Manager:

```
https://github.com/danielsaidi/ApiKit.git
```

If you prefer to not have external dependencies, you can also just copy the source code into your app.



## Getting started

The <doc:Getting-Started> article has a guide to help you get started with ApiKit.



## Repository

For more information, source code, an if you want to report issues, sponsor the project etc., visit the [project repository](https://github.com/danielsaidi/ApiKit).



## About this documentation

The online documentation is currently iOS only. To generate documentation for other platforms, open the package in Xcode, select a simulator then run `Product/Build Documentation`.



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
- ``Yelp``
