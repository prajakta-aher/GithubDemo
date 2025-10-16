import Foundation

/// URLSession protocol for dependency injection and testability
public protocol URLSessionProtocol {
    func data(for request: URLRequest, delegate: (any URLSessionTaskDelegate)?) async throws -> (Data, URLResponse)
}
