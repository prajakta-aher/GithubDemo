import XCTest
import NetworkKitMocks
@testable import UserDetailsDomainLayer

final class UsersListRepositoryFactoryTests: XCTestCase {
    var netwokClient: NetworkClientMock!
    var sut: UsersListRepositoryFactory!

    override func setUp() {
        super.setUp()
        netwokClient = NetworkClientMock()
        sut = UsersListRepositoryFactory(networkClient: netwokClient)
    }

    override func tearDown() {
        sut = nil
        netwokClient = nil
        super.tearDown()
    }

    func testMakeRepository_whenExecuted_returnsFactoryOfCorrectType() {
        let repository = sut.makeRepository()
        XCTAssertTrue(repository is UsersListRepository)
    }
}
