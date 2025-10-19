import Foundation
import UIKit

@MainActor 
public protocol CoordinatorProtocol {
    var parentCoordinator: CoordinatorProtocol? { get }
    var childCoordinators: [CoordinatorProtocol] { get }

    var rootViewController: UIViewController { get }
    func startFlow()
    func finishFlow()
}
