import Foundation
import UIKit

class RegisterSecondDialog {
    private weak var viewController: UIViewController?

    init(viewController: UIViewController) {
        self.viewController = viewController
    }

    func showAlert(title: String, message: String, buttonTitle: String = "OK", completion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: buttonTitle, style: .default) { _ in
                completion?()
            })
            self.viewController?.present(alert, animated: true, completion: nil)
        }
    }
}
