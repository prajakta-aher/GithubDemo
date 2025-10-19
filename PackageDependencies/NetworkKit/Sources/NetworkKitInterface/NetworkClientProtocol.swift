import Foundation

public protocol NetworkClientProtocol: Sendable {
    func execute<ResponseType: Decodable>(
        request: Request<ResponseType>,
        responseheaderName: String?
    ) async throws -> (response: ResponseType, responseHeader: String?)
}
