import Foundation
import NetworkKitInterface

public final class NetworkClientMock: NetworkClientProtocol, @unchecked Sendable { // can create new instance per testcase to support parallel tests
    public var pathToResponse: [String: Data] = [:]
    public var responseHeader: String?
    public private(set) var executeCallsCount: Int = 0

    public init(pathToResponse: [String: Data] = [:]) {
        self.pathToResponse = pathToResponse
    }

    public func execute<Response: Decodable>(
        request: Request<Response>,
        responseheaderName: String?
    ) async throws -> (response: Response, responseHeader: String?) {
        executeCallsCount += 1
        guard let path = request.urlRequest?.url?.path() else {
            throw ServiceError.urlMalformed
        }
        if let data = pathToResponse[path] {
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
