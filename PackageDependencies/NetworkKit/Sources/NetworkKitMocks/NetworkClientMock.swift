import Foundation
import NetworkKitInterface

public final class NetworkClientMock: NetworkClientProtocol {
    public var responseData: Data?
    public var responseHeader: String?
    public private(set) var executeCallsCount: Int = 0

    public init(responseData: Data? = nil) {
        self.responseData = responseData
    }

    public func execute<Response: Decodable>(
        request: Request<Response>,
        responseheaderName: String?
    ) async throws -> (response: Response, responseHeader: String?) {
        executeCallsCount += 1
        if let data = responseData {
            // Should be ideally injected, but not required for this example
            return (
                try JSONDecoder().decode(Response.self, from: data),
                responseHeader
            )
        } else {
            throw ServiceError.responseDecodingError(errorDescription: nil)
        }
    }
}
