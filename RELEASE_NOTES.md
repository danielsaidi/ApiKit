# Release Notes

ApiKit will use semver after 1.0. 

Until then, deprecated features may be removed in the next minor version.



## 0.2

This version adds supports for headers and for the environment to define global headers and query parameters.

### ✨ New Features

* `ApiRequestData` is a new protocol that is implemented by both `ApiEnvironment` and `ApiRoute`.
* `ApiEnvironment` and `ApiRoute` can now define custom headers.

### 💡 Behavior Changes

* All request data is now optional.
* URL request creation is now throwing.
* URL requests will now combine data from the environment and route.

### 💥 Breaking Changes

* `ApiEnvironment` now uses a `String` as url.
* `ApiRequestData` makes the `queryParams` property optional.
* `ApiRoute` makes the `formParams` property optional.



## 0.1

This is the first public release of ApiKit.

### ✨ New Features

* You can create `ApiEnvironment` and `ApiRoute` implementations and use them with `ApiClient`.
* `URLSession` implements `ApiClient` so you don't need a custom implementation
