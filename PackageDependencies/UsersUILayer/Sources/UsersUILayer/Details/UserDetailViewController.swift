import UIKit
import SwiftUI

public final class UserDetailViewController<ViewModel: UserDetailViewModelProtocol>: UIViewController {
    private let viewModel: ViewModel
    private var hostingController: UIHostingController<UserDetailView<ViewModel>>?

    init(
        viewModel: ViewModel
    ) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Lifecycle methods

    public override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the navigation bar to enable displaying the SwiftUI searchbar with searchable
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    // MARK: Private methods

    private func setupView() {
        view.backgroundColor = .systemBackground
        self.title = viewModel.title
        let contentController = UIHostingController<UserDetailView<ViewModel>>(
            rootView: UserDetailView<ViewModel>(
                viewModel: viewModel
            )
        )
        self.hostingController = contentController
        guard let swiftUIView = contentController.view else { return }
        self.addChild(contentController)
        swiftUIView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(swiftUIView)
        NSLayoutConstraint.activate(
            [
                swiftUIView.topAnchor.constraint(equalTo: view.topAnchor),
                swiftUIView.leftAnchor.constraint(equalTo: view.leftAnchor),
                swiftUIView.rightAnchor.constraint(equalTo: view.rightAnchor),
                swiftUIView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ]
        )
        hostingController?.didMove(toParent: self)
    }
}
