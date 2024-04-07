import Foundation

class LoginPresenter: ViewToPresenterProtocol, InteractorToPresenterProtocol {
    var view: PresenterToViewProtocol?
    var interactor: PresenterToInteractorProtocol?
    var router: PresenterToRouterProtocol?
    
    func loginSuccess(with response: UserDTO) {
        view?.showAlert(title: "Success", message: response.email)
    }

    func loginFailed(with error: String) {
        view?.showAlert(title: "Error", message: error)
    }

    func startLogin(email: String, password: String) {
        let user = UserDTO(email: email, password: password)
        interactor?.performLogin(with: user)
    }
}
