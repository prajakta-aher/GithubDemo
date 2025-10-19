import Foundation
import NetworkKitInterface
import UserDetailsDomainLayerInterface

public final class UsersRepositoryFactory: UsersRepositoryFactoryProtocol {
    private let networkClient: NetworkClientProtocol
    private let baseUrlString: String

    public init(baseUrlString: String, networkClient: NetworkClientProtocol) {
        self.networkClient = networkClient
        self.baseUrlString = baseUrlString
    }

    public func makeListRepository() -> UsersListRepositoryProtocol {
        UsersListRepository(baseUrlString: baseUrlString, networkClient: networkClient)
    }

    public func makeDetailsRepository() -> any UsersDetailsRepositoryProtocol {
        UserDetailsRepository(baseUrlString: baseUrlString, networkClient: networkClient)
    }
}
