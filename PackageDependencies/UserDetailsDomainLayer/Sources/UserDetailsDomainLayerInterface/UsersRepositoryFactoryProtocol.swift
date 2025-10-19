import Foundation

@MainActor
public protocol UsersRepositoryFactoryProtocol {
    func makeListRepository() -> UsersListRepositoryProtocol
    func makeDetailsRepository() -> UsersDetailsRepositoryProtocol
}
