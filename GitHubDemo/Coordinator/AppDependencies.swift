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
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            encoder.keyEncodingStrategy = .convertToSnakeCase
            mockNetworkClient.responseData = try? encoder.encode(
                mockObj
            )
            client = mockNetworkClient
        } else {
            client = NetworkApiClientFactory().makeNetworkApiClient()
        }
        return client
    }
}
