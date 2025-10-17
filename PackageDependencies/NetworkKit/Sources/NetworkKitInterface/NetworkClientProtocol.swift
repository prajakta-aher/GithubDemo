import Foundation

public protocol NetworkClientProtocol {
    func execute<ResponseType: Decodable>(
        request: Request<ResponseType>,
        responseheaderName: String?
    ) async throws -> (response: ResponseType, responseHeader: String?)
}
