import Foundation

public protocol UsersDetailsRepositoryProtocol: Sendable {
    func loadDetails(username: String) async throws -> UserDetailApiModel
}
