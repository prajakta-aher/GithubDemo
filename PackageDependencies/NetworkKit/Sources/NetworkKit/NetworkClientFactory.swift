import Foundation
import NetworkKitInterface

public struct NetworkApiClientFactory: NetworkApiClientFactoryProtocol {
    public init() {}

    private var customDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }

    public func makeNetworkApiClient() -> NetworkClientProtocol {
        return NetworkClient(jsonDecoder: customDecoder, urlSession: URLSession.shared)
    }
}
