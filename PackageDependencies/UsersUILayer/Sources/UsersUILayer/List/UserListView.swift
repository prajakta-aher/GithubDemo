import SwiftUI
import UIUtilities

struct UserListView<ViewProtocol: UserListViewModelProtocol>: View {
    // Observed object instead of @StateObject since lifecycle managed by ViewController
    @ObservedObject private var viewModel: ViewProtocol

    // MARK: Initializer
    init(viewModel: ViewProtocol) {
        self.viewModel = viewModel
    }

    var body: some View {
        NavigationStack {
            VStack {
                switch viewModel.viewState {
                case .emptyState:
                    emptyStateView
                        .accessibilityIdentifier(UsersListAccessibilityIdentifiers.fullScreenProgress.rawValue)
                case .error(let message):
                    Color.clear
                        .alert(
                            message,
                            isPresented: .constant(true),
                            actions: {}
                        )
                        .accessibilityIdentifier(UsersListAccessibilityIdentifiers.fullScreenError.rawValue)
                case let .loaded(list, hasMoreRecords, errorMessage):
                    listContentView(
                        list: list,
                        hasMoreRecords: hasMoreRecords,
                        errorMessage: errorMessage
                    )
                }
            }
            .onAppear {
                viewModel.loadUsers()
            }
            .navigationTitle(viewModel.title)
            // searchable needs navigation stack, but UIKit navigation + coordinators are used for navigating to other screens
            .searchable(text: $viewModel.searchText)
            .accessibilityIdentifier(UsersListAccessibilityIdentifiers.searchBar.rawValue)
            .navigationBarTitleDisplayMode(.inline)
        }
        .accessibilityIdentifier(UsersListAccessibilityIdentifiers.content.rawValue)
    }

    @ViewBuilder
    private var emptyStateView: some View {
        Image(systemName: "magnifyingglass")
            .font(
                .system(
                    size: .init(
                        SpacingConstants.iconWidth
                    )
                )
            )
            .foregroundColor(.gray)

        Text(viewModel.emptyStateMessage)
            .font(.body)
            .fontWeight(.light)
    }
    
    @ViewBuilder
    private func listContentView(
        list: [UserUIModel],
        hasMoreRecords: Bool,
        errorMessage: String?
    ) -> some View {
        List {
            ForEach(list, id: \.id) { user in
                UserRowView(userModel: user)
                    .accessibilityIdentifier(UsersListAccessibilityIdentifiers.row.rawValue)
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
        .accessibilityIdentifier(UsersListAccessibilityIdentifiers.list.rawValue)
        .alert(
            errorMessage ?? "",
            isPresented: .constant(errorMessage != nil),
            actions: {}
        )
    }
}

#if DEBUG
final class MockUserListViewModel: UserListViewModelProtocol {
    var title: String {
        "Users List"
    }
    var emptyStateMessage: String {
        "Find GitHub Users. Enter a username to search."
    }
    @Published var viewState: UserListViewState = .emptyState
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

