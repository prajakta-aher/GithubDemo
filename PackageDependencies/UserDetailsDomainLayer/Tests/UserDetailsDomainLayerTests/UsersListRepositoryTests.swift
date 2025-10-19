import XCTest
import NetworkKitMocks
import UserDetailsDomainLayerInterface
@testable import UserDetailsDomainLayer

final class UsersListRepositoryTests: XCTestCase {
    private var networkClient: NetworkClientMock!
    private var sut: UsersListRepository!
    private let jsonEncoder: JSONEncoder = JSONEncoder()
    
    @MainActor
    private func makeSut() {
        networkClient = NetworkClientMock()
        sut = UsersListRepository(baseUrlString: "someApi", networkClient: networkClient)
    }

    override func tearDown() {
        sut = nil
        networkClient = nil
    }

    @MainActor
    func testGetNextPage_whenContainsNextPage_thenReturnsNextPageNumber() {
        makeSut()
        let linkHeader = #"""
            <https://api.github.com/repositories/1300192/issues?per_page=2&page=2>; rel="next", <https://api.github.com/repositories/1300192/issues?per_page=2&page=7715>; rel="last"
            """#
        let nextPage = UsersListRepository.getNextPage(
            linkHeader: linkHeader
        )
        XCTAssertEqual(nextPage, "2")
    }
    
    @MainActor
    func testGetNextPage_whenDoesNotContainsNextPage_thenReturnsNil() {
        makeSut()
        let linkHeader = #"""
            <https://api.github.com/repositories/1300192/issues?per_page=2&page=7715>; rel="last"
            """#
        let nextPage = UsersListRepository.getNextPage(
            linkHeader: linkHeader
        )
        XCTAssertNil(nextPage)
    }
    
    @MainActor
    func testGetNextPage_whenNextPageInvalid_thenReturnsNil() {
        makeSut()
        let linkHeader = #"""
            <https://api.github.com/repositories/1300192/issues?per_page=2&page=a>; rel="next"
            """#
        let nextPage = UsersListRepository.getNextPage(
            linkHeader: linkHeader
        )
        XCTAssertNil(nextPage)
    }
    
    @MainActor
    func testLoadUsersList_whenCalled_returnsCorrectApiModelAndNextPage() async throws {
        makeSut()
        let items = [
            UserItemApiModel(
                id: "id1",
                name: "iOS_Dev",
                imageUrlString: ""
            )
        ]
        networkClient.responseData = try? jsonEncoder.encode(
            UsersListApiModel(
                items: items
            )
        )
        networkClient.responseHeader = #"""
            <https://api.github.com/repositories/1300192/issues?per_page=2&page=2>; rel="next", <https://api.github.com/repositories/1300192/issues?per_page=2&page=7715>; rel="last"
            """#
        let actualApiModel = try await sut.loadUsersList(searchQuery: "iOS_Dev")
        XCTAssertEqual(
            UsersListApiModel(items: items, nextPage: "2"),
            actualApiModel
        )
        XCTAssertEqual(networkClient.executeCallsCount, 1)
    }
    
    @MainActor
    func testLoadUsersList_whenCalledWithoutLinkHeader_returnsCorrectApiModel() async throws {
        makeSut()
        let expectedApiModel = UsersListApiModel(
            items: [
                UserItemApiModel(
                    id: "id1",
                    name: "iOS_Dev",
                    imageUrlString: ""
                )
            ]
        )
        networkClient.responseData = try? jsonEncoder.encode(
            expectedApiModel
        )
        networkClient.responseHeader = nil
        let actualApiModel = try await sut.loadUsersList(searchQuery: "iOS_Dev")
        XCTAssertEqual(
            expectedApiModel,
            actualApiModel
        )
    }
    
    @MainActor
    func testLoadNextUsersList_whenCalledWithNoNextPage_returnsNil() async throws {
        makeSut()
        let items = [
            UserItemApiModel(
                id: "id1",
                name: "iOS_Dev",
                imageUrlString: ""
            )
        ]
        networkClient.responseData = try? jsonEncoder.encode(
            UsersListApiModel(
                items: items
            )
        )
        networkClient.responseHeader = nil
        _ = try await sut.loadUsersList(searchQuery: "iOS_Dev")
        let nextModel = try await sut.loadNextUsersList(searchQuery: "iOS_Dev")
        XCTAssertNil(nextModel)
    }

    @MainActor
    func testLoadNextUsersList_whenCalledWithNextPage_returnsCorrectApiModel() async throws {
        makeSut()
        let items1 = [
            UserItemApiModel(
                id: "id1",
                name: "iOS_Dev1",
                imageUrlString: "imag1"
            )
        ]
        let items2 = [
            UserItemApiModel(
                id: "id2",
                name: "iOS_Dev2",
                imageUrlString: "imag2"
            )
        ]

        networkClient.responseData = try? jsonEncoder.encode(
            UsersListApiModel(
                items: items1
            )
        )
        networkClient.responseHeader = #"""
            <https://api.github.com/repositories/1300192/issues?per_page=2&page=2>; rel="next", <https://api.github.com/repositories/1300192/issues?per_page=2&page=7715>; rel="last"
            """#
        _ = try await sut.loadUsersList(searchQuery: "iOS_Dev")
        XCTAssertEqual(networkClient.executeCallsCount, 1)
        
        networkClient.responseData = try? jsonEncoder.encode(
            UsersListApiModel(
                items: items2
            )
        )
        networkClient.responseHeader = nil
        
        let nextModel = try await sut.loadNextUsersList(searchQuery: "iOS_Dev")
        XCTAssertEqual(
            nextModel,
            UsersListApiModel(
                items: items1 + items2
            )
        )
        XCTAssertEqual(networkClient.executeCallsCount, 2)
    }
}
