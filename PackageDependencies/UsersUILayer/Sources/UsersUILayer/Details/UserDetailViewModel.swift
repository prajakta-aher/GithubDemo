import Foundation
import UserDetailsDomainLayerInterface

public enum UserDetailViewState: Equatable {
    case initial
    case error(message: String)
    case loaded(detail: UserDetailUIModel)
}

@MainActor
public protocol UserDetailViewModelProtocol: ObservableObject {
    var viewState: UserDetailViewState { get }
    var title: String { get }
    func loadDetails()
}

final class UserDetailViewModel: UserDetailViewModelProtocol {
    // MARK: Private properties
    private let repository: UsersDetailsRepositoryProtocol
    private let username: String
    
    // MARK: Public properties
    @Published private(set) var viewState: UserDetailViewState
    var title: String {
        "User Details"
    }
    private let followersTitle = "Followers" // should be localized
    private let repositoriesTitle = "Public repositories" // should be localized

    // MARK: Init
    init(username: String, repository: UsersDetailsRepositoryProtocol) {
        self.username = username
        self.repository = repository
        self.viewState = .initial
    }
    
    func loadDetails() {
        Task { [weak self] in
            guard let self = self else { return }

            do {
                let detailsApiModel = try await self.repository.loadDetails(username: self.username)
                guard !Task.isCancelled else { return }
                self.viewState = .loaded(
                    detail:
                        UserDetailUIModel(
                            id: detailsApiModel.id,
                            imageUrl: URL(string: detailsApiModel.imageUrlString),
                            name: detailsApiModel.name,
                            followers: "\(detailsApiModel.followers) \(self.followersTitle)",
                            publicRepositories: "\(detailsApiModel.publicRepositories) \(self.repositoriesTitle)"
                        )
                )
            } catch {
                guard !Task.isCancelled else { return }
                self.viewState = .error(message: "Error")
            }
        }
    }

}
