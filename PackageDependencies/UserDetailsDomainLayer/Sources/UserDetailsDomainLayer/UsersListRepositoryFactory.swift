import Foundation
import NetworkKitInterface
import UserDetailsDomainLayerInterface

final class UsersListRepositoryFactory: UsersListRepositoryFactoryProtocol {
    let networkClient: NetworkClientProtocol

    init(networkClient: NetworkClientProtocol) {
        self.networkClient = networkClient
    }

    func makeRepository() -> UsersListRepositoryProtocol {
        UsersListRepository(networkClient: networkClient)
    }
}
