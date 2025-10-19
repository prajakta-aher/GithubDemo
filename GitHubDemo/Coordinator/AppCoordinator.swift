import UIKit
import UIUtilities
import UsersUILayer
import UserDetailsDomainLayer

final class AppCoordinator: CoordinatorProtocol {
    private(set) var rootViewController: UIViewController = UINavigationController()
    private(set) var parentCoordinator: CoordinatorProtocol?
    private(set) var childCoordinators: [CoordinatorProtocol] = []
    private let window: UIWindow

    init(window: UIWindow) {
        self.window = window
    }
    
    func startFlow() {
        let coordinator = UsersCoordinator(
            parentCoordinator: self,
            repositoryFactory: UsersRepositoryFactory(
                baseUrlString: URLHost.default.rawValue,
                networkClient: AppDependencies.shared.getNetworkClient()
            )
        )
        childCoordinators.append(coordinator)
        coordinator.startFlow()
        window.rootViewController = coordinator.rootViewController
    }
    
    func finishFlow() {}
}
