import XCTest
@testable import UsersUILayer
import ViewInspector

@MainActor
final class UsersListViewTests: XCTestCase {
    func testViewController_whenContainsRecords_displays_list() throws {
        let viewModel = MockUserListViewModel()
        viewModel.loadUsers()
        let sut = UserListView(viewModel: viewModel)

        // Navigate through the actual hierarchy
        let navigationStack = try sut.inspect().navigationStack()
        let vStack = try navigationStack.vStack()

        let list = try vStack.list(0)  // First element in VStack is the List

        XCTAssertNotNil(list)
    }
}
