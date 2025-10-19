import Foundation

@MainActor
public protocol UsersListRepositoryFactoryProtocol {
    func makeRepository() -> UsersListRepositoryProtocol
}
