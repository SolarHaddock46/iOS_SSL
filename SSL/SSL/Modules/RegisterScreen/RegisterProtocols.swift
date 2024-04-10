import Foundation
import UIKit

protocol RegisterInteractorToPresenterProtocol {
    func registerSuccess(with response: UserRegisterDTO)
    func registerFailed(with error: NetworkError)
}

protocol RegisterPresenterToInteractorProtocol {
    var presenter: RegisterInteractorToPresenterProtocol? { get set }
    func performRegister(with user: RegisterRequestDTO) async throws
}

protocol RegisterViewToPresenterProtocol {
    var view: RegisterPresenterToViewProtocol? { get set }
    var interactor: RegisterPresenterToInteractorProtocol? { get set }
    var router: RegisterPresenterToRouterProtocol? { get set }
    func startRegister(firstName: String, secondName: String, fatherName: String?, telegram: String, email: String, password1: String, password2: String, hsePass: Bool, acceptConditions: Bool) async throws
}

protocol RegisterPresenterToViewProtocol {
    var presenter: RegisterViewToPresenterProtocol? { get set }
    func showAlert(title: String, message: String)
    func hideLoading()
}

protocol RegisterPresenterToRouterProtocol {
    static func createModule() -> UIViewController
}

