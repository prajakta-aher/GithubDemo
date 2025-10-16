import Foundation
import NetworkKitInterface

public final class NetworkClientMock: NetworkClientProtocol {
    public var responseData: Data?

    public init(responseData: Data? = nil) {
        self.responseData = responseData
    }

    public func execute<Response: Decodable>(
        request: Request<Response>
    ) async throws -> Response {
        if let data = responseData {
            // Should be ideally injected, but not required for this example
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(Response.self, from: data)
        } else {
            throw ServiceError.responseDecodingError(errorDescription: nil)
        }
    }
}
