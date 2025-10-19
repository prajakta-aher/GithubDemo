import XCTest
import NetworkKitMocks
@testable import UserDetailsDomainLayer

final class UsersRepositoryFactoryTests: XCTestCase {
    var netwokClient: NetworkClientMock!
    var sut: UsersRepositoryFactory!

    @MainActor
    private func makeSut() {
        super.setUp()
        netwokClient = NetworkClientMock()
        sut = UsersRepositoryFactory(baseUrlString: "some", networkClient: netwokClient)
    }

    override func tearDown() {
        sut = nil
        netwokClient = nil
        super.tearDown()
    }

    @MainActor
    func testMakeRepository_whenExecuted_returnsFactoryOfCorrectType() {
        makeSut()
        let repository = sut.makeListRepository()
        XCTAssertTrue(repository is UsersListRepository)
    }
}
