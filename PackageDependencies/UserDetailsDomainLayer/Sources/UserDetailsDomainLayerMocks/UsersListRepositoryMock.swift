import UserDetailsDomainLayerInterface

final class UsersListRepositoryMock: UsersListRepositoryProtocol {
    public var loadUsersListResponse: UsersListApiModel = .init(items: [])
    public private(set) var executedLoadUsersList: Int = 0
    public private(set) var loadUsersListRequests: [String] = []

    public var loadNextUsersListResponse: UsersListApiModel = .init(items: [])
    public private(set) var executedLoadNextUsersList: Int = 0
    public private(set) var loadUsersListNextRequests: [String] = []

    func loadUsersList(searchQuery: String) async throws -> UsersListApiModel {
        executedLoadUsersList += 1
        loadUsersListRequests.append(searchQuery)
        return loadUsersListResponse
    }
    
    func loadNextUsersList(searchQuery: String) async throws -> UsersListApiModel? {
        executedLoadNextUsersList += 1
        loadUsersListNextRequests.append(searchQuery)
        return loadNextUsersListResponse
    }
}
