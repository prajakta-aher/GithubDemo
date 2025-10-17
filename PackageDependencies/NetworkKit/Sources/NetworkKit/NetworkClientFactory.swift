import Foundation
import NetworkKitInterface

public struct NetworkApiClientFactory: NetworkApiClientFactoryProtocol {
    public init() {}

    private var customDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        return decoder
    }

    public func makeNetworkApiClient() -> NetworkClientProtocol {
        return NetworkClient(jsonDecoder: customDecoder, urlSession: URLSession.shared)
    }
}
