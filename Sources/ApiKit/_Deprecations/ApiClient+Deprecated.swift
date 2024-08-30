import Foundation

public extension ApiClient {

    @available(*, deprecated, renamed: "request")
    func fetch(
        _ request: URLRequest
    ) async throws -> ApiResult {
        try await self.request(request)
    }

    @available(*, deprecated, renamed: "request(_:in:)")
    func fetch(
        _ route: ApiRoute,
        in environment: ApiEnvironment
    ) async throws -> ApiResult {
        try await request(route, in: environment)
    }

    @available(*, deprecated, renamed: "request(with:)")
    func fetchItem<T: Decodable>(
        with request: URLRequest
    ) async throws -> T {
        try await self.request(with: request)
    }

    @available(*, deprecated, renamed: "request(at:in:)")
    func fetchItem<T: Decodable>(
        at route: ApiRoute,
        in environment: ApiEnvironment
    ) async throws -> T {
        try await self.request(at: route, in: environment)
    }
}
