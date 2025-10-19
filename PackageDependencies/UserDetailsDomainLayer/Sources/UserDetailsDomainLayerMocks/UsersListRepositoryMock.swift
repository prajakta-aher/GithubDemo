import UserDetailsDomainLayerInterface

/// Can be @unchecked Sendable sicne we create a new object for each test and hence can be used in parallel tests also
public final class UsersListRepositoryMock: UsersListRepositoryProtocol, @unchecked Sendable {
    public var loadUsersListResponse: UsersListApiModel = .init(items: [])
    public var loadUsersListError: Error?
    public private(set) var executedLoadUsersList: Int = 0
    public private(set) var loadUsersListRequests: [String] = []

    public var loadNextUsersListResponse: UsersListApiModel = .init(items: [])
    public var loadNextUsersListError: Error?
    public private(set) var executedLoadNextUsersList: Int = 0
    public private(set) var loadUsersListNextRequests: [String] = []

    public init() {}

    public func loadUsersList(searchQuery: String) async throws -> UsersListApiModel {
        executedLoadUsersList += 1
        loadUsersListRequests.append(searchQuery)
        if let loadUsersListError {
            throw loadUsersListError
        } else {
            return loadUsersListResponse
        }
    }
    
    public func loadNextUsersList(searchQuery: String) async throws -> UsersListApiModel? {
        executedLoadNextUsersList += 1
        loadUsersListNextRequests.append(searchQuery)
        if let loadNextUsersListError {
            throw loadNextUsersListError
        } else {
            return loadNextUsersListResponse
        }
    }
}
