import Foundation

public protocol NetworkClientProtocol {
    func execute<ResponseType: Decodable>(request: Request<ResponseType>) async throws -> ResponseType
}
