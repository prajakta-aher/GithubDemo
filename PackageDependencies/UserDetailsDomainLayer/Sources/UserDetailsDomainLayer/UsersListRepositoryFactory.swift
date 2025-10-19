import Foundation
import NetworkKitInterface
import UserDetailsDomainLayerInterface

public final class UsersListRepositoryFactory: UsersListRepositoryFactoryProtocol {
    private let networkClient: NetworkClientProtocol
    private let baseUrlString: String

    public init(baseUrlString: String, networkClient: NetworkClientProtocol) {
        self.networkClient = networkClient
        self.baseUrlString = baseUrlString
    }

    public func makeRepository() -> UsersListRepositoryProtocol {
        UsersListRepository(baseUrlString: baseUrlString, networkClient: networkClient)
    }
}
