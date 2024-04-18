import Foundation

class LoginPresenter: LoginViewToPresenterProtocol, LoginInteractorToPresenterProtocol {
    var view: LoginPresenterToViewProtocol?
    var interactor: LoginPresenterToInteractorProtocol?
    var router: LoginPresenterToRouterProtocol?
    
    func loginSuccess(with response: UserDTO) {
        view?.showAlert(title: "Success", message: response.tokens.access)
    }

    func loginFailed(with error: NetworkError) {
        view?.showAlert(title: "Error", message: error.localizedDescription)
    }

    func startLogin(email: String, password: String) async throws {
        let user = LoginRequestDTO(email: email, password: password)
        try await interactor?.performLogin(with: user)
    }
}
