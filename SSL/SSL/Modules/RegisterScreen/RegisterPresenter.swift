import Foundation

final class RegisterPresenter: RegisterViewToPresenterProtocol, RegisterInteractorToPresenterProtocol {
    var view: RegisterPresenterToViewProtocol?
    var interactor: RegisterPresenterToInteractorProtocol?
    var router: RegisterPresenterToRouterProtocol?
    
    func registerSuccess(with response: UserRegisterDTO) {
        view?.showAlert(title: "Success", message: response.firstName)
    }

    func registerFailed(with error: NetworkError) {
        view?.showAlert(title: "Error", message: error.localizedDescription)
    }

    func startRegister(firstName: String, secondName: String, fatherName: String?, telegram: String, email: String, password1: String, password2: String, image: String, hsePass: Bool, acceptConditions: Bool) async throws {
        let user = RegisterRequestDTO(firstName: firstName, secondName: secondName, fatherName: fatherName, telegram: telegram, email: email, password1: password1, password2: password2, image: image, hsePass: hsePass, acceptConditions: acceptConditions)
        try await interactor?.performRegister(with: user)
    }
}
