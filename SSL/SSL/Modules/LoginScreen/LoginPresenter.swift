import Foundation

class LoginPresenter: ViewToPresenterProtocol, InteractorToPresenterProtocol {
    func loginSuccess(with response: UserDTO) {
        print("Success.")
    }

    func loginFailed(with error: String) {
        print("Error \(error)")
    }

    var view: PresenterToViewProtocol?
    var interactor: PresenterToInteractorProtocol?
    var router: PresenterToRouterProtocol?

    func startLogin(email: String, password: String) {
        let user = UserDTO(email: email, password: password)
        interactor?.performLogin(with: user)
    }
}
