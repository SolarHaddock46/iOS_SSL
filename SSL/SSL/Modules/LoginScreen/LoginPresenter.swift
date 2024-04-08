import Foundation

class LoginPresenter: ViewToPresenterProtocol, InteractorToPresenterProtocol {
    var view: PresenterToViewProtocol?
    var interactor: PresenterToInteractorProtocol?
    var router: PresenterToRouterProtocol?
    
    func loginSuccess(with response: UserDTO) {
        view?.showAlert(title: "Success", message: response.email)
    }

    func loginFailed(with error: NetworkError) {
        view?.showAlert(title: "Error", message: error.localizedDescription)
    }

    func startLogin(email: String, password: String) async throws {
        let user = UserDTO(email: email, password: password)
        try await interactor?.performLogin(with: user)
    }
}
