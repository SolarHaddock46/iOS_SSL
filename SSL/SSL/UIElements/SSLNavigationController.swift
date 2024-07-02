import UIKit

class SSLNavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
    }

    private func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white

        appearance.shadowImage = UIImage()
        appearance.shadowColor = nil

        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 34, weight: .bold)
        ]
        appearance.largeTitleTextAttributes = attributes
        
        navigationBar.standardAppearance = appearance
        navigationBar.compactAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
        
        navigationBar.prefersLargeTitles = true
        navigationBar.isTranslucent = false
    }
}
