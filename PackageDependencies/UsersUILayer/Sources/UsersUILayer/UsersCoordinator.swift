import Foundation
import UserDetailsDomainLayerInterface
import UIKit
import UIUtilities

@MainActor
protocol UserUINavigation: AnyObject {
    func selectedUser(userName: String)
}

public final class UsersCoordinator: CoordinatorProtocol, UserUINavigation {
    @MainActor public private(set) var rootViewController: UIViewController
    public var parentCoordinator: CoordinatorProtocol?
    public var childCoordinators: [CoordinatorProtocol] = []

    private let repositoryFactory: UsersRepositoryFactoryProtocol
    
    public init(
        parentCoordinator: CoordinatorProtocol?,
        repositoryFactory: UsersRepositoryFactoryProtocol
    ) {
        self.parentCoordinator = parentCoordinator
        self.repositoryFactory = repositoryFactory
        self.rootViewController = UINavigationController()
    }

    @MainActor
    public func startFlow() {
        let viewModel = UserListViewModel(
            repository: repositoryFactory.makeListRepository(),
            navigationDelegate: self
        )
        let viewController = UserListViewController(viewModel: viewModel)
        (rootViewController as? UINavigationController)?.pushViewController(viewController, animated: false)
    }
    
    @MainActor
    public func finishFlow() {}
    
    func selectedUser(userName: String) {
        let viewModel = UserDetailViewModel(
            username: userName,
            repository: repositoryFactory.makeDetailsRepository()
        )
        let viewController = UserDetailViewController(viewModel: viewModel)
        (rootViewController as? UINavigationController)?.pushViewController(viewController, animated: false)
    }
}
