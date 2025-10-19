import XCTest
import NetworkKitMocks
@testable import UserDetailsDomainLayer

final class UsersListRepositoryFactoryTests: XCTestCase {
    var netwokClient: NetworkClientMock!
    var sut: UsersListRepositoryFactory!

    @MainActor
    private func makeSut() {
        super.setUp()
        netwokClient = NetworkClientMock()
        sut = UsersListRepositoryFactory(baseUrlString: "some", networkClient: netwokClient)
    }

    override func tearDown() {
        sut = nil
        netwokClient = nil
        super.tearDown()
    }

    @MainActor
    func testMakeRepository_whenExecuted_returnsFactoryOfCorrectType() {
        makeSut()
        let repository = sut.makeRepository()
        XCTAssertTrue(repository is UsersListRepository)
    }
}
