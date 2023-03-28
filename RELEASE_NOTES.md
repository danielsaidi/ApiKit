# Release Notes

ApiKit will use semver after 1.0. 

Until then, deprecated features may be removed in the next minor version.



## 0.1

### ✨ New Features

* `ApiRequestData` is a new protocol that is implemented by both `ApiEnvironment` and `ApiRoute`.

### 💡 Behavior Changes

* Data from both the `ApiEnvironment` and the `ApiRoute` will be used when creating the request.



## 0.1

This is the first public release of ApiKit.

### ✨ New Features

* You can create `ApiEnvironment` and `ApiRoute` implementations and use them with `ApiClient`.
* `URLSession` implements `ApiClient` so you don't need a custom implementation
