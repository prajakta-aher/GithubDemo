import NetworkKitInterface
import NetworkKit
import UserDetailsDomainLayerInterface
import NetworkKitMocks
import Foundation

struct AppDependencies {
    static let shared = AppDependencies()
    func getNetworkClient() -> NetworkClientProtocol {
        var client: NetworkClientProtocol
        if ProcessInfo.processInfo.arguments.contains(
            "UITesting"
        ) {
            let mockNetworkClient = NetworkClientMock()
            let mockObj = UsersListApiModel(
                items: [
                    UserItemApiModel(
                        id: "id1",
                        name: "name",
                        imageUrlString: ""
                    )
                ]
            )
            let mockDetails = UserDetailApiModel(
                id: "id",
                name: "name",
                followers: 10,
                publicRepositories: 2,
                imageUrlString: String()
            )
            let encoder = JSONEncoder()
            mockNetworkClient.pathToResponse["/search/users"] = try? encoder.encode(
                mockObj
            )
            mockNetworkClient.pathToResponse["/users/name"] = try? encoder.encode(
                mockDetails
            )
            client = mockNetworkClient
        } else {
            client = NetworkApiClientFactory().makeNetworkApiClient()
        }
        return client
    }
}
