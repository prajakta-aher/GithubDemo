import SwiftUI

struct UserListView<ViewProtocol: UserListViewModelProtocol>: View {
    @ObservedObject private var viewModel: ViewProtocol
    
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
                            width: 50,
                            height: 50,
                            alignment: .center
                        )
                case .error(let message):
                    Color.clear
                        .alert(
                            message,
                            isPresented: .constant(true),
                            actions: {}
                        )
                case let .loaded(list, hasMoreRecords, errorMessage):
                    List {
                        ForEach(list, id: \.id) { user in
                            UserRowView(userModel: user)
                        }
                        if hasMoreRecords {
                            ProgressView()
                                .frame(maxWidth: .infinity)
                                .onAppear {
                                    viewModel.loadNextUsers()
                                }
                        }
                    }
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
            .navigationTitle("Users List")
            .searchable(text: $viewModel.searchText)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#if DEBUG
final class MockViewModel: UserListViewModelProtocol {
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
    init() {}
}
#endif
#Preview {
    UserListView(viewModel: MockViewModel())
}

