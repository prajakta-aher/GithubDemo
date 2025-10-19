import SwiftUI

struct UserListView<ViewProtocol: UserListViewModelProtocol>: View {
    @ObservedObject private var viewModel: ViewProtocol
    
    // MARK: Nested views
    enum AccessibilityIdentifiers: String {
        case content = "user_list_content_view"
        case list = "user_list_scrollable_list"
        case fullScreenProgress = "user_list_full_screen_progress_view"
        case fullScreenError = "user_list_alert_empty_screen"
        case searchBar = "user_list_search_bar"
    }

    // MARK: Initializer
    init(viewModel: ViewProtocol) {
        self.viewModel = viewModel
    }

    var body: some View {
        NavigationStack {
            VStack {
                switch viewModel.viewState {
                case .initial:
                    ProgressView()
                        .frame(
                            width: SpacingConstants.iconWidth,
                            height: SpacingConstants.iconHeight,
                            alignment: .center
                        )
                        .accessibilityIdentifier(AccessibilityIdentifiers.fullScreenProgress.rawValue)
                case .error(let message):
                    Color.clear
                        .alert(
                            message,
                            isPresented: .constant(true),
                            actions: {}
                        )
                        .accessibilityIdentifier(AccessibilityIdentifiers.fullScreenError.rawValue)
                case let .loaded(list, hasMoreRecords, errorMessage):
                    List {
                        ForEach(list, id: \.id) { user in
                            UserRowView(userModel: user)
                                .onTapGesture {
                                    viewModel.selectedUser(userName: user.name)
                                }
                        }
                        if hasMoreRecords {
                            ProgressView()
                                .frame(maxWidth: .infinity)
                                .onAppear {
                                    viewModel.loadNextUsers()
                                }
                        }
                    }
                    .listStyle(.plain)
                    .accessibilityIdentifier(AccessibilityIdentifiers.list.rawValue)
                    .alert(
                        errorMessage ?? "",
                        isPresented: .constant(errorMessage != nil),
                        actions: {}
                    )
                }
            }
            .onAppear {
                viewModel.loadUsers()
            }
            .navigationTitle(viewModel.title)
            .searchable(text: $viewModel.searchText)
            .accessibilityIdentifier(AccessibilityIdentifiers.searchBar.rawValue)
            .navigationBarTitleDisplayMode(.inline)
        }
        .accessibilityIdentifier(AccessibilityIdentifiers.content.rawValue)
    }
}

#if DEBUG
final class MockUserListViewModel: UserListViewModelProtocol {
    var title: String = "Users List"
    @Published var viewState: UserListViewState = .initial
    @Published var searchText: String = ""

    func loadUsers() {
        viewState = .loaded(
            list: [
                UserUIModel(
                    id: "id0",
                    imageUrl: nil,
                    name: "User 0"
                )
            ],
            hasMoreRecords: true,
            errorMessage: nil
        )
    }
    
    func loadNextUsers() {
        viewState = .loaded(
            list: (0..<10).map {
                UserUIModel(
                    id: "id\($0)",
                    imageUrl: nil,
                    name: "User \($0)"
                )
            },
            hasMoreRecords: false,
            errorMessage: nil
        )
    }
    
    func selectedUser(userName: String) {}

    init() {}
}
#endif
#Preview {
    UserListView(viewModel: MockUserListViewModel())
}

