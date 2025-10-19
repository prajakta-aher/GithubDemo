import XCTest
import Combine
import UserDetailsDomainLayerInterface
import UserDetailsDomainLayerMocks
@testable import UsersUILayer

final class UserListViewModelTests: XCTestCase {
    private var repository: UsersListRepositoryMock!
    private var sut: UserListViewModel!
    private var cancellables: Set<AnyCancellable>!
    @MainActor
    private func makeSut(debounceDelay: TimeInterval = 0) {
        cancellables = Set<AnyCancellable>()
        repository = UsersListRepositoryMock()
        sut = UserListViewModel(repository: repository, debounceDelay: debounceDelay)
    }
    
    override func tearDown() {
        cancellables.removeAll()
        cancellables = nil
        repository = nil
        sut = nil
    }

    @MainActor
    func testLoadUsers_whenReturnsList_thenReturnsLoadedState() {
        // Given
        let expectation = expectation(description: "View state must be correct")
        expectation.expectedFulfillmentCount = 2
        var viewStates: [UserListViewState] = []
        makeSut()
        sut.$viewState
            .sink { state in
                viewStates.append(state)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        repository.loadUsersListResponse = UsersListApiModel(
            items: [
                UserItemApiModel(
                    id: "id",
                    name: "user1",
                    imageUrlString: ""
                )
            ],
            nextPage: "2"
        )
        // When
        sut.loadUsers()
        // Then
        wait(for: [expectation])
        XCTAssertEqual(
            viewStates,
            [
                .initial,
                .loaded(
                    list: [
                        UserUIModel(
                            id: "id",
                            imageUrl: nil,
                            name: "user1"
                        )
                    ],
                    hasMoreRecords: true,
                    errorMessage: nil
                )
            ],
            "loadUser should return view model"
        )
        XCTAssertEqual(
            repository.loadUsersListRequests,
            ["ios"]
        )
    }

    @MainActor
    func testLoadUsers_whenThrowsError_thenReturnsErrorState() {
        // Given
        let expectation = expectation(description: "View state must be correct")
        expectation.expectedFulfillmentCount = 2
        var viewStates: [UserListViewState] = []
        makeSut()
        sut.$viewState
            .sink { state in
                viewStates.append(state)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        repository.loadUsersListError = NSError(domain: "Testing", code: 3)
        // When
        sut.loadUsers()
        // Then
        wait(for: [expectation])
        XCTAssertEqual(
            viewStates,
            [
                .initial,
                .error(message: "Error occured while loading users")
            ],
            "loadUser should return view model"
        )
        XCTAssertEqual(
            repository.loadUsersListRequests,
            ["ios"]
        )
    }

    @MainActor
    func testLoadNextUsers_whenReturnsList_thenReturnsLoadedState() {
        // Given
        let expectation = expectation(description: "View state must be correct")
        expectation.expectedFulfillmentCount = 2
        var viewStates: [UserListViewState] = []
        makeSut()
        sut.$viewState
            .sink { state in
                viewStates.append(state)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        repository.loadNextUsersListResponse = UsersListApiModel(
            items: [
                UserItemApiModel(
                    id: "id",
                    name: "user1",
                    imageUrlString: ""
                )
            ],
            nextPage: "2"
        )
        // When
        sut.loadNextUsers()
        // Then
        wait(for: [expectation])
        XCTAssertEqual(
            viewStates,
            [
                .initial,
                .loaded(
                    list: [
                        UserUIModel(
                            id: "id",
                            imageUrl: nil,
                            name: "user1"
                        )
                    ],
                    hasMoreRecords: true,
                    errorMessage: nil
                )
            ],
            "loadUser should return view model"
        )
        XCTAssertEqual(
            repository.loadUsersListNextRequests,
            ["ios"],
            "load request should sent correct search query in requests"
        )
    }

    @MainActor
    func testLoadNextUsers_whenStateInitialThrowsError_thenReturnsErrorState() {
        // Given
        let expectation = expectation(description: "View state must be correct")
        expectation.expectedFulfillmentCount = 2
        var viewStates: [UserListViewState] = []
        makeSut()
        sut.$viewState
            .sink { state in
                viewStates.append(state)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        repository.loadNextUsersListError = NSError(domain: "Testing", code: 3)
        // When
        sut.loadNextUsers()
        // Then
        wait(for: [expectation])
        XCTAssertEqual(
            viewStates,
            [
                .initial,
                .error(message: "Error occured while loading users")
            ],
            "loadUser should return view model"
        )
        XCTAssertEqual(
            repository.loadUsersListNextRequests,
            ["ios"],
            "load request should sent correct search query in requests"
        )
    }

    @MainActor
    func testSearchTextChanges_whenChanges_thenSearchesAfterDebounce() async throws {
        // Given
        let expectation = expectation(description: "View state must be correct")
        expectation.expectedFulfillmentCount = 4
        var viewStates: [UserListViewState] = []
        makeSut(debounceDelay: 0.1)
        // Mock response for the load all records request
        repository.loadUsersListResponse = UsersListApiModel(
            items: [
                UserItemApiModel(
                    id: "id",
                    name: "user1",
                    imageUrlString: ""
                )
            ],
            nextPage: "2"
        )

        sut.$viewState
            .sink { state in
                viewStates.append(state)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        sut.searchText = "t"
        try await Task.sleep(nanoseconds: 2_00_000_000) // wait for 0.2 for the search request sent + completed
        XCTAssertEqual(
            repository.loadUsersListRequests,
            ["t"]
        )
        sut.searchText = "te"
        XCTAssertEqual(
            repository.loadUsersListRequests,
            ["t"]
        )
        repository.loadUsersListResponse = UsersListApiModel(
            items: [
                UserItemApiModel(
                    id: "id",
                    name: "user1",
                    imageUrlString: ""
                )
            ],
            nextPage: "2"
        )
        sut.searchText = "test"
        try await Task.sleep(nanoseconds: 2_00_000_000) // wait for 0.2 for the search request sent + completed
        
        repository.loadUsersListError = NSError(domain: "Error", code: 3)
        sut.searchText = "test1"
        try await Task.sleep(nanoseconds: 2_00_000_000) // wait for 0.2 for the search request sent + completed

        await fulfillment(of: [expectation])
        XCTAssertEqual(
            viewStates,
            [
                .initial,
                .loaded(
                    list: [
                        UserUIModel(
                            id: "id",
                            imageUrl: nil,
                            name: "user1"
                        )
                    ],
                    hasMoreRecords: true,
                    errorMessage: nil
                ),
                .loaded(
                    list: [
                        UserUIModel(
                            id: "id",
                            imageUrl: nil,
                            name: "user1"
                        )
                    ],
                    hasMoreRecords: true,
                    errorMessage: nil
                ),
                .loaded(
                    list: [
                        UserUIModel(
                            id: "id",
                            imageUrl: nil,
                            name: "user1"
                        )
                    ],
                    hasMoreRecords: true,
                    errorMessage: "Error occured while loading users"
                )
            ],
            "search requests should send correct results in viewData"
        )
        XCTAssertEqual(
            repository.loadUsersListRequests,
            ["t", "test", "test1"],
            "load request should send correct search query in requests"
        )
    }
}
