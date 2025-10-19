import Foundation
import Combine

public protocol UsersListRepositoryProtocol: Sendable {
    func loadUsersList(searchQuery: String) async throws -> UsersListApiModel
    func loadNextUsersList(searchQuery: String) async throws -> UsersListApiModel? // current might be last page
}
