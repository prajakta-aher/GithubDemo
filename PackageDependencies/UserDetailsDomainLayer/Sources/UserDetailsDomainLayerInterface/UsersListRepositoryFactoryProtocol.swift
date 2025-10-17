import Foundation

public protocol UsersListRepositoryFactoryProtocol {
    func makeRepository() -> UsersListRepositoryProtocol
}
