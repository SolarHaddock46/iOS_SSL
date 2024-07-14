import Foundation
import UIKit

class LoginPresenter: LoginPresenterProtocol {
    weak var viewController: LoginViewControllerProtocol?
    private var loginDialog: LoginDialog?
    
    init(viewController: LoginViewControllerProtocol) {
        self.viewController = viewController
        
        if let viewController = viewController as? UIViewController {
            self.loginDialog = LoginDialog(viewController: viewController)
        }
    }
    
    func presentLoginResult(result: Result<LoginResponseDTO, NetworkError>) {
        switch result {
        case .success(let userDTO):
            loginDialog?.showAlert(title: "Success", message: userDTO.tokens.access)
        case .failure(let error):
            loginDialog?.showAlert(title: "Error", message: error.localizedDescription)
        }
    }
}
