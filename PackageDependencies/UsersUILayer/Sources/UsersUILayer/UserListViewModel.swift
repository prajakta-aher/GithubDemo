import Foundation
import Combine
import UserDetailsDomainLayerInterface

public enum UserListViewState {
    case initial
    case error(message: String)
    case loaded(list: [UserUIModel], hasMoreRecords: Bool)
}

@MainActor
public protocol UserListViewModelProtocol: ObservableObject {
    var viewState: UserListViewState { get }
    var searchText: String { get set }
    func loadUsers()
    func loadNextUsers()
}

final class UserListViewModel: UserListViewModelProtocol {
    // MARK: Private properties

    private let repository: UsersListRepositoryProtocol
    private var searchSubscription: AnyCancellable?
    private var task: Task<Void, Never>?

    // MARK: Public properties

    @Published var viewState: UserListViewState
    @Published var searchText: String = "ios"

    // MARK: Initializer

    init(repository: UsersListRepositoryProtocol) {
        self.repository = repository
        viewState = .initial
        bindSearchTextPublisher()
    }

    deinit {
        task?.cancel()
        task = nil
    }

    // MARK: Private methods
    
    private func bindSearchTextPublisher() {
        searchSubscription = $searchText
            .dropFirst() // the first list is loaded in onAppear
            .removeDuplicates() // do not send request if the search query has not changed
            .debounce(for: 0.5, scheduler: DispatchQueue.main)
            .sink(receiveValue: { [weak self] text in
                guard let self = self else { return }
                self.task?.cancel() // cancel previous search query
                self.task = self.loadList(for: text, loadFunction: self.repository.loadUsersList(searchQuery:))
            })
    }

    @discardableResult
    private func loadList(
        for searchText: String,
        loadFunction: @escaping ((
            String
        ) async throws -> UsersListApiModel?)
    ) -> Task<Void, Never>? {
        guard !searchText.isEmpty else { return nil }
    
        return Task { [weak self] in
            guard let self = self else { return }
            guard !Task.isCancelled else { return }
            do {
                let apiModel = try await loadFunction(self.searchText)
                guard !Task.isCancelled else { return }

                let uiModels: [UserUIModel] = apiModel?.items.map {
                    UserUIModel(
                        id: $0.id,
                        imageUrl: URL(
                            string: $0.imageUrlString
                        ),
                        name: $0.name
                    )
                } ?? []
                self.viewState = .loaded(list: uiModels, hasMoreRecords: apiModel?.nextPage != nil)
            } catch {
                self.viewState = .error(message: "Error occured while loading users")
            }
        }
    }

    // MARK: UserListViewModelProtocol

    func loadUsers() {
        loadList(for: self.searchText, loadFunction: repository.loadUsersList(searchQuery:))
    }
    
    func loadNextUsers() {
        loadList(for: self.searchText, loadFunction: repository.loadNextUsersList(searchQuery:))
    }
}
