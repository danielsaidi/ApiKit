# Release Notes

ApiKit will use semver after 1.0. 

Until then, deprecated features may be removed in the next minor version.



## 0.2

### ✨ New Features

* `ApiRequestData` is a new protocol that is implemented by both `ApiEnvironment` and `ApiRoute`.
* `ApiEnvironment` and `ApiRoute` can now define custom headers.

### 💡 Behavior Changes

* All request data is now optional to simplify defining it in your environments and routes.
* URL requests will by default combine data from both the `ApiEnvironment` and the `ApiRoute`.

### 💥 Breaking Changes

* Query and form parameters are now optional.



## 0.1

This is the first public release of ApiKit.

### ✨ New Features

* You can create `ApiEnvironment` and `ApiRoute` implementations and use them with `ApiClient`.
* `URLSession` implements `ApiClient` so you don't need a custom implementation
