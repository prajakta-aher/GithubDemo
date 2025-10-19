import Foundation
import NetworkKitInterface
import UserDetailsDomainLayerInterface

/// Repository loads details for the user details screen. Marked with main actor but API requests are executed on background threads
@MainActor
public final class UserDetailsRepository: UsersDetailsRepositoryProtocol {
    private let networkClient: NetworkClientProtocol
    private let baseUrlString: String

    init(baseUrlString: String, networkClient: NetworkClientProtocol) {
        self.networkClient = networkClient
        self.baseUrlString = baseUrlString
    }

    public func loadDetails(username: String) async throws -> UserDetailApiModel {
        try await networkClient.execute(
            request: UserDetailsRequest(baseURlString: baseUrlString, user: username),
            responseheaderName: nil
        )
        .response
    }
}

private final class UserDetailsRequest: Request<UserDetailApiModel> {
    init(baseURlString: String, user: String) {
        super.init(
            scheme: "https",
            baseUrlString: baseURlString,
            path: "/users/\(user)",
            method: .get,
            headers: ["If-None-Match": "etag-value-from-previous-response"] // to prevent rate limiting while testing
        )
    }
}
