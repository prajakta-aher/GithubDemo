import Foundation

/// Network API client factory protocol
public protocol NetworkApiClientFactoryProtocol {
    func makeNetworkApiClient() -> NetworkClientProtocol
}
