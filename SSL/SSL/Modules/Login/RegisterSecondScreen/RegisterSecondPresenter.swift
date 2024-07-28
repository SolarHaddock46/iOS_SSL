import UIKit

class RegisterSecondPresenter: RegisterSecondPresenterProtocol {
    
    weak var viewController: RegisterSecondViewControllerProtocol?
    private var dialog: RegisterSecondDialog?
    
    init(viewController: RegisterSecondViewControllerProtocol?) {
        self.viewController = viewController
        
        if let viewController = viewController as? UIViewController {
            dialog = RegisterSecondDialog(viewController: viewController)
        }
    }

    func registerSuccess(with response: RegisterResponse) {
        dialog?.showAlert(title: "Success", message: response.firstName)
    }

    func registerFailed(with error: NetworkError) {
        dialog?.showAlert(title: "Error", message: error.localizedDescription)
    }
}
