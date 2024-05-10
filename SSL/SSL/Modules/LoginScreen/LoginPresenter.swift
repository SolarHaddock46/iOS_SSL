import Foundation

protocol LoginPresenterProtocol {
    var viewController: LoginViewControllerProtocol? { get set }
    func loginSuccess(with userDTO: UserDTO)
    func loginFailed(with error: NetworkError)
}

class LoginPresenter: LoginPresenterProtocol {
    weak var viewController: LoginViewControllerProtocol?
    
    func loginSuccess(with userDTO: UserDTO) {
        DispatchQueue.main.async {
            self.viewController?.showAlert(title: "Success", message: userDTO.tokens.access)
        }
    }
    
    func loginFailed(with error: NetworkError) {
        DispatchQueue.main.async {
            self.viewController?.showAlert(title: "Error", message: error.localizedDescription)
        }
    }
}
