import Combine
import Foundation
import NetworkKitInterface
import UserDetailsDomainLayerInterface

final class UsersListRepository: UsersListRepositoryProtocol {
    private var lastState: UsersListApiModel?
    let networkClient: NetworkClientProtocol

    init(networkClient: NetworkClientProtocol) {
        self.networkClient = networkClient
    }

    //link: <https://api.github.com/repositories/1300192/issues?per_page=2&page=2>; rel="next", <https://api.github.com/repositories/1300192/issues?per_page=2&page=7715>; rel="last"
    static func getNextPage(linkHeader: String) -> String? {
        if let nextPageLink = linkHeader.components(separatedBy: ",")
            .first(where: { $0.contains("rel=\"next\"") }),
           let nextPageRange = nextPageLink.range(of: #"&page=(\d+)"#, options: .regularExpression),
           // Check if next page is a valid numeric value
           let nextPageString = nextPageLink[nextPageRange].components(separatedBy: "=").last,
           let nextPage = Int(nextPageString) {
            return "\(nextPage)"
        }
        return nil
    }

    private func loadList(for searchQuery: String, page: String) async throws -> UsersListApiModel {
        var (responseModel, responseHeader) = try await networkClient.execute(
            request: UsersListRequest(
                searchTerm: searchQuery,
                page: page
            ),
            responseheaderName: "Link"
        )
        if let linkHeader = responseHeader {
            responseModel.setNextPage(
                page: Self.getNextPage(
                    linkHeader: linkHeader
                )
            )
        }
        return responseModel
    }

    func loadUsersList(searchQuery: String) async throws -> UsersListApiModel {
        let userList = try await loadList(for: searchQuery, page: "1")
        lastState = userList
        return userList
    }

    func loadNextUsersList(searchQuery: String) async throws -> UsersListApiModel? {
        guard let nextPage = lastState?.nextPage else {
            return nil
        }
        let newUsersList = try await loadList(for: searchQuery, page: nextPage)
        let finalList = UsersListApiModel(
            items: (lastState?.items ?? []) + newUsersList.items,
            nextPage: newUsersList.nextPage
        )
        lastState = finalList
        return finalList
    }
}

final class UsersListRequest: Request<UsersListApiModel> {
    init(searchTerm: String, page: String = "1") {
        super.init(
            scheme: "http",
            baseUrlString: "api.github.com",
            path: "/search/users",
            method: .get,
            queryItems: [
                RequestParamsConstants.apiVersionKey: RequestParamsConstants.apiVersionValue,
                RequestParamsConstants.pageSizeKey: "30",
                "q": searchTerm,
                RequestParamsConstants.pageOffsetKey: page
            ]
        )
    }
}
