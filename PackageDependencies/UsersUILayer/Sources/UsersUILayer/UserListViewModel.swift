import Foundation
import Combine
import UserDetailsDomainLayerInterface

public enum UserListViewState: Equatable {
    case initial
    case error(message: String)
    case loaded(list: [UserUIModel], hasMoreRecords: Bool, errorMessage: String?)
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

    @Published private(set) var viewState: UserListViewState
    // to limit number of requests on scrolling to next page (rate limiting) - works without default text also
    @Published var searchText: String

    // MARK: Initializer

    init(
        repository: UsersListRepositoryProtocol,
        debounceDelay: TimeInterval = 0.5,
        searchText: String = "ios"
    ) {
        self.searchText = searchText
        self.repository = repository
        viewState = .initial
        bindSearchTextPublisher(debounceDelay: debounceDelay)
    }

    deinit {
        task?.cancel()
        task = nil
    }

    // MARK: Private methods
    
    private func bindSearchTextPublisher(debounceDelay: TimeInterval) {
        searchSubscription = $searchText
            .dropFirst() // the first list is loaded in onAppear
            .removeDuplicates() // do not send request if the search query has not changed
            .debounce(for: .seconds(debounceDelay), scheduler: DispatchQueue.main)
            .sink(
                receiveValue: { [weak self] text in
                    guard let self = self else { return }
                    self.task?.cancel() // cancel previous search query
                    self.task = nil
                    self.task = self.loadList(
                        for: text,
                        preservePreviousResults: true, // keep displaying the old list
                        loadFunction: self.repository.loadUsersList(
                            searchQuery:
                        )
                    )
                }
            )
    }

    @discardableResult
    private func loadList(
        for searchText: String,
        preservePreviousResults: Bool,
        loadFunction: @escaping ((
            String
        ) async throws -> UsersListApiModel?)
    ) -> Task<Void, Never>? {
        guard !searchText.isEmpty else { return nil }
    
        return Task { [weak self] in
            guard let self = self else { return }
            guard !Task.isCancelled else { return }
            do {
                let apiModel = try await loadFunction(searchText)
                let uiModels: [UserUIModel] = apiModel?.items.map {
                    UserUIModel(
                        id: $0.id,
                        imageUrl: URL(
                            string: $0.imageUrlString
                        ),
                        name: $0.name
                    )
                } ?? []
                // Check cancellation before updating state to prevent race conditions
                // when a new search is triggered during data mapping and self is already deallocated
                guard !Task.isCancelled else { return }
                self.viewState = .loaded(list: uiModels, hasMoreRecords: apiModel?.nextPage != nil, errorMessage: nil)
            } catch {
                // Check cancellation before updating state to prevent race conditions
                // when a new search is triggered during data mapping and self is already deallocated
                guard !Task.isCancelled else { return }
                if preservePreviousResults,
                   case let .loaded(list: list, hasMoreRecords: hasNextPage, errorMessage: _) = self.viewState {
                    self.viewState = .loaded(
                        list: list,
                        hasMoreRecords: hasNextPage,
                        errorMessage: "Error occured while loading users"
                    )
                } else {
                    self.viewState = .error(message: "Error occured while loading users")
                }
            }
        }
    }

    // MARK: UserListViewModelProtocol

    func loadUsers() {
        // When the network is slow and till the first list is loaded, user might start typing
        // in some cases like errors, slow response loading the order in which data is loaded might be
        // incorrect
        // cancel tasks to display the results loaded in correct order
        self.task?.cancel()
        self.task = nil
        self.task = loadList(
            for: self.searchText,
            preservePreviousResults: false, // dont have previous results to preserve
            loadFunction: repository.loadUsersList(
                searchQuery:
            )
        )
    }
    
    func loadNextUsers() {
        self.task?.cancel()
        self.task = nil
        self.task = loadList(
            for: self.searchText,
            preservePreviousResults: true, // preserve previously loaded results
            loadFunction: repository.loadNextUsersList(searchQuery:)
        )
    }
}
