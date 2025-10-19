import Foundation
import UserDetailsDomainLayerInterface
import UIKit
import UIUtilities

public final class UsersCoordinator: CoordinatorProtocol {
    @MainActor public private(set) var rootViewController: UIViewController
    public var parentCoordinator: CoordinatorProtocol?
    public var childCoordinators: [CoordinatorProtocol] = []

    private let repository: UsersListRepositoryProtocol
    
    public init(
        parentCoordinator: CoordinatorProtocol?,
        repository: UsersListRepositoryProtocol
    ) {
        self.parentCoordinator = parentCoordinator
        self.repository = repository
        self.rootViewController = UINavigationController()
    }

    @MainActor
    public func startFlow() {
        let viewModel = UserListViewModel(repository: repository)
        let viewController = UserListViewController(viewModel: viewModel)
        (rootViewController as? UINavigationController)?.pushViewController(viewController, animated: false)
    }
    
    @MainActor
    public func finishFlow() {}
}
