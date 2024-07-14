import Foundation

class LoginPresenter: LoginPresenterProtocol {

    weak var viewController: LoginViewControllerProtocol?
    
    func presentLoginResult(result: Result<LoginResponseDTO, Error>) {
        DispatchQueue.main.async {
            switch result {
            case .success(let userDTO):
                self.viewController?.displayLoginSuccess(message: userDTO.tokens.access)
            case .failure(let error):
                self.viewController?.displayLoginError(message: error.localizedDescription)
            }
        }
    }
}
