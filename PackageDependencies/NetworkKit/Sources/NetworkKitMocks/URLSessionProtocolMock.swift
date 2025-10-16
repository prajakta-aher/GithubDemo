import Foundation
import NetworkKitInterface

public final class URLSessionProtocolMock: URLSessionProtocol {
    public var mockData: Data
    public var httpUrlResponse: HTTPURLResponse
    public var error: ServiceError?

    public init(
        mockData: Data = .init(),
        httpUrlResponse: HTTPURLResponse = .init(),
        error: ServiceError? = nil
    ) {
        self.mockData = mockData
        self.httpUrlResponse = httpUrlResponse
        self.error = error
    }

    public func data(for request: URLRequest, delegate: (any URLSessionTaskDelegate)?) async throws -> (Data, URLResponse) {
        if let error = error {
            throw error
        } else {
            return (mockData, httpUrlResponse)
        }
    }
}
